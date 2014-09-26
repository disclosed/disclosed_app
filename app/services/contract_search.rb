class ContractSearch
  
  def initialize(search_params)
    @search_params = search_params
    @search_type = determine_search_type 
  end

  def determine_search_type
    if @search_params[:vendor].has_key?
      "VendorSearch"
    elsif @search_params[:agency].has_key?
      "AgencySearch"
    else

    end
  end
  
  def perform
    search_object = @search_type.classify.constantize.new(@search_params)
    search_object.search
  end

  def count_params?
  end
end

