class Agency < ActiveRecord::Base
  class UnknownAgency < RuntimeError;end;

  has_many :contracts

  validates :name, presence: true
  validates :abbr, presence: true, uniqueness: true

  before_validation :extract_abbr, on: :create
  
  scope :agency_name, -> (agency_id) do 
   return none if agency_id.blank? 
   where("id ?", "#{agency_id}")
  end 
 
  scope :abbr, -> (abbr) do 
    return none if abbr.blank?
    where("abbr like ?", "%#{abbr}") 
  end

  def self.spending_per_agency(agency)
    agency_id = ActiveRecord::Base.sanitize(agency)
    find_by_sql("SELECT SUM(value) AS total,EXTRACT(year FROM contracts.effective_date) AS year FROM contracts INNER JOIN agencies ON(contracts.agency_id = agencies.id) WHERE agencies.id = #{agency_id} GROUP BY year ORDER BY year")
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

