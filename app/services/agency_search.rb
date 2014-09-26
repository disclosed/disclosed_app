class AgencySearch
  
  def initialize(search_params)
    @search_params = search_params
    @chart_data = []
    @vendor_sum_values = []
    @dates = []
    @vendor = @search_params[:vendor]
  end
  
  def search
  end

  def format_ouput(results, matched_name)
  end
end

