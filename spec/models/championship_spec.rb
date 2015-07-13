require "spec_helper"


describe Championship do
  describe "validations" do
    

    it "should validate presence of title" do
        championship =   build(:championship, title: "")                
        championship.save
        championship.errors_on(:title).should include("can't be blank")        
    end

    # it "should validate the number of players" do
    #   championship =   build(:championship, title: "test")
    #   championship.players.create()
    # end
  end
 
end
