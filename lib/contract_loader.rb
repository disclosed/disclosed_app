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
      print "."
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
    rescue CSV::MalformedCSVError => e
      raise "Could not parse CSV file. Original error: #{e.message}"
    rescue StandardError => e
      raise "Could not load CSV file. Make sure the file has CSV headers. Original error: #{e.message}"
    end
    @contracts = rows.collect {|row| row.to_hash }
  end

  def build_attributes(contract)
    start_date, end_date = extract_dates(contract[:contract_period])
    {
      url: contract[:url],
      agency: Agency.find_or_create_by(name: contract[:agency]),
      vendor_name:      contract[:vendor_name] || "Unknown",
      reference_number: contract[:reference_number],
      effective_date:   contract[:contract_date].try(:to_date),
      start_date:       start_date,
      end_date:         end_date,
      value:       contract[:contract_value].to_i,
      description: contract[:description_of_work],
      comments:    contract[:comments]
    }
  end

  # date_string - the start date and end date of the contract
  # Most contracts seem to look like this...
  #             ex: 2013-10-18 to 2013-10-20
  #             ex: 2013-10-18 à 2013-10-20
  #             ex: May 1, 2008 to April 30, 2011
  #             ex: 2013-10-18
  # Returns an array with the two dates
  # If there is no end date, the end date is nil
  # FIXME: Move this logic into the scraper.
  def extract_dates(date_string)
    return [nil, nil] if !date_string.present?
    date_range_match = date_string.match(/(.*)\sto\s(.*)/i)
    date_range_match ||= date_string.match(/(\d{4}\-\d{2}\-\d{2})\s*to\s*(\d{4}\-\d{2}\-\d{2})/)
    date_range_match ||= date_string.match(/(.*)\&agrave;(.*)/i)
    if date_range_match
      start_date = Chronic.parse(date_range_match[1])
      end_date   = Chronic.parse(date_range_match[2])
      if start_date.nil? || end_date.nil?
        raise ContractLoaderError, "Don't know how to parse contract period string: #{date_string}"
      end
    else
      start_date = Chronic.parse(date_string)
      if start_date.nil? # not a single date
        raise "Don't know how to parse contract period string: #{date_string}"
      end
    end
    [start_date.to_date, end_date.try(:to_date) || nil]
  end
end

class ContractLoaderError < StandardError; end;
