require 'debugger'

class VendorSearch

  def initialize(search_params)
    @search_params = search_params
  end

  def search
    vendor = @search_params[:vendor]
    agencies = Agency.all || @search_params[:agency_id]
    agencies.each do |agency|
      contract = agency.contracts.vendor_name(vendor)
      contract.to_a
      making_json(contract)
    end
  end 
  
  def making_json(contract)
    value = []
    value = contract[7]
    agency_abbr = Agency.abbr.where(contract[11])
    filtered_result = [value, agency_abbr]
    filtering_hash = Hash[filtered_result.map { |k, v| [agency_abbr, value] }]
  end
end
