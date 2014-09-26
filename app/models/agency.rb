class Agency < ActiveRecord::Base
  class UnknownAgency < RuntimeError;end;

  has_many :contracts

  validates :name, presence: true
  validates :abbr, presence: true, uniqueness: true

  before_validation :extract_abbr, on: :create
  
  scope :agency_name, -> (agenc) do 
   return none if agency.blank? 
   where("name like ?", "%#{agency}%")
  end 

  scope :abbr, -> (abbr) do 
    return non if abbr.blank?
    where("abbr like ?", "%#{abbr}") } 
  end

  def self.spending_per_agency(agency)
    agency_name = ActiveRecord::Base.sanitize(agency)
    find_by_sql("SELECT SUM(value) AS total")
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

