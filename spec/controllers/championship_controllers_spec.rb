require "spec_helper"

describe ChampionshipsController do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:referee]      
  end

  describe "create" do    
    it "should create a championship for a referee" do
      referee = create(:referee)
      sign_in referee
      post :create, championship: {title: "test"}, :format => "json"
      response.status.should eq(201)                  
      response_body = JSON.parse(response.body)
      response_body["title"].should eq("test")
    end
  end

end
