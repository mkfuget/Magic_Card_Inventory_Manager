require "./config/environment"

class CardSetController < ApplicationController
    require 'sinatra'
    require 'twilio-ruby'
    
    get "sets/" do
        @sets = Set.all
        erb :sets
    end
end