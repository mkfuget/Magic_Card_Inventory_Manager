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
        post '/signup', {"username" => "mkfuget", "password" => "pass821"}
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

        it "Returns to the login page if the login fails" do
          @user = User.create(:username => "Jack", :password => "Olantern")
          visit '/users/login'
          fill_in "username", :with => "Jack"
          fill_in "password", :with => "Black"
          click_button "Log In"
          expect(page.current_path).to eq('/users/login')
          expect(page.status_code).to eq(200)
          expect(page.body).to include("Collection")
      end

    end
    describe "User Actions" do 
      before(:each) do
        @user = User.find{|user| user.username == "Jack"}
        @user.delete_user
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

          it "increases the count when a card is added that is already in the collection" do 
            visit '/card_instances/new'
            fill_in "name", :with => "Loathsome Chimera"
            fill_in "count", :with => "4"
            click_button "Create Card Instance"
            fill_in "name", :with => "Loathsome Chimera"
            fill_in "count", :with => "3"
            click_button "Create Card Instance"

            expect(page.current_path).to eq('/card_instances/new')

            visit '/card_instances'

            expect(page.body).to include("Loathsome Chimera")
            expect(page.body).to include("7")


          end

          it "Allows the user to edit card instances" do 
            visit '/card_instances/new'
            fill_in "name", :with => "Loathsome Chimera"
            fill_in "count", :with => "4"
            click_button "Create Card Instance"
            visit '/card_instances/edit'
            expect(page.current_path).to eq('/card_instances/edit')

            fill_in "count_Loathsome Chimera", :with => "3"
            click_button "edit_card_instances"


            visit '/card_instances'

            expect(page.body).to include("Loathsome Chimera")
            expect(page.body).to include("3")


          end

          it "Editing to zero cards deletes the card_instance" do 
            visit '/card_instances/new'
            fill_in "name", :with => "Loathsome Chimera"
            fill_in "count", :with => "4"
            click_button "Create Card Instance"
            visit '/card_instances/edit'
            expect(page.current_path).to eq('/card_instances/edit')

            fill_in "count_Loathsome Chimera", :with => "0"
            click_button "edit_card_instances"


            visit '/card_instances'

            expect(page.body).to_not include("Loathsome Chimera")


          end

          it "Adding Deck to Collection" do 
            visit '/decks/new'
            fill_in "name", :with => "Esper Hero"
            click_button "Create Deck"
            visit '/decks'


            expect(page.body).to include("Esper Hero")


          end

          it "Adding Card to Deck" do 
            visit '/decks/new'
            deck_name = "Esper Hero"
            fill_in "name", :with => deck_name
            click_button "Create Deck"
            deck = Deck.find{|deck| deck.name == deck_name} 
            visit "/decks/#{deck.slug}/edit"
            fill_in "new_card_name", :with => "Brazen Borrower"
            fill_in "new_card_count", :with => 4
            click_button "Add Card"



            expect(page.body).to include("Brazen Borrower")


          end
          it "Editing Deck" do 
            visit '/decks/new'
            deck_name = "Esper Hero"
            fill_in "name", :with => deck_name
            click_button "Create Deck"
            deck = Deck.find{|deck| deck.name == deck_name} 
            visit "/decks/#{deck.slug}/edit"
            fill_in "new_card_name", :with => "Brazen Borrower"
            fill_in "new_card_count", :with => 4
            click_button "Add Card"
            fill_in "new_card_name", :with => "Swamp"
            fill_in "new_card_count", :with => 4
            click_button "Add Card"
            fill_in "edit_Swamp_count", :with => 2
            fill_in "edit_deck_name", :with => "Esper Control"
            click_button "edit_deck_submit"


            expect(page.body).to include("Brazen Borrower")
            expect(page.body).to include("Esper Control")
            expect(page.body).to include("2")


          end
          it "Deleting Deck" do 
            visit '/decks/new'
            deck_name = "Esper Hero"
            fill_in "name", :with => deck_name
            click_button "Create Deck"
            visit '/decks/new'
            deck_name = "Esper Control"
            fill_in "name", :with => deck_name
            click_button "Create Deck"
            visit '/decks/new'
            deck_name = "Mono Red Aggro"
            fill_in "name", :with => deck_name
            click_button "Create Deck"

            visit "/decks/edit"
            expect(page.body).to include("Esper Hero")
            expect(page.body).to include("Esper Control")
            expect(page.body).to include("Mono Red Aggro")

            click_button "delete_Mono Red Aggro"


            

            expect(page.body).to include("Esper Hero")
            expect(page.body).to include("Esper Control")
            expect(page.body).to_not include("Mono Red Aggro")


          end





    end
  end

end  