class CardInstancesController < ApplicationController
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

end