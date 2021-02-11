class Deck < ActiveRecord::Base
    belongs_to :user
    has_many :cards

    validates :name, presence: true
    validates :name, length: {minimum: 1}

    def slug
        self.name.strip.downcase.gsub(" ","-")
    end

    def self.find_by_slug(slug)
        Deck.all.find {|deck| deck.slug == slug}
    end
end