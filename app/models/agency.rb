class Agency < ActiveRecord::Base
  class UnknownAgency < RuntimeError;end;

  has_many :contracts

  validates :name, presence: true
  validates :abbr, presence: true, uniqueness: true

  before_validation :extract_abbr, on: :create
  
  scope :agency_name, -> (agency_query) { where ("name like ?", "%#{agency_query}%")}
  
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

