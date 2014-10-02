class TotalSearch

  def initialize(search_params)
    @search_params = search_params
  end

  def get_aggregate_chart_data
    results = Contract.total_spending
    format_results(results)
  end

  def get_full_contract_report
    report_data = []
    Agency.all.each do |agency|
      Agency.find(agency).contracts.each do |contract|
        report_data << contract
      end
    end
    report_data
  end

  private

  def format_results(results)
    chart_data = []
    median_spending = []
    totals = []
    dates = []
    results.each do |contract|
      totals << contract.total
      median_spending << contract.median(:total)
      dates << "#{contract.year.round(0)}-01-01"
    end
    chart_data << dates.unshift("Date")
    chart_data << median_spending.unshift("Median Contract Spending")
    chart_data << totals.unshift("Total Contract Spending")
  end

end
