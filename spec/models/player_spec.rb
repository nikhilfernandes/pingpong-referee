require "spec_helper"


describe Player do
  describe "validations" do
    

    it "should validate presence of name" do
      player =   build(:player, name: "")                
      player.save
      player.errors_on(:name).should include("can't be blank")        
    end

    it "should validate presence of name" do
      player =   build(:player, name: "")                
      player.save
      player.errors_on(:name).should include("can't be blank")        
    end    

    it "should validate presence of identity" do
      player =   build(:player, identity: "")                
      player.save
      player.errors_on(:identity).should include("can't be blank")        
    end    

    it "should validate presence of defence length" do
      player =   build(:player, defence_length: "")                
      player.save
      player.errors_on(:defence_length).should include("can't be blank")        
    end        

    it "should validate numericality of defence length" do
      player =   build(:player, defence_length: "aaaa")                
      player.save
      player.errors_on(:defence_length).should include("is not a number")        
    end            

    it "should generate auth token for player" do
      player =   build(:player)                
      player.save
      player.auth_token.should_not be_nil      
    end        

    it "should validate that the same player cannot join the game twice" do
      championship =   create(:championship, title: "test")
      create(:player, championship: championship, identity: "1211111")
      create(:player, championship: championship, identity: "23232232")
      duplicate_player = build(:player, championship: championship, identity: "1211111")
      duplicate_player.save
      
      duplicate_player.errors_on(:identity).should include("The player has already joined the game")
      
    end    

    it "should validate the number of players to not be more than 8" do
      championship =   create(:championship, title: "test")
      HttpRequest.should_receive(:post).exactly(8).times
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)      
      extra_player = build(:player, championship: championship)
      extra_player.save      
      championship.reload
      championship.players.size.should eq(8)
      extra_player.errors_on(:championship).should include("The championship has exceeded the number of players")
      
    end

  end
 
end
