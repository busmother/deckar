# require 'rack-flash'

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

    get '/decks/new' do #new action, displays create decks form
        if Helpers.is_logged_in?(session)
            erb :'decks/new'
        else
            @error = "Please sign in to create decks"
            redirect '/'
        end
    end

    post '/decks' do #create action, creates one deck
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            if params[:name].length > 0
                @deck = Deck.create(name: params[:name], user_id: @user.id)
                @number_of_cards = params[:number].to_i
                erb :'cards/add_cards'
            else
                @error = "Your deck must have a name"
                redirect '/decks/new'
            end

        else
            @error = "Please sign in to add cards"
            redirect '/'
        end
    end

    get '/decks/:slug/more-cards' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = @user.decks.find_by_slug(params[:slug])
            @number_of_cards = params[:number].to_i
            erb :'cards/add_cards'
        else
            @error = "Please sign in to add cards"
            redirect '/'
        end
    end

    get '/decks/:slug' do #show action, displays one deck based on the slug in the URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            @cards = @deck.cards
            @ids = [] #refactor the @ids array code so I can call it as a method
            @cards.each do |card|
                @ids << card.id
            end
            erb :'/decks/deck_show'
        else
            @error = "Please sign in to view decks"
            redirect '/'
        end
    end

    get '/decks/:slug/edit' do #edit action, displays edit form based on the slug in the URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = @user.decks.find_by_slug(params[:slug])
            @cards = @deck.cards
            erb :'/decks/edit'
        else
            @error = "Please sign in to edit deck"
            redirect '/'
        end
    end

    patch '/decks/:slug' do #update action, modifies existing deck based on slug in URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = @user.decks.find_by_slug(params[:slug])
            @deck.name = params[:name]
            @deck.save
            redirect "/decks/#{@deck.slug}"
        else
            @error = "Please sign in to view deck"
            redirect '/'
        end
    end

    delete '/decks/:slug' do #delete action, deletes one deck based on the slug in the URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            @deck.cards.each do |card|
                card.delete
            end
            @deck.delete
            redirect '/decks'
        else
            redirect '/'
        end
    end

end