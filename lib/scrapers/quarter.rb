class Scrapers::Quarter < Struct.new(:year, :quarter)
  QUARTER_MONTH_RANGES = [(4..6), (7..9), (10..12), (1..3)].freeze
  QUARTER_SEQUENCE = [4, 1, 2, 3] # the order of the quarters in a year
                                  # the year starts with the 4th quarter
  FORMAT_REGEX = /\A(\d{4})q([1-4])\Z/i
  def self.parse(quarter_string = "")
    matches, year, quarter = quarter_string.match(FORMAT_REGEX).to_a
    raise ArgumentError, "Quarter string is invalid. Should be something like 2013q4" if !year or !quarter
    self.new(year.to_i, quarter.to_i)
  end

  def -(num_quarters)
    new_year = year - (num_quarters / 4)
    quarter_sequence_index = (QUARTER_SEQUENCE.index(quarter) - num_quarters)
    new_quarter = QUARTER_SEQUENCE[quarter_sequence_index % 4]
    if quarter_sequence_index < 0
      new_year = year + (quarter_sequence_index / 4)
    else
      new_year = year
    end
    Scrapers::Quarter.new(new_year, new_quarter)
  end

  def +(num_quarters)
    self - (-num_quarters)
  end

  def next
    self + 1
  end

  def valid?
    valid_year?(year) && valid_quarter?(quarter)
  end
  
  def to_s
    "#{year}q#{quarter}"
  end

  # Government of Canada Quarters
  # 4th Quarter  (2014-01-01 - 2014-03-31)
  # 3rd Quarter  (2013-10-01 - 2013-12-31)
  # 2nd Quarter  (2013-07-01 - 2013-09-30)
  # 1st Quarter  (2013-04-01 - 2013-06-30)
  # 4th Quarter  (2013-01-01 - 2013-03-31)
  def self.latest
    current_year = Date.today.year
    current_month = Date.today.month
    quarter_number = quarter_from_month(current_month)
    self.new(current_year, quarter_number)
  end

  def self.from_date(date)
    quarter_number = quarter_from_month(date.month)
    self.new(date.year, quarter_number)
  end

  private
  def valid_year?(year)
     year.present? && year > 2004 && year <= Date.today.year
  end

  def valid_quarter?(quarter)
    (1..4).include?(quarter)
  end

  # Returns a number between 1 - 4 representing the quarter.
  #
  # month_number: A number between 1 - 12 representing the month.
  def self.quarter_from_month(month_number)
    QUARTER_MONTH_RANGES.index {|range| range.include?(month_number)} + 1
  end

end

