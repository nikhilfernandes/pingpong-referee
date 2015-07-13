require "spec_helper"


describe Round do
  describe "validations" do
    

    it "should validate whos playing the game round" do
        referee =   build(:referee, email: "")                
        referee.save
        referee.errors_on(:email).should include("can't be blank")        
    end

    it "should validate presence of password" do
        referee =   build(:referee, password: "")                
        referee.save
        referee.errors_on(:password).should include("can't be blank")        
    end
  end
 
end
