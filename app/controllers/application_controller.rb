require "./config/environment"
require "./app/models/user"
require 'rack-flash'

class ApplicationController < Sinatra::Base
    use Rack::Flash
  
    register Sinatra::ActiveRecordExtension

    configure do
        set :views, "app/views"
        enable :sessions
        set :session_secret, "password_security"

    end
      
    get "/" do
        erb :index
    end

    get "/users/signup" do
        erb :'users/signup'
    end
    
    post "/signup" do
        user = User.find_by(:username => params[:username])
        if user == nil 
            user = User.new({:username => params[:username], :password => params[:password]})
            user.save
            session[:user_id] = user.id
            redirect "/card_instances"
        else 
            flash[:message] = "Username already taken"
            redirect "/users/signup"
        end
    end

    get "/users/login" do
        erb :'users/login'
    end
    
    post "/login" do
        user = User.find_by(:username => params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect "/card_instances"
        else
            redirect "/failure"
        end
    end
    

    get '/card_instances' do
        checked_logged_in(session)
        @user = Helpers.current_user(session)
        erb :'card_instances/index'
    end
    
    get '/card_instances/new' do
        checked_logged_in(session)
        @user = Helpers.current_user(session)
        erb :'card_instances/new'
    end

    post '/card_instances' do 
        @card = Card.find{|x| x.name == params[:name]}
        if(@card == nil)
            flash[:message] = "Addition failed card not found"
        elsif(!(params[:count] =~ /\A[-+]?\d*\.?\d+\z/))
            flash[:message] = "Please enter a count for the card"
        else
            @card_instance = Helpers.current_user(session).card_instances.find{|x| x.card.name == params[:name]}
            if @card_instance == nil 
                @card_instance = CardInstance.create(user: Helpers.current_user(session), count: params[:count].to_i)
            else 
                @card_instance.count += params[:count].to_i
            end
            @card_instance.card = @card
            @card_instance.save 
            @card.save
            flash[:message] = "Card added to collection"
        end
        redirect "/card_instances/new"
    end

    post '/card_instances/edit' do 
        redirect "/card_instances/new"
    end

    get '/card_instances/edit' do
        checked_logged_in(session)
        @user = Helpers.current_user(session)
        erb :'card_instances/edit'
    end

    patch '/card_instances' do 
        params[:count].each do |card_instance_id, count_value|
            card_instance = CardInstance.find_by_id(card_instance_id.to_i);
            card_instance.count = count_value[0].to_i
            if(card_instance.count == 0)
                card_instance.destroy
            end
            card_instance.save
        end
        redirect "/card_instances"
    end


    get "/card_sets" do
        @sets = CardSet.all
        erb :'card_sets/index'
    end

    get "/card_sets/:slug" do 
        @set = CardSet.find_by_slug(params[:slug])
        erb :'/card_sets/show'
    end

    get "/cards" do
        @sets = CardSet.all
        erb :'cards/index'
    end

    get "/cards/:slug" do 
        @card = Card.find_by_slug(params[:slug])
        erb :'/cards/show'
    end

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

    get "/logout" do
        session.clear
        redirect "/"
    end
    
    get '/styles.css' do 
        scss :styles
    end
      
    def checked_logged_in(session)
        if !Helpers.is_logged_in?(session)
            flash[:message] = "Please sign up or login to view that page"
            redirect to('/')
        end
    end    

end