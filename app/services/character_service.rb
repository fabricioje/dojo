class CharacterService

    def initialize(params = nil)
        @params = params
    end
    
    def load
        model           = Character.new
        characters      = model.load(@params)
        return[characters, :created] if !characters.nil?
    end

    def show
        model   = Character.new
        characters     = model.find_all

        return[nil, :item_not_found] if characters.nil?
        return[characters, :ok]
    end
end