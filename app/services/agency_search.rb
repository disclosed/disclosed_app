class AgencySearch
  
  def initialize(search_params)
    @agencies = search_params[:agencies]
  end
  
  def get_aggregate_chart_data
    chart_data = []
    @agencies.each do |agency|
      agency_match = match(agency)
      matched_name = Agency.find(agency).name
      chart_data << format_date_results(agency_match)
      chart_data << format_value_results(agency_match, matched_name)
    end
    chart_data
  end

  def get_full_contract_report
    report_data = []
    @agencies.each do |agency|
      Agency.find(agency).contracts.each do |contract|
        report_data << contract
      end
    end
    report_data
  end

  private

  def match(agency)
    Contract.spending_per_agency(agency)
  end

  def format_date_results(agency_match)
    dates = []
    agency_match.each do |agency_spending_for_year|
      dates << "#{agency_spending_for_year.year.round(0)}-01-01"
    end
    dates.unshift("Date")
  end

  def format_value_results(agency_match, matched_name)
    agency_sum_values= []
    agency_match.each do |agency_spending_for_year|
      agency_sum_values << agency_spending_for_year.total
    end
    agency_sum_values.unshift(matched_name)
  end

end
