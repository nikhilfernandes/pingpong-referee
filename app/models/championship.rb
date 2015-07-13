class Championship < ActiveRecord::Base
  has_many :games
  belongs_to :referee
  has_many :players
  validates_presence_of :title


end