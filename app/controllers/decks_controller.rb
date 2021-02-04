require 'pry'

class DecksController < ApplicationController

    get '/decks' do
        if Helpers.is_logged_in?(session)
            @decks = Deck.all
            erb :'decks/decks_all'
        else
            redirecct '/login'
        end
    end

    get '/new' do
        
    end
    
end