class ContractSearch
  
  def initialize(params)
    @search_params = { 
      vendors: params[:vendors],
      agencies: params[:agencies],
      effective_date: params[:effective_date]
    }
    @search_type = determine_search_type 
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
  
  def perform
    search_object = @search_type.classify.constantize.new(@search_params)
    search_object.search
  end

end

