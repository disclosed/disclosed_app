class Agency < ActiveRecord::Base
  class UnknownAgency < RuntimeError;end;

  has_many :contracts

  validates :name, presence: true
  validates :abbr, presence: true, uniqueness: true

  before_validation :extract_abbr, on: :create
  
  scope :agency_name, -> (agency_query) do 
   return none if agency_query.blank? 
   where("name like ?", "%#{agency_query}%")
  end 

  scope :abbr, -> (abbr) do 
    return none if abbr.blank?
    where("abbr like ?", "%#{abbr}") 
  end

  def self.spending_per_agency(agency)
    agency_name = ActiveRecord::Base.sanitize(agency)
    find_by_sql("SELECT SUM(value) AS total, SELECT(year FROM contracts.effective_date) AS year FROM contracts INNER JOIN agencies ON(contracts.agency_id = agencies.id) WHERE contracts.vendor_name ILIKE #{agency_name} GROUP BY year ORDER BY year")
  end

  protected
  def extract_abbr
    return unless self.abbr.blank?
    return if self.name.blank?
    agency_key = self.name.downcase
    unless AGENCIES.keys.include? agency_key
      raise UnknownAgency, "Unknown agency #{agency_key}. Must be one of #{AGENCIES.keys.inspect}"
    end
    self.abbr = AGENCIES[agency_key]["alias"]
  end
   
end

