require "./config/environment"

class ApplicationController < Sinatra::Base
    require 'sinatra'
    require 'twilio-ruby'
    
    get "/" do
        @sets = CardSet.all
        erb :index
    end
end