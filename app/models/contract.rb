class Contract < ActiveRecord::Base
  belongs_to :agency

  validates :reference_number, presence: true, uniqueness: true
  validates :url,            presence: true
  validates :vendor_name,    presence: true
  validates :value,          presence: true
  validates :agency,         presence: true

  # date_string - the start date and end date of the contract
  # Most contracts seem to look like this...
  #             ex: 2013-10-18 to 2013-10-20
  #             ex: 2013-10-18 à 2013-10-20
  #             ex: May 1, 2008 to April 30, 2011
  #             ex: 2013-10-18
  # Returns an array with the two dates
  # If there is no end date, the end date is nil
  def self.extract_dates(date_string)
    return [nil, nil] if !date_string.present?
    date_range_match = date_string.match(/(.*)\sto\s(.*)/i)
    date_range_match ||= date_string.match(/(\d{4}\-\d{2}\-\d{2})\s*to\s*(\d{4}\-\d{2}\-\d{2})/)
    date_range_match ||= date_string.match(/(\d{4}\-\d{2}\-\d{2})\s*\-\s*(\d{4}\-\d{2}\-\d{2})/)
    date_range_match ||= date_string.match(/(.*)\&agrave;(.*)/i)
    if date_range_match
      start_date = Chronic.parse(date_range_match[1])
      end_date   = Chronic.parse(date_range_match[2])
      if start_date.nil? || end_date.nil?
        raise ArgumentError, "Don't know how to parse contract period string: #{date_string}"
      end
    else
      start_date = Chronic.parse(date_string)
      if start_date.nil? # not a single date
        raise ArgumentError, "Don't know how to parse contract period string: #{date_string}"
      end
    end
    [start_date.to_date, end_date.try(:to_date) || nil]
  end

  def self.create_or_update!(attrs)
    contract = self.find_by(reference_number: attrs[:reference_number])
    if contract
      contract.update_attributes!(attrs)
    else
      contract = Contract.create!(attrs)
    end
    contract
  end

end

