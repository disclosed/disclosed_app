# The order of the columns in the CSV file is
# url, agency name, vendor name, reference number, effective date, description, period start and end date as string, SOMETHING??, value, comments

require "csv"
class ContractLoader
  
  attr_reader :contracts, :skipped_count

  def initialize(file_path)
    @contracts = []
    @skipped_count = 0
    config_csv_converter
    parse(file_path)
  end

  def upsert_into_db!
    @contracts.each do |contract|
      attributes = build_attributes(contract)
      if !valid_attributes?(attributes)
        @skipped_count += 1
        next
      end
      existing_contract = Contract.where(reference_number: attributes[:reference_number]).first
      if existing_contract
        existing_contract.update_attributes!(attributes)
      else
        Contract.create!(attributes)
      end
    end
  end

  private
  def config_csv_converter
    CSV::Converters[:blank_to_nil] = lambda do |field|
      field && field.empty? ? nil : field
    end
  end

  # Read the CSV from a file and return the contents of the file
  # as an array of hashes.
  def parse(file_path)
    begin
      rows = CSV.read(file_path, headers: true, header_converters: :symbol, converters: [:all, :blank_to_nil])
    rescue CSV::MalformedCSVError => e
      raise "Could not parse CSV file. Original error: #{e.message}"
    rescue StandardError => e
      raise "Could not load CSV file. Make sure the file has CSV headers. Original error: #{e.message}"
    end
    @contracts = rows.collect {|row| row.to_hash }
  end

  def valid_attributes?(attrs)
    return false if !attrs.present?
    return false if !attrs[:reference_number].present?
    return true
  end

  def build_attributes(contract)
    begin
      start_date, end_date = Contract.extract_dates(contract[:contract_period])
    rescue ContractLoaderError
      return nil
    end
    {
      url: contract[:url],
      agency: Agency.find_or_create_by(name: contract[:agency]),
      vendor_name:      contract[:vendor_name] || "Unknown",
      reference_number: contract[:reference_number].try(:to_s),
      effective_date:   contract[:contract_date].try(:to_date),
      start_date:       start_date,
      end_date:         end_date,
      value:       contract[:contract_value].to_i,
      description: contract[:description_of_work],
      comments:    contract[:comments]
    }
  end

end

class ContractLoaderError < StandardError; end;
