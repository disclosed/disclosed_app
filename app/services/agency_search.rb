class AgencySearch
  
  def initialize(search_params)
    @agencies = search_params[:agencies]
    @chart_data = []
  end
  
  def search
    find_aggregate_dates
    find_aggregate_values   
    @chart_data
  end

  def find_aggregate_dates
    @agencies.each do |agency|
      agency_results = Contract.spending_per_agency(agency)
      @chart_data << format_date_results(agency_results)
    end
  end

  def find_aggregate_values
    @agencies.each do |agency|
      agency_results = Contract.spending_per_agency(agency)
      matched_name = Agency.find(agency).name
      @chart_data << format_value_results(agency_results, matched_name)
    end
  end

  def format_date_results(agency_results)
    dates = []
    agency_results.each do |agency_spending_for_year|
      dates << "#{agency_spending_for_year.year.round(0)}-01-01"
    end
    dates.unshift("Date")
  end

  def format_value_results(agency_results, matched_name)
    agency_sum_values= []
    agency_results.each do |agency_spending_for_year|
      agency_sum_values << agency_spending_for_year.total
    end
    agency_sum_values.unshift(matched_name)
  end

end
