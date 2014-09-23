class VendorSearch

  def initialize(search_params)
    @search_params = search_params
  end

  def search
    vendor = @search_params[:vendor]
    agencies = Agency.all.limit(5) || @search_params[:agency_id]
    contracts = Contract.none
    agencies.each do |agency|
      agency.contracts.vendor_name(vendor)
    end
    return contracts
  end
end
