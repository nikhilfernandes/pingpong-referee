class Player < ActiveRecord::Base
  belongs_to :championship
  before_create :ensure_authentication_token

  validates_presence_of :name, :identity, :defence_length
  validates_numericality_of :defence_length

  def ensure_authentication_token    
    self.auth_token = generate_auth_token    
  end

  def generate_auth_token
    loop do
      token = Digest::SHA1.hexdigest(Time.now.strftime("%Y%m%d%H%M%S%L").to_s)    
      break token unless Player.where(auth_token: token).first
    end    
  end
end