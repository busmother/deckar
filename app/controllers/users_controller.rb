require 'pry'

class UsersController < ApplicationController

    get '/' do
        if Helpers.is_logged_in?(session)
            redirect '/decks'
        else
            erb :index
        end
    end

    post '/signup' do
        if Helpers.is_logged_in?(session)
            redirect '/decks'
        else
            if params.has_value?
                @user = User.create(:username => params[:username], :password => params[:password], :email => params[:email])
                session[:user_id] = @user.id
                redirect '/decks'
            else
                redirect '/signup'
            end
        end
    end

    post '/login' do
        @user = User.find_by(:username => params[:username])
        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect '/decks'
        else
            redirect '/login'
        end
    end

    get '/logout' do
        if Helpers.is_logged_in?(session)
            session.clear
        end
        redirect '/login'
    end

    get '/users/:slug' do
        @user = User.find_by_slug(slug)
        erb:'/users/show'
    end

    get '/logout' do
        
    end

end