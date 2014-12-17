class Watcher < ActiveRecord::Base
  validates :email, presence: true
end
