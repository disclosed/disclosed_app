class ContractSearch
  
  def initialize(params)
    @search_params = { 
      vendor: params[:vendor],
      agency: params[:agency_query],
      effective_date: params[:effective_date]
    }
    @search_type = determine_search_type 
  end

  def determine_search_type
    if !@search_params[:vendor].blank?
      "VendorSearch"
    elsif !@search_params[:agency].blank?
      "AgencySearch"
    else
      "TotalSearch"
    end
  end
  
  def perform
    search_object = @search_type.classify.constantize.new(@search_params)
    search_object.search
  end

  def count_params?
  end
end

