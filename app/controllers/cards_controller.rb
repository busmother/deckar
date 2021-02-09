require 'pry'

class CardsController < ApplicationController

    get '/decks/:slug/cards' do #refactor this, not RESTful, 
        #this route should be an index action, index page to display all cards
        erb :'/cards/add_cards'
    end

    get '/decks/:slug/cards/new' do #new action, displays create cards form
        #isa this redundant?
    end

    post '/decks/:slug/cards' do #create action, creates cards
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            params[:front].each_with_index do |front, i|
                front = params[:front][i]
                back = params[:back][i]
                card = Card.create(front: front,back: back, deck_id: @deck.id)
                # @deck.cards << card
                # binding.pry
            end
            @cards = @deck.cards
            erb :'/decks/deck_show'
        else
            @error = "Please sign in to view decks"
            redirect '/'
        end
    end

    get '/decks/:slug/cards/:id' do #show action, displays on card based on id in URL
        
    end

    

end