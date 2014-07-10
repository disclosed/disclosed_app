class Contract < ActiveRecord::Base
  belongs_to :agency

  validates :url,            presence: true
  validates :vendor_name,    presence: true
  validates :value,          presence: true
  validates :agency,         presence: true
end

