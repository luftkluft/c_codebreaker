# frozen_string_literal: true

class Interface
  include DataStorage
  attr_reader :game
  def initialize
    @game = Game.new
  end

  def setup_web_mode(mode = WEB)
    @game.setup_game_mode(mode)
  end

  def game_menu
    @game.game_menu
  end

  def start(name = '', level = '')
    @game.start(name, level)
  end

  def rules
    @game.rules
    send_data
  end

  def stats
    @game.stats
  end

  def game_process(guess = '')
    @game.game_process(guess)
  end
end
