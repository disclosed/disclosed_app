class VendorSearch

  def initialize(search_params)
    search_params[:vendors].delete("")
    @vendors = search_params[:vendors]
    @chart_data = []
  end

  def search
    @vendors.each do |vendor|
      vendor_match = match(vendor)
      matched_name = Contract.vendor_name(vendor).first.vendor_name
      @chart_data << format_date_results(vendor_match)
      @chart_data << format_value_results(vendor_match, matched_name)
    end
    @chart_data
  end

  def match(vendor)
    Contract.spending_per_vendor(vendor)
  end

  def format_date_results(vendor_match)
    dates = []
    vendor_match.each do |vendor_spending_for_year|
      dates << "#{vendor_spending_for_year.year.round(0)}-01-01"
    end
    dates.unshift("Date")
  end

  def format_value_results(vendor_match, matched_name)
    vendor_sum_values =[]
    vendor_match.each do |vendor_spending_for_year|
      vendor_sum_values << vendor_spending_for_year.total
    end
    vendor_sum_values.unshift(matched_name)
  end

end
