require 'faraday'

class Character < ApplicationRecord

    def load(params)

        characters = []

        url = "https://gateway.marvel.com:443/v1/public/characters?apikey=#{params['apikey']}&ts=#{params['ts']}&hash=#{params['hash']}&limit=1"
        url.concat("&limit=#{params['limit']}") if !params['apikey'].nil?

        response = Faraday.get(url)
        json = JSON.parse(response.body)
        
        json["data"]["results"].each do |k|
            character = Character.new(:name => k['name'], :description => k['description'])
            characters.push(character)
            character.save!
        end

        return characters
        
    end

    def find_all 
        Character.where("id = 2")
    end
end
