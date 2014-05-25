class Agency < ActiveRecord::Base
  validates :name, presence: true
  validates :abbr, presence: true, uniqueness: true
end
