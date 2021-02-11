require 'pry'

class CardsController < ApplicationController

    get '/decks/:slug/cards' do #new action, displays create cards form
        erb :'/decks/deck_show'
    end

    get '/decks/:slug/cards/new' do #refactor this, not RESTful, 
        #this route should be an index action, index page to display all cards
        erb :'/cards/add_cards'
    end

    post '/decks/:slug/cards' do #create action, creates cards
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            params[:front].each_with_index do |front, i|
                front = params[:front][i]
                back = params[:back][i]
                card = Card.create(front: front, back: back, deck_id: @deck.id)
            end
            @ids = [] 
            @deck.cards.each do |card|
                @ids << card.id
            end
            erb :'/decks/deck_show'
        else
            @error = "Please sign in to view decks"
            redirect '/'
        end
    end

    get '/decks/:slug/cards/:id' do #show action, displays on card based on id in URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            @cards = @deck.cards
            @ids = []
            @cards.each do |card|
                @ids << card.id
            end
            @card = @cards.find_by_id(params[:id])
            erb :'cards/cards_show_front'
        else
            @error = "Please sign in to play"
            redirect '/'
        end
    end

    get '/decks/:slug/cards/:id/back' do #show action, displays on card based on id in URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            @cards = @deck.cards
            @ids = []
            @cards.each do |card|
                @ids << card.id
            end
            @card = @cards.find_by_id(params[:id])
            erb :'cards/cards_show_back'
        else
            @error = "Please sign in to play"
            redirect '/'
        end
    end

    get '/decks/:slug/cards/:id/edit' do #edit action, displays edit form based on slug and id in URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            if @user.decks.find_by_slug(params[:slug]) != nil
                @deck = @user.decks.find_by_slug(params[:slug])
                @cards = @deck.cards
                @card = @cards.find_by_id(params[:id])
                erb :'/cards/edit'
            else
                @error = "Please sign in to edit deck"
                redirect '/decks/:slug/cards/:id' #not sure if this works
            end
            else
            @error = "Please sign in to view deck"
            redirect '/'
        end
    end

    patch '/decks/:slug/cards/:id' do #update action, modifies existing card based on slug in URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = @user.decks.find_by_slug(params[:slug])
            @cards = @deck.cards
            @card = @cards.find_by_id(params[:id])
            # binding.pry
            @card.front = params[:front]
            @card.back = params[:back]
            @card.save
            @ids = []
            @cards.each do |card|
                @ids << card.id
            end
            redirect "/decks/#{@deck.slug}/cards/#{@card.id}"
        else
            @error = "Please sign in to edit card"
            redirect '/'
        end
    end

    delete '/decks/:slug/cards/:id' do #delete action, deletes one card based on the id in the URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = @user.decks.find_by_slug(params[:slug])
            @cards = @deck.cards
            @card = @cards.find_by_id(params[:id])
            @card.delete
            @ids = []
            @cards.each do |card|
                @ids << card.id
            end
            # redirect "/decks/#{@deck.slug}/cards"
            erb :'decks/deck_show'
        else
            redirect '/'
        end
    end

end