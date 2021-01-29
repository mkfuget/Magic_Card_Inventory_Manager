class CardsController < ApplicationController
    get "/cards" do
        @sets = CardSet.all
        erb :'cards/index'
    end

    get "/cards/:slug" do 
        @card = Card.find_by_slug(params[:slug])
        erb :'/cards/show'
    end
end