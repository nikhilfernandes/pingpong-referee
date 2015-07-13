class Championship < ActiveRecord::Base
  has_many :games
  belongs_to :referee
  
  validates_presence_of :title

end