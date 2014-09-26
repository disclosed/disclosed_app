class ContractSearch
  
  def initialize(search_params)
    @search_params = search_params
    @search_type = determine_search_type 
  end

  def determine_search_type
    if @search_params[:vendor].kind_of? String
      "VendorSearch"
    elsif @search_params[:agency].kind_of String
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

