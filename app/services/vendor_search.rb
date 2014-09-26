require 'debugger'

class VendorSearch
  # Vendor Search has a 1 vendor to many agency graph. The user is able to view several agencies' contract amounts over a period of time given a searched vendor name. 
  def initialize(search_params)
    @search_params = search_params
  end
  # Search method looks at the given params by the search query to return an array of a given contract.
  def search
    vendor = @search_params[:vendor]
    chart_data = []
    vendor_sum_values = []
    results = Contract.spending_per_vendor(vendor)
    matched_name = Contract.vendor_name(vendor)[0].vendor_name
    results.each do |obj|
      vendor_sum_values << obj.total
    end
    chart_data << vendor_sum_values.unshift(matched_name) 
  end 
end
