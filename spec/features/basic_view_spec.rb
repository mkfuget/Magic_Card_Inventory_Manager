require 'spec_helper'

describe 'App' do
    include Rack::Test::Methods
  
    describe "GET '/'" do
      it "returns a 200 status code" do
        get '/'
        expect(last_response.status).to eq(200)
      end
    end
  
    describe "Signing Up" do
  
      it "displays Sign Up Page" do
        get '/users/signup'
        expect(last_response.body).to include('Username')
        expect(last_response.body).to include('Password:')
      end

      it "displays the Collection page if username and password is given" do
        post '/signup', {"username" => "avi", "password" => "I<3Ruby"}
        follow_redirect!
        expect(last_response.body).to include('Collection')
      end
  
    end
end  