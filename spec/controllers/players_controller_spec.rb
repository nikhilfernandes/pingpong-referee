require "spec_helper"

describe PlayersController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:referee]      
  end

  describe "create" do    
    it "should create a player for a championship" do
      championship = create(:championship)      
      post :create, championship_id: championship.id ,player: {name: "joe", identity: "1212121", defence_length: 8, host: "host", port: "port", path: "path"}, :format => "json"
      
      response.status.should eq(201)                  
      response_body = JSON.parse(response.body)
      response_body["auth_token"].should_not be_nil
      response_body["auth_token"].should eq(championship.players.first.auth_token)
      response_body["identity"].should eq("1212121")
      response_body["championship"]["id"].should eq(championship.id)
    end

    it "should not create a player if 8 players are already present" do
      championship = create(:championship) 
      HttpRequest.should_receive(:post).exactly(8).times    
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)
      create(:player, championship: championship)       

      post :create, championship_id: championship.id ,player: {name: "joe", identity: "1212121", defence_length: 8}, :format => "json"      
      championship.players.count.should eq(8)
      response.status.should eq(422)                  
      response_body = JSON.parse(response.body)
      
      response_body["errors"].should include("Identity The championship has exceeded the number of players")
      
    end
  end

  describe "index" do
    xit "should return the list of championships for a referee" do
      referee = create(:referee)
      sign_in referee
      championship = create(:championship, referee_id: referee.id)
      get :index, :format => "json"
      response.status.should eq(200)
      response_body = JSON.parse(response.body)
      response_body.length.should eq(1)
      response_body[0]["title"].should eq("title")
    end
  end

end
