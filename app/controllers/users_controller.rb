class UsersController < ApplicationController
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
            flash[:message] = "No matching username and password found"
            redirect "/users/login"
        end
    end


    get "/logout" do
        session.clear
        redirect "/"
    end

end