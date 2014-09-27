class AgencySearch
  
  def initialize(search_params)
    @search_params = search_params
    @chart_data = []
    @agency_sum_values= []
    @dates = []
    @agencies = @search_params[:agencies]
  end
  
  def search
    single_agency_check
    @agencies.each do |agency|
      agency_results = Contract.spending_per_agency(agency)
      format_date_results(agency_results)
    end
    @agencies.each do |agency|
      agency_results = Contract.spending_per_agency(agency)
      matched_name = Agency.find(agency).name
      format_value_results(agency_results, matched_name)
    end
    @chart_data
  end

  def single_agency_check
    if @agencies.kind_of? String
      @agencies = [@agencies.to_i]
    end
  end

  def format_date_results(agency_results)
    agency_results.each do |agency_spending_for_year|
      @dates << "#{agency_spending_for_year.year.round(0)}-01-01"
    end
    @chart_data << @dates.unshift("Date")
  end

  def format_value_results(agency_results, matched_name)
    agency_results.each do |agency_spending_for_year|
      @agency_sum_values << agency_spending_for_year.total
    end
    @chart_data << @agency_sum_values.unshift(matched_name)
  end

end
