# require 'rack-flash'

class UsersController < ApplicationController

    get '/' do
        if Helpers.is_logged_in?(session) #this isn't working, when creating new users it says true
            redirect '/decks'
        end
        # flash[:message] = "Hooray, Flash is working!"
        erb :index
    end

    post '/signup' do #create action, creates one user
        # binding.pry
        if Helpers.is_logged_in?(session) #this isn't working, when creating new users it says true
            redirect '/decks'
        else
            if params[:username].present? && params[:password].present? && params[:email].present? #can I refactor?
                @user = User.create(:username => params[:username], :password => params[:password], :email => params[:email])
                session[:id] = @user.id
                redirect "/decks"
            else
                @error = "Account creation failure - make sure you provide an email, username, and password."
                redirect '/'
            end
        end
    end

    post '/login' do
        @user = User.find_by(:username => params[:username])
        if @user && @user.authenticate(params[:password])
            session[:id] = @user.id
            redirect '/decks'
        else
            @error = "It doesn't look like you have an account yet, please sign up"
            redirect '/'
        end
    end

    get '/logout' do
        session.clear
        redirect '/'
    end

    get '/users' do #show action, displays one user's info based on the session
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            erb :'users/user_settings'
        else
            redirect '/'
        end
    end

    get '/users/:slug/edit' do #edit action, displays edit form based on the slug in the URL
        if Helpers.is_logged_in?(session)
            if params[:slug] == Helpers.current_user(session).slug
                @user = Helpers.current_user(session)
                erb :'/users/edit'
            else
                @error = "You have to be logged in as this user to access this information."
                redirect '/decks'
            end
        else
            @error = "You have to be logged in to access this information."
            redirect '/'
        end
    end

    patch '/users/:slug' do #update action, modifies existing user based on the session
        if Helpers.is_logged_in?(session)
            if params[:slug] == Helpers.current_user(session).slug
                @user = Helpers.current_user(session)
                @user.email = params[:email]
                @user.username = params[:username]
                @user.save
                redirect '/users'
            else
                @error = "You have to be logged in as this user to access this information."
                redirect '/decks'
            end
        else
            @error = "You have to be logged in to access this information."
            redirect '/'
        end
    end

    delete '/users/:slug' do #delete action, deletes one user based on the session and the slug in URL
        if Helpers.is_logged_in?(session)
            if params[:slug] == Helpers.current_user(session).slug
                @user = Helpers.current_user(session)
                @user.decks.each do |deck|
                    deck.cards.each do |card|
                        card.delete
                    end
                    deck.delete
                end
                @user.delete
                redirect '/'
            else
                @error = "You have to be logged in as this user to access this information."
                redirect '/decks'
            end
        else
            @error = "You have to be logged in to access this information."
            redirect '/'
        end
    end
end