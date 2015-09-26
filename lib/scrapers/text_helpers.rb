module Scrapers::TextHelpers
  def clean_nbsp(value)
    value.gsub("\u00A0", ' ')
  end

  def clean_all_spaces(value)
    value.gsub(/[\n\t]/, ' ').gsub(/\s+/, ' ')
  end

  def clean_dash(value)
    value.gsub("\u2011", '-')
  end

  def parse_date(value)
    return nil if value.blank?
    begin
      Date.parse(value)
    rescue ArgumentError => e
      # Sometimes the problem with dates is that the the month and day are switched
      # Try parsing the date again with the month and day reversed.
      year, day, month = value.match(/(\d{4})[-\/](\d{2})[-\/](\d{2})/).captures
      begin 
        Date.parse("#{year}-#{month}-#{day}")
      rescue ArgumentError => e
        puts "Invalid date. #{value}"
      end
    end
  end

  def parse_value(value)
    Monetize.parse(value).cents / 100
  end
end
