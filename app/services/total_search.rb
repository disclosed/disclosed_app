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
    results.each do |contract|
      @total << contract.total
      @dates << "#{contract.year.round(0)}-01-01"
    end
    @chart_data << @dates.unshift("Date")
    @chart_data << @total.unshift("Total Contract Spending")
  end

end
