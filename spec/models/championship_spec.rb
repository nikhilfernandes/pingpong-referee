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
      HttpRequest.should_receive(:post).exactly(16).times
      HttpRequest.should_receive(:put).exactly(28).times
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

    describe "game_completed" do
      it "should create more games if league completed" do
        championship =   create(:championship, title: "test")
        HttpRequest.should_receive(:post).exactly(24).times
        HttpRequest.should_receive(:put).exactly(28).times
        first_player = create(:player, championship: championship)
        second_player = create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        second_but_last_player = create(:player, championship: championship)
        last_player = create(:player, championship: championship)      
        championship.games.each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end
        championship.reload
        championship.games.size.should eq(6)
        championship.games.last.round.should eq(1)        
      end

      it "should set winner if evenly placed championship championship completed" do
        championship =   create(:championship, title: "test")
        HttpRequest.should_receive(:post).exactly(28).times
        HttpRequest.should_receive(:put).exactly(28).times
        first_player = create(:player, championship: championship)
        second_player = create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        second_but_last_player = create(:player, championship: championship)
        last_player = create(:player, championship: championship)      
        championship.games.each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end
        championship.reload
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end
        championship.reload
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end

        championship.reload
        championship.games.size.should eq(7)
        championship.status.should eq("closed")
        championship.winner.should eq(first_player.identity)
        
      end

      it "should set winner if even number of players played but not evenly placed 3 players" do
        championship =   create(:championship, title: "test", number_of_players: 3)
        HttpRequest.should_receive(:post).exactly(8).times
        HttpRequest.should_receive(:put).exactly(3).times
        first_player = create(:player, championship: championship)
        second_player = create(:player, championship: championship)
        create(:player, championship: championship)
        
        championship.games.each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)          
          game.update_score(game.player1_identity)        
        end
        championship.reload        
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end
        
        
        championship.reload
        championship.games.size.should eq(2)
        championship.status.should eq("closed")
        championship.winner.should_not be_nil
        
      end

      it "should set winner if even number of players played but not evenly placed 6 players" do
        championship =   create(:championship, title: "test", number_of_players: 6)
        HttpRequest.should_receive(:post).exactly(20).times
        HttpRequest.should_receive(:put).exactly(15).times
        first_player = create(:player, championship: championship)
        second_player = create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)

        second_but_last_player = create(:player, championship: championship)
        last_player = create(:player, championship: championship)              
        championship.games.each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)          
          game.update_score(game.player1_identity)        
        end
        championship.reload        
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end
        
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end

        championship.reload
        championship.games.size.should eq(5)
        championship.status.should eq("closed")
        championship.winner.should_not be_nil
        
      end

      it "should set winner if even number of players played but not evenly placed 10 players" do
        championship =   create(:championship, title: "test", number_of_players: 10)
        HttpRequest.should_receive(:post).exactly(36).times
        HttpRequest.should_receive(:put).exactly(45).times
        first_player = create(:player, championship: championship)
        second_player = create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)

        second_but_last_player = create(:player, championship: championship)
        last_player = create(:player, championship: championship)              
        championship.games.each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)          
          game.update_score(game.player1_identity)        
        end
        championship.reload        
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end
        
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end
        championship.reload
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end

        championship.reload
        championship.games.size.should eq(9)
        championship.status.should eq("closed")
        championship.winner.should_not be_nil
        
      end

it "should set winner if even number of players played but not evenly placed 12 players" do
        championship =   create(:championship, title: "test", number_of_players: 12)
        HttpRequest.should_receive(:post).exactly(44).times
        HttpRequest.should_receive(:put).exactly(66).times
        first_player = create(:player, championship: championship)
        second_player = create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)
        create(:player, championship: championship)

        second_but_last_player = create(:player, championship: championship)
        last_player = create(:player, championship: championship)              
        championship.games.each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)          
          game.update_score(game.player1_identity)        
        end
        championship.reload        
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end
        
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end
        championship.reload
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end

        championship.reload
        championship.games.where("status = ?", "started").each do |game|
          game.update_columns(player1_score: 4, player2_score: 1)
          game.update_score(game.player1_identity)        
        end

        championship.reload
        championship.games.size.should eq(11)
        championship.status.should eq("closed")
        championship.winner.should_not be_nil
        
      end      
    end


    
 
end
