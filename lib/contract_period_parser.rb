# Takes in a raw contract period string and returns the start and end date.
#
# raw_date - the start date and end date of the contract
# Most contracts seem to look like this...
#             ex: 2013-10-18 to 2013-10-20
#             ex: 2013-10-18 à 2013-10-20
#             ex: May 1, 2008 to April 30, 2011
#             ex: 2013-10-18
# If there is no end date, the end date is nil

class ContractPeriodParser
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::QueryAttributes
  include ActiveAttr::Logger
  include ActiveModel::Validations

  attribute :raw_date
  validates :raw_date, presence: true
  attribute :start_date, :type => Date
  validates :start_date, presence: true
  attribute :end_date, :type => Date

  def initialize(raw_date)
    self.raw_date = raw_date
    super()
  end

  def parse
    return if !self.raw_date?
    date_range_match = raw_date.match(/(.*)\sto\s(.*)/i)
    date_range_match ||= raw_date.match(/(\d{4}\-\d{2}\-\d{2})\s*to\s*(\d{4}\-\d{2}\-\d{2})/)
    date_range_match ||= raw_date.match(/(\d{4}\-\d{2}\-\d{2})\s*\-\s*(\d{4}\-\d{2}\-\d{2})/)
    date_range_match ||= raw_date.match(/(.*)\&agrave;(.*)/i)

    if date_range_match
      self.start_date = Chronic.parse(date_range_match[1])
      self.end_date   = Chronic.parse(date_range_match[2])
    else
      self.start_date = Chronic.parse(raw_date)
    end
  end
end
