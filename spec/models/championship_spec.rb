require "spec_helper"


describe Championship do
  describe "validations" do
    

    it "should validate presence of title" do
        championship =   build(:championship, title: "")                
        championship.save
        championship.errors_on(:title).should include("can't be blank")        
    end

    
  end

  it "should create games when 8 players have joined" do
      championship =   create(:championship, title: "test")
      first_player = create(:player, championship: championship)
      second_player = create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      second_but_last_player = create(:player, championship: championship)
      last_player = create(:player, championship: championship)      
      championship.games.size.should eq(4)
      championship.games[0].player1_identity.should eq(first_player.identity)
      championship.games[0].player2_identity.should eq(second_player.identity)
      championship.games[0].order_of_player1.should eq(1)
      championship.games[3].player1_identity.should eq(second_but_last_player.identity)
      championship.games[3].player2_identity.should eq(last_player.identity)
      championship.games[3].order_of_player2.should eq(2)      
    end
 
end
