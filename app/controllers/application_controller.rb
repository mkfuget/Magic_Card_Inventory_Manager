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

    get "/user/signup" do
        erb :'user/signup'
    end
    
    post "/signup" do
        user = User.new({:username => params[:username], :password => params[:password]})
        if user.save
          session[:user_id] = user.id
          redirect "/card_instances"
        else 
          redirect "/failure"
        end
    end

    get "/login" do
        erb :login
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
        @user = User.find(session[:user_id])
        erb :'card_instances/index'
    end
    
    get '/card_instances/new' do
        @user = User.find(session[:user_id])
        erb :'card_instances/new'
    end

    post '/card_instances' do 
        @card = Card.find{|x| x.name == params[:name]}
        @card_instance = CardInstance.create(user: current_user, count: params[:count])
        @card_instance.card = @card

        @card_instance.save 
        @card.save
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
        if helpers.logged_in?
            @decks = Deck.all 
            erb :'/decks/index'
        else
            erb :'/login_needed'
        end
    end

    get "/logout" do
        session.clear
        redirect "/"
    end
    
    get '/styles.css' do 
        scss :styles
    end
      
    helpers do
        def logged_in?
          !!session[:user_id]
        end
    
        def current_user
          User.find(session[:user_id])
        end
    end
    

end