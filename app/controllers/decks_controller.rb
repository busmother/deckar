require 'pry'

class DecksController < ApplicationController

    get '/decks' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @decks = Deck.all
            erb :'decks/decks_all'
        else
            @error = "Please sign in to view decks"
            redirect '/'
        end
    end

    post '/new-deck' do
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

    post '/add-cards' do
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

    get '/decks/:slug' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            erb :'/decks/deck_show'
        else
            @error = "Please sign in to view decks"
            redirect '/'
        end
    end

    post '/decks/cards' do #should be more restful than this
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            erb :'/decks/deck_show'
        else
            @error = "Please sign in to view decks"
        end
    end
    
end