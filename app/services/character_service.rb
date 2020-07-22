class CharacterService

    def initialize(params = nil)
        @params = params
    end
    
    def load
        model           = Character.new
        characters      = model.load(@params)

        return[nil, :transition_not_accepted] unless characters.any?
        return[characters, :created]
    end

    def show(params)
        model   = Character.new
        characters     = model.find_all(params)

        return[{:code => "loaded"}, :item_not_found] if characters == []
        return[characters, :ok]
    end
end