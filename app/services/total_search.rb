class TotalSearch

  def initialize(search_params)
    @search_params = search_params
    @chart_data = []
    @dates = []
    @total = []
  end

  def search
    results = Contract.total_spending
    format_output(results)
  end

  def format_output(results)
    results.each do |obj|
      @total << obj.total
      @dates << obj.year
    end
    @chart_data << @dates.unshift("Date")
    @chart_data << @total.unshift("Total Contract Spending")
  end

end