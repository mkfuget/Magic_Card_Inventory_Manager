class CardSetsController < ApplicationController
    get "/card_sets" do
        @sets = CardSet.all
        erb :'card_sets/index'
    end

    get "/card_sets/:slug" do 
        @set = CardSet.find_by_slug(params[:slug])
        erb :'/card_sets/show'
    end
end