class ContractSearch
  
  def initialize(params)
    @search_params = { 
      vendors: params[:vendors],
      agencies: params[:agencies],
      effective_date: params[:effective_date]
    }
    remove_empty_searchbox_queries if params[:vendors]
    @search_request = determine_search_type.classify.constantize.new(@search_params)
  end

  def execute_chart_search
    @search_request.get_aggregate_chart_data
  end

  def execute_report_search
    @search_request.get_full_contract_report
  end

  private

  def remove_empty_searchbox_queries
    @search_params[:vendors].delete("")
  end

  def determine_search_type
    if !@search_params[:vendors].blank?
      "VendorSearch"
    elsif !@search_params[:agencies].blank?
      "AgencySearch"
    else
      "TotalSearch"
    end
  end

end

