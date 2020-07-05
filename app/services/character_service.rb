class CharacterService
    def get 

        model   = Character.new
        characters     = model.get
        return[characters, :created] if !characters.nil?

    end
end