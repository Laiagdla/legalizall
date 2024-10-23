# frozen_string_literal: true

# app/controllers/players_controller.rb
class PlayersController < ApplicationController
  def index
    session[:players] ||= []
    @players = session[:players]
    create_example_players
  end

  def new
    @player = Player.new
  end

  def create_example_players
    # Create two example players and store them in the session
    example_player1 = { body_weight: 70.5, height: 175.0 }
    example_player2 = { body_weight: 60.2, height: 160.0 }

    # session[:players] ||= []  # Initialize if not already present
    session[:players] << example_player1 if session[:players].size < 4
    session[:players] << example_player2 if session[:players].size < 4
  end

  def create
    # Ensure body_weight and height are converted to float or integer
    player_params = params.require(:player).permit(:body_weight, :height)

    # Convert to numeric values
    body_weight = player_params[:body_weight].to_f
    height = player_params[:height].to_f

    @player = Player.new(body_weight: body_weight, height: height)
    if @player.valid?
      session[:players] ||= []
      if session[:players].size < 4
        session[:players] << @player
      end
    end
    #
    #   # Do something with the player object
    #   # render json: { player: @player, bmi: @player.bmi }
    # else
    #   render :new
    # end
  end

  private

  def player_params
    params.require(:player).permit(:body_weight, :height)
  end
end
