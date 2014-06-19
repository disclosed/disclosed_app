# The order of the columns in the CSV file is
# url, agency name, vendor name, reference number, effective date, description, period start and end date as string, SOMETHING??, value, comments

require "csv"
class ContractLoader
  
  attr_reader :contracts

  def initialize(file_path)
    @contracts = []
    config_csv_converter
    parse(file_path)
  end

  def upsert_into_db!
    @contracts.each do |contract|
      ref_no = contract[:reference_number].to_s
      raise "Contract must have a reference number. #{contract.inspect}" unless ref_no
      attributes = build_attributes(contract)
      if existing_contract = Contract.where(reference_number: ref_no).first
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
    rescue StandardError => e
      raise "Could not load CSV file. Make sure the URL is correct and the returned CSV file has headers. Original error: #{e.message}"
    end
    @contracts = rows.collect {|row| row.to_hash }
  end

  def build_attributes(contract)
    {
      url: contract[:url],
      agency: Agency.find_or_create_by(name: contract[:agency]),
      vendor_name:      contract[:vendor_name],
      reference_number: contract[:reference_number],
      effective_date:   contract[:contract_date].to_date,
      start_date:       get_start_date(contract),
      end_date:         get_end_date(contract),
      value:       contract[:contract_value].to_i,
      description: contract[:description_of_work],
      comments:    contract[:comments]
    }
  end

  def split_contract_period(contract_hash)
    return contract_hash[:contract_period].split
  end

  def get_start_date(contract_hash)
    dates = split_contract_period(contract_hash)
    dates.first.to_date
  end

  def get_end_date(contract_hash)
    dates = split_contract_period(contract_hash)
    return dates.last.to_date if dates.length > 1
  end
end
