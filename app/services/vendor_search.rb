class VendorSearch

  def initialize(search_params)
    search_params[:vendors].delete("")
    @vendors = search_params[:vendors]
  end

  def get_aggregate_chart_data
    chart_data = []
    no_match_msgs = []
    @vendors.each do |vendor|
      vendor_match = match(vendor)
      if !vendor_match.empty?
        matched_name = Contract.vendor_name(vendor).first.vendor_name
        chart_data << format_date_results(vendor_match)
        chart_data << format_value_results(vendor_match, matched_name)
      else
        no_match_msgs << "No matching vendor found for \"#{vendor}\""
      end
    end
    return chart_data, no_match_msgs
  end

  def get_full_contract_report
    report_data = []
    @vendors.each do |vendor|
      vendor_results = Contract.vendor_name(vendor)
      if !vendor_results.empty?
        vendor_results.each do |result|
          report_data << result
        end
      end
    end
    report_data
  end

  private

  def match(vendor)
    Contract.spending_per_vendor(vendor)
  end

  private

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
