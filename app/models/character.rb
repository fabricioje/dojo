require 'faraday'

class Character < ApplicationRecord

    def get
        url = 'https://gateway.marvel.com:443/v1/public/'
        teste = 'https://gateway.marvel.com:443/v1/public/characters?apikey=cd08d2b0ca7081d128be7034591c5161&ts=1&hash=c1cdd5bceaa97182ca53fa05297c575c&limit=2'

        characters = []

        response = Faraday.get(teste)
        json = JSON.parse(response.body)

        
        json["data"]["results"].each do |k|
            character = Character.new(:name => k['name'], :description => k['description'])
            characters.push(character)
            character.save!
        end

        return characters
        
    end
end
