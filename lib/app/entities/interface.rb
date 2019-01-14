class Interface
  # include DataStorage
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
    @game.send_data
  end

  def rules
    @game.rules
    @game.send_data
  end

  def stats
    @game.stats
    @game.send_data
  end

  def game_process(guess = '', update_data = {})
    @game.game_process(guess, update_data)
    @game.send_data
  end
end
