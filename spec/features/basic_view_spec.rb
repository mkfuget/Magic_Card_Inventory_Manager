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
            visit '/users/login'
            fill_in "username", :with => "Jack"
            fill_in "password", :with => "Olantern"
            click_button "Log In"
            expect(page.current_path).to eq('/card_instances')
            expect(page.status_code).to eq(200)
            expect(page.body).to include("Collection")
        end
    end
    describe "User Actions" do 
      before(:each) do
        CardInstance.destroy_all
        Deck.destroy_all
        User.destroy_all  
        @user = User.create(:username => "Jack", :password => "Olantern")
        visit '/users/login'
        fill_in "username", :with => "Jack"
        fill_in "password", :with => "Olantern"
        click_button "Log In"
      end
  
      describe "adding card to collection" do 
          it "shows a card with the correct count after adding it to the collection" do 
            visit '/card_instances/new'
            fill_in "name", :with => "Loathsome Chimera"
            fill_in "count", :with => "4"
            click_button "Create Card Instance"
            expect(page.current_path).to eq('/card_instances/new')
            visit '/card_instances'

            expect(page.body).to include("Loathsome Chimera")
            expect(page.body).to include("4")

          end

          it "Doesnt add a card that is not in the collection" do 
            visit '/card_instances/new'
            fill_in "name", :with => "Hero of Precinct One"
            fill_in "count", :with => "4"
            click_button "Create Card Instance"
            expect(page.current_path).to eq('/card_instances/new')
            expect(page.body).to include("Addition failed card not found")

            visit '/card_instances'

            expect(page.body).not_to include("Hero of Precinct One")

          end

    end
  end

end  