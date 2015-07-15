require "spec_helper"


describe Round do
  describe "validations" do
    
    it "should validate chance" do
        game = create(:game)
        round = create(:round, game: game, turn: game.player1_identity)
        round.update_attributes({turn: game.player2_identity, offensive_number: 1})
        round.errors_on(:turn).should include("Its not your turn.")
    end

    it "should validate game player" do
        game = create(:game)
        round = create(:round, game: game, turn: game.player1_identity)
        round.update_attributes({turn: "test@test.com", offensive_number: 1})
        round.errors_on(:game).should include("You playing the wrong game.")

    end

  end

  describe "modify turn" do
    it "should modify turn after save" do
        game = create(:game)
        round = create(:round, game: game, turn: game.player1_identity)
        round.update_attributes({turn: game.player1_identity, offensive_number: 1})
        round.new_turn.should eq(game.player2_identity)
    end
  end

  describe "check for winner" do
    it "should set winner if to current turn if defensive array has number" do
        game = create(:game)
        round = create(:round, game: game, turn: game.player1_identity)
        round.update_attributes({turn: game.player1_identity, offensive_number: 1})
        round.update_column(:turn, round.new_turn)
        round.update_attributes({turn: game.player2_identity, defensive_array: [1,3,5]})
        round.winner.should eq(game.player2_identity)
        round.game.reload.player1_score.should be_nil
        round.game.reload.player2_score.should eq(1)
    end

    it "should set winner if to other turn if defensive array does not have number" do
        game = create(:game)
        round = create(:round, game: game, turn: game.player1_identity)
        round.update_attributes({turn: game.player1_identity, offensive_number: 8})
        round.update_column(:turn, round.new_turn)
        round.update_attributes({turn: game.player2_identity, defensive_array: [1,3,5]})
        round.winner.should eq(game.player1_identity)
        round.game.reload.player1_score.should eq(1)
        round.game.reload.player2_score.should be_nil
    end
  end
 
end
