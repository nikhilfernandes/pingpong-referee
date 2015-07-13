require "spec_helper"


describe Championship do
  describe "validations" do
    

    it "should validate presence of title" do
        championship =   build(:championship, title: "")                
        championship.save
        championship.errors_on(:title).should include("can't be blank")        
    end
  end
 
end
