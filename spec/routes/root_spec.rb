require 'spec_helper'

describe SynvertToolsApp::Routes::Root do
  include Rack::Test::Methods

  def app
    SynvertToolsApp::Routes::Root.new
  end

  describe "GET /" do 
    before :each do
      get "/"
    end
    it "returns successfully" do
      expect(last_response).to be_ok
    end
  end 
end
