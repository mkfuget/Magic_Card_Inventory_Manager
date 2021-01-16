class CardSetController < ApplicationController
    
    get "/card_sets" do
        @sets = CardSet.all
        erb :'card_sets/index'
    end
end