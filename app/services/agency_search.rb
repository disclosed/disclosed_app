class AgencySearch
  
  def initialize(search_params)
    @search_params = search_params
    @chart_data = []
    @agency_sum_values= []
    @dates = []
    @agency = @search_params[:agency]
  end
  
  def search
    results = Contract.spending_per_agency(@agency)
    matched_name = Agency.find(@agency).name
    format_output(results, matched_name)
  end

  def format_output(results, matched_name)
    results.each do |agency|
      @agency_sum_values << agency.total
      @dates << agency.year
    end
    @chart_data << @dates.unshift("Date")
    @chart_data << @agency_sum_values.unshift(matched_name)
  end
end
