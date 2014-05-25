class Agency < ActiveRecord::Base
  has_many :contracts

  validates :name, presence: true
  validates :abbr, presence: true, uniqueness: true
end

