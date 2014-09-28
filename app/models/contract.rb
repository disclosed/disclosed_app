class Contract < ActiveRecord::Base
  belongs_to :agency

  validates :reference_number, presence: true, uniqueness: true
  validates :url,            presence: true
  validates :vendor_name,    presence: true
  validates :value,          presence: true
  validates :agency,         presence: true
  
  scope :vendor_name, -> (vendor) do
    return none if vendor.blank?
    where("lower(vendor_name) like ?", "%#{vendor.downcase}%") 
  end

  scope :effective_date, -> (effective_date) do
   return none if effective_date.blank?
   where effective_date: effective_date 
  end

  scope :description, -> (description) do
    return none if description.blank?
    where("description like ?", "%#{description}%")
  end 

  scope :value, -> (value) do 
    return none if description.blank?
    where("value > ?", value)
  end
# spending per vendor per year per all agencies
  def self.spending_per_vendor(vendor)
    vendor_name = ActiveRecord::Base.sanitize(vendor + "%")
    find_by_sql("SELECT SUM(value) AS total, EXTRACT(year FROM effective_date) AS year FROM contracts WHERE vendor_name ILIKE #{vendor_name} GROUP BY year ORDER BY year")
  end

  def self.total_spending
    find_by_sql("SELECT SUM(value) AS total, EXTRACT(year FROM effective_date) AS year FROM contracts GROUP BY year ORDER BY year")
  end

   def self.spending_per_agency(agency)
    find_by_sql("SELECT SUM(value) AS total, EXTRACT(year FROM effective_date) AS year FROM contracts WHERE agency_id = #{agency} GROUP BY year ORDER BY year")
  end

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
  
  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |contract|
        csv << contract.attributes.values_at(*column_names)
      end
    end
  end

  # Economic object code is the numbered category for description of the services provided by vendor. 
end

