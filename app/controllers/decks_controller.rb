require 'pry'

class DecksController < ApplicationController

    get '/decks' do #index action, index page to display all decks
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @decks = Deck.all
            erb :'decks/decks_all'
        else
            @error = "Please sign in to view decks"
            redirect '/'
        end
    end

    get 'decks/new' do #new action, displays create decks form
        if Helpers.is_logged_in?(session)
            @deck = Deck.new(name: params[:name])
            @deck.save
            redirect '/add-cards'
        else
            @error = "Please sign in to create decks"
            redirect '/'
        end
    end

    get '/add-cards' do
        if Helpers.is_logged_in?(session)
            erb :'decks/add_cards'
        else
            @error = "Please sign in to add cards"
            redirect '/'
        end
    end

    get '/new' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @decks = Deck.all
            erb :'decks/new'
        else
            @error = "Please sign in to create decks"
            redirect '/'
        end
    end

    post '/decks' do #create action, creates one deck
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.create(name: params[:name], user_id: @user.id)
            @number_of_cards = params[:number].to_i
            # binding.pry
            erb :'decks/add_cards'
        else
            @error = "Please sign in to add cards"
            redirect '/'
        end
    end

    get '/decks/:slug' do #show action, displays one deck based on the slug in the URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            # binding.pry
            erb :'/decks/deck_show'
        else
            @error = "Please sign in to view decks"
            redirect '/'
        end
    end

    get '/decks/:slug/edit' do #edit action, displays edit form based on the slug in the URL
        
    end

    patch '/decks/:slug' do #update action modifies existing deck based on the slug in the URL
        
    end

    post '/decks/:slug' do #used to be /decks/:slug
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            erb :'/decks/deck_show'
        else
            @error = "Please sign in to view decks"
        end
    end

    get '/decks/:slug/play' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            erb :'/decks/play'
        else
            redirect '/'
    end

    delete '/decks/:slug' do #delete action, deletes one article based on the slug in the URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            @deck.delete
            redirect '/decks'
        else
            redirect '/'
        end

    end

    get '/decks/:slug/add-cards' do
        erb :add_cards
    end

end