class DecksController < ApplicationController
    get "/decks" do 
        checked_logged_in(session)
        @user = Helpers.current_user(session)
        erb :'/decks/index'
    end

    get "/decks/new" do
        checked_logged_in(session)
        erb :'decks/new'
    end

    post "/decks" do 
        @deck = Deck.create(name: params[:name], user: Helpers.current_user(session))
        @deck.save 
        redirect :"decks/#{@deck.slug}/edit"
    end

    get "/decks/edit" do
        checked_logged_in(session)
        @user = Helpers.current_user(session)
        erb :'decks/edit'
    end

    patch "/decks/:slug" do 
        @deck = Deck.find_by_slug(params[:slug])
        @deck.name = params[:name]
        params[:count].each do |card_instance_id, count_value|
            card_instance = CardInstance.find_by_id(card_instance_id.to_i);
            card_instance.count = count_value[0].to_i
            if(card_instance.count == 0)
                card_instance.destroy
            end
            card_instance.save
        end
        @deck.save
        redirect :"decks/#{@deck.slug}/edit"
    end

    get "/decks/:slug" do 
        checked_logged_in(session)
        @user = Helpers.current_user(session)
        @deck = Deck.find_by_slug(params[:slug])
        erb :'decks/show'
    end

    get "/decks/:slug/edit" do 
        checked_logged_in(session)
        @deck = Deck.find_by_slug(params[:slug])
        erb :'decks/edit_deck'

    end

    post "/decks/:slug/add_card" do 
        @deck = Deck.find_by_slug(params[:slug])
        @card = Card.find{|x| x.name == params[:name]}
        if(@card == nil)
            flash[:message] = "Addition failed card not found"
        elsif(!(params[:count] =~ /\A[-+]?\d*\.?\d+\z/))
            flash[:message] = "Please enter a count for the card"
        else
            @card_instance = CardInstance.create(count: params[:count].to_i, deck: @deck) 
            @card_instance.card = @card
            @card_instance.save 
            @deck.save
        end
        redirect "/decks/#{@deck.slug}/edit"
    end

    delete '/decks/:slug' do 
        @deck = Deck.find_by_slug(params[:slug])
        @deck.destroy_deck
        redirect "/decks/edit"
    end

end