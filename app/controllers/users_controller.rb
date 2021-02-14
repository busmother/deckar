# require 'rack-flash'

class UsersController < ApplicationController

    get '/' do
        if Helpers.is_logged_in?(session)
            redirect '/decks'
        end
        erb :index
    end

    post '/signup' do #create action, creates one user
        if Helpers.is_logged_in?(session)
            redirect '/decks'
        else
            @user = User.create(params)
            session[:id] = @user.id
            redirect "/decks"
        end
    end

    post '/login' do
        @user = User.find_by(:username => params[:username])
        if @user && @user.authenticate(params[:password])
            session[:id] = @user.id
            redirect '/decks'
        else
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
                redirect '/decks'
            end
        else
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
                erb :'users/user_settings'
            else
                redirect '/decks'
            end
        else
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
                redirect '/decks'
            end
        else
            redirect '/'
        end
    end
end