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
    rescue CSV::MalformedCSVError => e
      raise "Could not parse CSV file. Original error: #{e.message}"
    rescue StandardError => e
      raise "Could not load CSV file. Make sure the file has CSV headers. Original error: #{e.message}"
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
      start_date:       get_start_date(contract[:contract_period]),
      end_date:         get_end_date(contract[:contract_period]),
      value:       contract[:contract_value].to_i,
      description: contract[:description_of_work],
      comments:    contract[:comments]
    }
  end

  # date_string - the start date and end date of the contract
  #             ex: 2013-10-18 to 2013-10-18
  #             ex: May 1, 2008 to April 30, 2011
  # Returns an array with the two date strings
  def extract_dates(date_string)
    dates = date_string.match(/(.*)\sto\s(.*)/)
    if !dates
      raise "Don't know how to parse contract period string: #{date_string}"
    end
    dates[1, 2]
  end

  # date_string - the start date and end date of the contract
  #             ex: 2013-10-18 to 2013-10-18
  #             ex: May 1, 2008 to April 30, 2011
  # Returns a ruby date object with the first date
  def get_start_date(date_string)
    date = extract_dates(date_string).first
    Chronic.parse(date)
  end

  # date_string - the start date and end date of the contract
  #             ex: 2013-10-18 to 2013-10-18
  #             ex: May 1, 2008 to April 30, 2011
  # Returns a ruby date object with the last date
  def get_end_date(date_string)
    date = extract_dates(date_string).last
    Chronic.parse(date)
  end
end
