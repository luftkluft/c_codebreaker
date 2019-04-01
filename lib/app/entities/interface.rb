class Interface
  def initialize
    @game = Game.new
    @output = Output.new
    @painter = Painter.new
  end

  def game_menu
    @game.game_menu
  end

  def start(name = '', level = '')
    @game.start(name, level)
    @output.take_storage
  end

  def rules
    @game.rules
    @output.take_storage
  end

  def stats
    @game.stats
    @output.take_storage
  end

  def game_process(guess = '', update_data = {})
    @game.game_process(guess, update_data)
    @output.take_storage
  end

  def paint_answer(answer)
    @painter.paint_answer(answer)
  end
end
