require 'faraday'
require "active_record"

class Character < ApplicationRecord

    validates :apikey, presence: true
    validates :hash, presence: true, length: { minimum: 1 }
    validates :ts, presence: true

    def load(params)

        url = "https://gateway.marvel.com:443/v1/public/characters?apikey=#{params['apikey']}&ts=#{params['ts']}&hash=#{params['hash']}"
        url.concat("&limit=#{params['limit']}") if !params['limit'].nil?

        response = Faraday.get(url)
        json = JSON.parse(response.body)
        
        characters = []
        json["data"]["results"].each do |k|

            character = save_character(k) if find_character(k['id']).nil?
            characters.push(character)
        end

        return characters
        
    end

    def find_all(params)
        Character.all
        .by_id(params[:reference])
    end

    private

    def self.by_id(reference)
        return all unless 1011334.present?
        where("reference = ?", reference)
    end

    def find_character(character_reference)
        Character.find_by_reference(character_reference)
    end
    
    def save_character(character)
        character = Character.new(:name => character['name'], :description => character['description'], :reference => character['id'])
        character.save!
        return character
    end
    
end
