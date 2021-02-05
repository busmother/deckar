require 'pry'

class DecksController < ApplicationController

    get '/decks' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @decks = Deck.all
            # binding.pry
            erb :'decks/decks_all'
        else
            @error = "Please sign in to view decks"
            redirect '/'
        end
    end

    post '/new-deck' do
        # binding.pry
        @deck = Deck.new(name: params[:name])
        @deck.save
        redirect '/add-cards'
    end

    get '/add-cards' do
        # binding.pry
        erb :'decks/add_cards'
    end

    get '/new' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @decks = Deck.all
            erb :'decks/new'
        end
    end

    get '/deck/:user/:slug' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            erb :'deck_show.erb'
        end
    end

    post '/decks/:slug' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            erb :'/decks/deck_show'
        end
    end
    
end