require 'pry'

class UsersController < ApplicationController

    get '/' do
        # if Helpers.is_logged_in?(session)
        #     redirect '/decks'
        # else
            erb :index
        # end
    end

    post '/signup' do
        if Helpers.is_logged_in?(session)
            redirect '/decks'
        else
            if @user = User.new(:username => params[:username], :password => params[:password], :email => params[:email])
                # binding.pry
                if @user.username !="" && @user.username !=nil && @user.password !="" && @user.password != nil && @user.email !="" && @user.email != nil
                    #theres another way to write ^this using params.has_value?
                    @user.save #save the user to create a primary key / id
                    session[:id] = @user.id #now that we have access to the id, we can assign it to the session hash
                    redirect "/decks"
                end
            else
                redirect '/'
            end
        end
    end

    post '/login' do
        @user = User.find_by(:username => params[:username]) #this doesn't find the user
        # binding.pry
        if @user && @user.authenticate(params[:password])
            session[:id] = @user.id
            redirect '/decks'
        else
            @error = "It doesn't look like you have an account yet, please sign up"
            redirect '/'
        end
    end

    get '/logout' do
        if Helpers.is_logged_in?(session)
            session.clear
        end
        redirect '/'
    end

    get '/users/:slug' do
        @user = User.find_by_slug(slug)
        erb :'/users/show'
    end

    get '/logout' do
        if Helpers.is_logged_in?(session)
            session.clear
        end
        redirect to '/'
    end

    def create #this is untested and wildly experimental ;)
        @user = User.create(user_params)
        if @user.valid?
            redirect_to user_path(@user)
        else
            flash[:my_errors] = @user.errors.full_messages
            redirect_to new_user_path
        end
    end

end