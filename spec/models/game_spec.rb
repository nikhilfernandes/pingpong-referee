require "spec_helper"


describe Game do

  it "should create round for game" do
    HttpRequest.should_receive(:put).exactly(1).times
    championship = create(:championship)
    player1 = create(:player, championship: championship)
    player2 = create(:player, defence_length: 3, championship: championship)
    HttpRequest.should_receive(:post).exactly(4).times
    game = create(:game, championship: championship, player1_identity: player1.identity, player2_identity: player2.identity)
    game.rounds.size.should eq(1)
  end

  it "should create new round if game not over" do
    HttpRequest.should_receive(:put).exactly(1).times
    championship = create(:championship)
    player1 = create(:player, championship: championship)
    player2 = create(:player, defence_length: 3, championship: championship)
    HttpRequest.should_receive(:post).exactly(6).times
    game = create(:game, championship: championship, player1_identity: player1.identity, player2_identity: player2.identity)
    game.update_score(game.player1_identity)
    game.rounds.size.should eq(2)
    game.rounds.last.turn.should eq(game.player1_identity)
  end

  it "should mark game as completed if game over" do
    HttpRequest.should_receive(:put).exactly(1).times
    championship = create(:championship)
    player1 = create(:player, championship: championship)
    player2 = create(:player, defence_length: 3, championship: championship)
    HttpRequest.should_receive(:post).exactly(4).times
    game = create(:game, championship: championship, player1_identity: player1.identity, player2_identity: player2.identity, player1_score: 4, player2_score: 2)
    championship.stub(:game_completed)
    game.update_score(game.player1_identity)
    game.rounds.size.should eq(1)
    game.status.should eq(Game::STATUS::COMPLETED)
  end
end
 

