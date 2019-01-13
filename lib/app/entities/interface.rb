# frozen_string_literal: true

class Interface
  include DataStorage
  attr_reader :game
  def initialize
    @game = Game.new
  end

  def setup_web_mode
    @game.setup_game_mode(WEB)
  end

  def game_menu
    @game.game_menu
  end

  def start(name = '', level = '')
    @game.start(name, level)
    send_data
  end

  def rules
    @game.rules
    send_data
  end

  def stats
    @game.stats
    send_data
  end

  def game_process(guess = '', update_data = {})
    @game.game_process(guess, update_data)
    send_data
  end
end
