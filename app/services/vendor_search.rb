class VendorSearch

  def initialize(search_params)
    search_params[:vendors].delete("")
    @vendors = search_params[:vendors]
    @chart_data = []
  end

  def search
    find_aggregate_dates
    find_aggregate_values
    @chart_data
  end

  def find_aggregate_dates
    @vendors.each do |vendor|
      vendor_results = Contract.spending_per_vendor(vendor)
      @chart_data << format_date_results(vendor_results)
    end
  end

  def find_aggregate_values
    @vendors.each do |vendor|
      vendor_results = Contract.spending_per_vendor(vendor)
      matched_name = Contract.vendor_name(vendor).first.vendor_name
      @chart_data << format_value_results(vendor_results, matched_name)
    end
  end

  def format_date_results(vendor_results)
    dates = []
    vendor_results.each do |vendor_spending_for_year|
      dates << "#{vendor_spending_for_year.year.round(0)}-01-01"
    end
    dates.unshift("Date")
  end

  def format_value_results(vendor_results, matched_name)
    vendor_sum_values =[]
    vendor_results.each do |vendor_spending_for_year|
      vendor_sum_values << vendor_spending_for_year.total
    end
    vendor_sum_values.unshift(matched_name)
  end

end
