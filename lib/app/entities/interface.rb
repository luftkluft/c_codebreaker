# frozen_string_literal: true

class Interface
  attr_accessor :game
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
  end

  def rules
    # @game.rules
    ['test', 'message']
  end

  def stats
    @game.stats
  end

  def game_process(guess = '')
    @game.game_process(guess)
  end
end
