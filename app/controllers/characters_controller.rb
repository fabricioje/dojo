class CharactersController < ApplicationController
  # before_action :set_character, only: [:show, :update, :delete]

  # POST /load
  def load

    service           = CharacterService.new(character_params)
    characters, code  = service.load

    presenter         = ApplicationPresenter.new(characters, code)
    render presenter.as_json
  end

  # GET /
  def show

    pp params

    service           = CharacterService.new
    characters, code  = service.show(params)

    presenter         = ApplicationPresenter.new(characters, code)
    render presenter.as_json
  end

  # GET /characters
  def index
    @characters = Character.all

    render json: @characters
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def character_params
      params.permit(:apikey, :hash, :ts, :limit)
    end
end
