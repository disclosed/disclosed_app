# The ContractLoader reads in a csv produced by one of the old scrapers.
# The rows are converted to hashes and mapped to the structure needed by the database.
#
# The order of the columns in the CSV file is
# url, agency name, vendor name, reference number, effective date, description, period start and end date as string, SOMETHING??, value, comments
# The final schema is:
# {"url"=>"http://www.veterans.gc.ca/eng/sub.cfm?source=department/dco10k/d_details&cont_id=470&profile=vac", 
#  "vendor_name"=>"Syst&egrave;mes Influatec Inc.", 
#  "reference_number"=>"5511-04-0248", 
#  "start_date"=>Fri, 01 Apr 2005, 
#  "end_date"=>Fri, 31 Mar 2006, 
#  "effective_date"=>Thu, 31 Mar 2005, 
#  "value"=>29, 
#  "description"=>"1228 Computer Software", 
#  "comments"=>nil, 
#  "agency_id"=>80,
#  "raw_contract_period" => "2005-04-01 until 2006-03-31"
# }
require "csv"
class ContractLoader
  
  attr_reader :contracts, :skipped_count

  def initialize(file_path)
    @contracts = []
    @skipped_count = 0
    @logger = Logger.new(File.join(Rails.root, "log", "contract_loader.log"))
    config_csv_converter
    parse(file_path)
  end

  def upsert_into_db!(&callback)
    @contracts.each_with_index do |contract, i|
      attributes = build_attributes(contract)
      context = SaveContractFromScraper.call(attributes: attributes, agency: attributes[:agency])
      if context.success?
        yield(i) if block_given?
      else
        @skipped_count += 1
        @logger.warn "Invalid data #{attributes.inspect}"
        @logger.warn context.message
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
      {
        url: contract[:url],
        agency: Agency.find_or_create_by(name: contract[:agency]),
        vendor_name:      contract[:vendor_name],
        reference_number: contract[:reference_number].try(:to_s),
        effective_date:   contract[:contract_date].try(:to_date),
        raw_contract_period: contract[:contract_period],
        value:       contract[:contract_value].to_i / 1000,
        description: contract[:description_of_work],
        comments:    contract[:comments]
      }
    rescue ArgumentError => e
      @logger.warn "\nCould not build attributes. #{e} #{contract}.\n"
      return nil
    end
  end

end

class ContractLoaderError < StandardError; end;
