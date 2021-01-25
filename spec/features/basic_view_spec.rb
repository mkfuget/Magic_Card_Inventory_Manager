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

    describe "logging in" do 
        it "displays the users collection page if username and password is given" do
            @user = User.create(:username => "Jack", :password => "Olantern")
            visit '/login'
            fill_in "username", :with => "Jack"
            fill_in "password", :with => "Olantern"
            click_button "Log In"
            expect(page.current_path).to eq('/card_instances')
            expect(page.status_code).to eq(200)
            expect(page.body).to include("Collection")
        end
      
      

    end
end  