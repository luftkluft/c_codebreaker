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

  def game_process(guess = '')
    @game.game_process(guess)
    send_data
  end

  def update_game(update_data)
    @game.instance_variable_set('@name', update_data[:name])
    @game.instance_variable_set('@level', update_data[:level])
    @game.instance_variable_set('@code', update_data[:code_array])
    @game.instance_variable_set('@hints', update_data[:hints_array])
    @game.instance_variable_set('@attempts', update_data[:attempts])
  end
end
