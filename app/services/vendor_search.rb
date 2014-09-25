require 'debugger'

class VendorSearch
  # Vendor Search has a 1 vendor to many agency graph. The user is able to view several agencies' contract amounts over a period of time given a searched vendor name. 
  def initialize(search_params)
    @search_params = search_params
  end
  # Search method looks at the given params by the search query to return an array of a given contract.
  def search
    vendor = @search_params[:vendor]
    contracts = []
    value = Contract.sum_values(vendor)
    filtered_result = [vendor, value]
    filtered_hash = Hash[filtered_result.map {|k, v| [vendor, value] }]
  end 
end
