class Interface
  def initialize
    @game = Game.new
  end

  def game_menu
    @game.game_menu
  end

  def start(name = '', level = '')
    setup_web_mode
    @game.start(name, level)
    @game.send_data
  end

  def rules
    setup_web_mode
    @game.rules
    @game.send_data
  end

  def stats
    setup_web_mode
    @game.stats
    @game.send_data
  end

  def game_process(guess = '', update_data = {})
    setup_web_mode
    @game.game_process(guess, update_data)
    @game.send_data
  end

  def setup_web_mode
    @game.setup_game_mode(WEB)
  end
end
