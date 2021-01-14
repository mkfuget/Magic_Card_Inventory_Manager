require "./config/environment"

class ApplicationController < Sinatra::Base
    require 'sinatra'
    require 'twilio-ruby'
    
    get "/" do
        "Hello, world!"
    end
end