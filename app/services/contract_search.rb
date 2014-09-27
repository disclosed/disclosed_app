class ContractSearch
  
  def initialize(params)
    @search_params = { 
      vendor: params[:vendor],
      agencies: params[:agencies],
      effective_date: params[:effective_date]
    }
    #debugger
    @search_type = determine_search_type 
  end

  def determine_search_type
    if !@search_params[:vendor].blank?
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

