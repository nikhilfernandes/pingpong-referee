require "spec_helper"


describe Round do
  describe "validations" do
    
    it "should validate chance" do
        player1 = create(:player)
        player2 = create(:player)        
        HttpRequest.should_receive(:post).exactly(2).times  
        game = create(:game, player1_identity: player1.identity, player2_identity: player2.identity)                
        round = game.rounds.first
        round.update_attributes({last_played_by: player2.identity, offensive_number: 1})
        round.errors_on(:turn).should include("Its not your turn.")
    end

    it "should validate game player" do
        player1 = create(:player)
        player2 = create(:player)        
        HttpRequest.should_receive(:post).exactly(2).times  
        game = create(:game, player1_identity: player1.identity, player2_identity: player2.identity)                
        round = game.rounds.first
        round.update_attributes({last_played_by: "asasa", offensive_number: 1})
        round.errors_on(:game).should include("You playing the wrong game.")
    end

    it "should validate offensive number between 1..10" do
        player1 = create(:player)
        player2 = create(:player)        
        HttpRequest.should_receive(:post).exactly(2).times  
        game = create(:game, player1_identity: player1.identity, player2_identity: player2.identity)                
        round = game.rounds.first
        round.update_attributes({last_played_by: player1.identity, offensive_number: 11})
        round.errors_on(:offensive_number).should include("The offensive number should be between 1..10")
    end

    it "should validate defensive array length" do
        HttpRequest.should_receive(:put).exactly(1).times
        championship = create(:championship)
        player1 = create(:player, championship: championship)
        player2 = create(:player, defence_length: 3, championship: championship)      
        HttpRequest.should_receive(:post).exactly(2).times  
        game = create(:game, player1_identity: player1.identity, player2_identity: player2.identity, championship: championship)                
        round = game.rounds.first                
        round.update_attributes({last_played_by: player1.identity, offensive_number: 1})
        round.update_attributes({last_played_by: player2.identity, defensive_array: [1,2,4,5]})
        round.errors_on(:defensive_array).should include("The length of the defensive array is incorrect.")
    end

  end

  describe "modify turn" do
    it "should modify turn after save" do
        player1 = create(:player)
        player2 = create(:player)
        HttpRequest.should_receive(:post).exactly(2).times
        game = create(:game, player1_identity: player1.identity, player2_identity: player2.identity)                
        round = game.rounds.first
        round.update_attributes({last_played_by: player1.identity, offensive_number: 1})
        round.turn.should eq(game.player2_identity)
    end
  end

  describe "handle round played" do
    it "should set winner as defense player if round is over and number present in defense array" do
        HttpRequest.should_receive(:put).exactly(1).times
        championship = create(:championship)
        player1 = create(:player, championship: championship)
        player2 = create(:player, defence_length: 3, championship: championship)
        HttpRequest.should_receive(:post).exactly(6).times
        game = create(:game, player1_identity: player1.identity, player2_identity: player2.identity, championship: championship)                
        round = game.rounds.first
        round.update_attributes({last_played_by: player1.identity, offensive_number: 1})        
        round.update_attributes({last_played_by: player2.identity, defensive_array: [1,3,5]})
        round.winner.should eq(game.player2_identity)
        round.game.reload.player1_score.should be_nil
        round.game.reload.player2_score.should eq(1)
    end

    it "should set winner as offense player if number not present in defense array" do
        HttpRequest.should_receive(:put).exactly(1).times
        championship = create(:championship)
        player1 = create(:player, championship: championship)
        player2 = create(:player, defence_length: 3, championship: championship)
        HttpRequest.should_receive(:post).exactly(6).times
        game = create(:game, player1_identity: player1.identity, player2_identity: player2.identity, championship: championship)                
        round = game.rounds.first
        round.update_attributes({last_played_by: player1.identity, offensive_number: 8})        
        round.update_attributes({last_played_by: player2.identity, defensive_array: [1,3,5]})
        round.winner.should eq(game.player1_identity)
        round.game.reload.player2_score.should be_nil
        round.game.reload.player1_score.should eq(1)
    end
  end
 
end
