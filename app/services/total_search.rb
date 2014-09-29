class TotalSearch

  def initialize(search_params)
    @search_params = search_params
    @chart_data = []
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

  def format_results(results)
    totals = []
    dates = []
    results.each do |contract|
      totals << contract.total
      dates << "#{contract.year.round(0)}-01-01"
    end
    @chart_data << dates.unshift("Date")
    @chart_data << totals.unshift("Total Contract Spending")
  end

end
