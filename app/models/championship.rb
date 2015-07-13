class Championship < ActiveRecord::Base
  has_many :games
  validates_presence_of :title
  
end