class Game
  COMMANDS = {
    start: 'start',
    exit: 'exit',
    rules: 'rules',
    stats: 'stats'
  }.freeze
  HINT_COMMAND = 'hint'.freeze
  VALUE_FORMAT = /^[1-6]{4}$/.freeze

  attr_accessor :attempts, :hints, :code, :name, :level,
                :guess, :difficulty, :store, :output

  def initialize
    @output = Output.new
    @statistics = Statistics.new
    @store = Uploader.new
    @process = Processor.new
    @update_game = false
    @validator = Validator.new
    @hint = Hint.new
    @registration = Registration.new
  end

  def game_menu
    @output.start_message
    choice_menu_process(@output.ask(:choice_options, commands: COMMANDS.keys.join(' | ')))
  end

  def choice_menu_process(command_name)
    case command_name
    when COMMANDS[:start] then start && game_process
    when COMMANDS[:exit] then  @output.exit_from_game
    when COMMANDS[:rules] then rules && game_menu
    when COMMANDS[:stats] then stats && game_menu
    else
      @output.command_error
      game_menu
    end
  end

  def start(name = '', level = '')
    @registration.start(name, level)
    result = @output.take_storage
    @name = result[:name]
    @level = result[:level]
    @code = result[:code_array]
    @hints = result[:hints_array]
    @attempts = result[:attempts]
    @difficulty = result[:difficulty]
  end

  def game_process(guess = '', update_data = {})
    update_game(update_data) && @guess = guess unless guess.empty?
    while @attempts.positive?
      @guess = @output.ask if guess.empty?
      return handle_win if win?(@guess)

      choice_code_process
      return if @update_game == true
    end
    handle_lose
  end

  def win?(guess)
    @code.join == guess
  end

  def handle_lose
    @output.lost_game_message(@code)
    @store.send_lose_result(saved_data)
    game_menu if @update_game == false
  end

  def saved_data
    { name: '@name', update_game: @update_game, difficulty: @difficulty,
      attempts: @attempts, hints: @hints, code: @code }
  end

  def handle_win
    @output.win_game_message
    @store.save_winner_result(saved_data)
    game_menu if @update_game == false
  end

  def choice_code_process
    case @guess
    when HINT_COMMAND then @hint.hint_process(@hints)
    when COMMANDS[:exit] then game_menu
    else
      handle_command
    end
  end

  def handle_command
    return @output.command_error unless @validator.check_command_range(@guess, VALUE_FORMAT)

    puts start_process(@guess)
    @output.round_message if @update_game == false
    @output.put_storage(start_process(@guess))
    decrease_attempts!
  end

  def decrease_attempts!
    @attempts -= 1
  end

  def start_process(command)
    @process.guess_comparison(@code.join, command)
  end

  def update_game(update_data)
    @name = update_data[:name]
    @level = update_data[:level]
    @code = update_data[:code_array]
    @hints = update_data[:hints_array]
    @attempts = update_data[:attempts]
    @difficulty = Registration::DIFFICULTIES[@level.to_sym]
    @update_game = true
  end

  def rules
    @output.rules
  end

  def stats
    stats = @statistics.get_stats(@store.load)
    @output.put_storage(stats)
    stats
  end
end
