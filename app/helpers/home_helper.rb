module HomeHelper

  def should_show_download_link?
    @messages.empty? && # search error
    (filtering_by_agencies? && number_of_agencies < 10 ||
    filtering_by_vendors? && number_of_vendors < 10)
  end

  private
  def filtering_by_agencies?
    params.has_key?(:agencies)
  end

  def filtering_by_vendors?
    params.has_key?(:vendors) && !params[:vendors].blank?
  end

  def number_of_vendors
    params[:vendors].length
  end

  def number_of_agencies
    params[:vendors].length
  end
end
