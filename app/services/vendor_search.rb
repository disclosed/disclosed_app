require 'debugger'

class VendorSearch

  def initialize(search_params)
    @search_params = search_params
  end

  def search
    vendor = @search_params[:vendor]
    agencies = Agency.all || @search_params[:agency_id]
    contracts = [] 
    agencies.each do |agency|
      contracts << agency.contracts.vendor_name(vendor)
    end
    filtered_hash = Hash[contracts.map {|key, value| [key, value]}]
  end
end
