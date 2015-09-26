module Scrapers::TextHelpers
  def clean_nbsp(value)
    value.gsub("\u00A0", ' ')
  end

  def clean_dash(value)
    value.gsub("\u2011", '-')
  end

  def parse_date(value)
    return nil if value.blank?
    begin
      Date.parse(value)
    # Date.parse throws an argument error if date is invalid. Raise a better exception
    rescue ArgumentError => e
      raise "Invalid date. #{value}"
    end
  end

  def parse_value(value)
    Monetize.parse(value).cents / 100
  end
end
