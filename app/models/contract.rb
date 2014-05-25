class Contract < ActiveRecord::Base
  belongs_to :agency

  validates :url,            presence: true
  validates :vendor_name,    presence: true
  validates :start_date,     presence: true
  validates :effective_date, presence: true
  validates :value,          presence: true
  validates :description,    presence: true
  validates :agency,         presence: true
end

