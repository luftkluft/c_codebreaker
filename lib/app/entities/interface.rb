class Interface
  def initialize
    @game = Game.new
    @data = Output.new
  end

  def game_menu
    @game.game_menu
  end

  def start(name = '', level = '')
    @game.start(name, level)
    @data.take_storage
  end

  def rules
    @game.rules
    @data.take_storage
  end

  def stats
    @game.stats
    @data.take_storage
  end

  def game_process(guess = '', update_data = {})
    @game.game_process(guess, update_data)
    @data.take_storage
  end
end
