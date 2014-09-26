class AgencySearch
  
  def initialize(search_params)
    @search_params = search_params
    @chart_data = []
    @agency_sum_values= []
    @dates = []
    @agency = @search_params[:agency]
  end
  
  def search
    results = Agency.spending_per_agency(@agency)
    matched_name = Agency.agency_name(@agency)
    format_output(results, matched_name)
  end

  def format_ouput(results, matched_name)
    results.each do |contract|
      @agency_sum_values << contract.total
      @dates << contract.year
    end
    @chart_data << @dates.unshift("Date")
    @chart_data << @vendor_sum_values.unshift(matched_name)
  end
end
