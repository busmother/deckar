require 'pry'

class DecksController < ApplicationController

    get '/decks' do #index action, index page to display all decks
        if Helpers.is_logged_in?(session) #looks like session isn't coming through
            @user = Helpers.current_user(session)
            @decks = Deck.all
            # binding.pry
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
            redirect '/cards'
            #erb :'/decks/new'
        else
            @error = "Please sign in to create decks"
            redirect '/'
        end
    end

    get '/cards' do
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
            @cards = @deck.cards
            # binding.pry
            erb :'/decks/deck_show'
        else
            @error = "Please sign in to view decks"
            redirect '/'
        end
    end

    post '/decks/:slug/cards' do 
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

    get '/decks/:slug/edit' do #edit action, displays edit form based on the slug in the URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
        else
            @error = "Please sign in to edit deck"
            redirect '/'
        end
    end

    patch '/decks/:slug' do #update action modifies existing deck based on the slug in the URL
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by_slug(params[:slug])
            @cards = @deck.cards
            # @card = Card.find_by(params[:id]) #do i need to specificy? inside or outside the block?
            @cards.each do |card|
                card.front = params[:front]
                card.back = params[:back]
                card.save
            end
            redirect '/decks/:slug'
        else
            @error = "Please sign in to edit deck"
            redirect '/'
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

    get '/decks/:slug/cards' do
        erb :add_cards
    end

    post '/cards' do
        if Helpers.is_logged_in?(session)
            @user = Helpers.current_user(session)
            @deck = Deck.find_by(name: params[:name])
            @number_of_cards = params[:number]
            # binding.pry
            erb :'decks/add_cards'
        else
            redirect '/'
        end
    end

    # post 'decks/:slug/cards' do
    #     if Helpers.is_logged_in?(session)
    #         @user = Helpers.current_user(session)
    #         @deck = Deck.find_by_slug(params[:slug])
    #         @card = Card.create(front: => params[:front], back: => params[:back])
    #         redirect "/decks/#{@deck.slug}"
    #     else
    #         redirect '/'
    #     end
    # end

end