require "./config/environment"
require "./app/models/user"
require 'rack-flash'

class ApplicationController < Sinatra::Base
    enable :sessions
    use Rack::Flash
  
    register Sinatra::ActiveRecordExtension
    set :session_secret, "my_application_secret"
  
    set :views, Proc.new { File.join(root, "../views/") }
      set :session_secret, "my_application_secret"
  
    set :views, Proc.new { File.join(root, "../views/") }
  
    get "/" do
        @sets = CardSet.all
        erb :index
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

end