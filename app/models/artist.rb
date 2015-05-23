class Artist < ActiveRecord::Base
  has_many :songs

  validates :full_name, presence: true
end
