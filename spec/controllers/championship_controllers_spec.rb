require "spec_helper"

describe ChampionshipsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:referee]      
  end

  describe "create" do    
    it "should create a championship for a referee" do
      referee = create(:referee)
      sign_in referee
      post :create, championship: {title: "test", number_of_players: 6}, :format => "json"
      response.status.should eq(201)                  
      response_body = JSON.parse(response.body)
      response_body["title"].should eq("test")
    end

    it "should not create a championship if title is not present" do
      referee = create(:referee)
      sign_in referee
      post :create, championship: {title: ""}, :format => "json"
      response.status.should eq(422)                  
      response_body = JSON.parse(response.body)
      response_body["errors"]["title"].should include("can't be blank")
    end

    it "should not create a championship if number of players is not between 2 and 16" do
      referee = create(:referee)
      sign_in referee
      post :create, championship: {title: "", number_of_players: 1}, :format => "json"
      response.status.should eq(422)                  
      response_body = JSON.parse(response.body)
      response_body["errors"]["number_of_players"].should include("The number of players can be between 2..16")
    end
  end

  describe "index" do
    it "should return the list of championships for a referee" do
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
