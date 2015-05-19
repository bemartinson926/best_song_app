class Song < ActiveRecord::Base
  belongs_to :artist
  has_many :votes
end
