class Game
  DIGITS_COUNT = 4
  DIFFICULTIES = {
    easy: {
      attempts: 15,
      hints: 2
    },
    medium: {
      attempts: 10,
      hints: 1
    },
    hell: {
      attempts: 5,
      hints: 1
    }
  }.freeze
  RANGE = (1..6).freeze
  COMMANDS = {
    start: 'start',
    exit: 'exit',
    rules: 'rules',
    stats: 'stats'
  }.freeze
  CHOOSE_COMMANDS = {
    yes: 'y'
  }.freeze
  HINT_COMMAND = 'hint'.freeze
  MIN_SIZE_VALUE = 3
  MAX_SIZE_VALUE = 20
  VALUE_FORMAT = /^[1-6]{4}$/.freeze

  attr_accessor :attempts, :hints, :code, :name, :level, :guess,
                :difficulty, :store, :output

  def initialize
    @output = Output.new
    @statistics = Statistics.new
    @store = Uploader.new
    @process = Processor.new
    @update_game = false
  end

  def game_menu
    @output.start_message
    choice_menu_process(ask(:choice_options, commands: COMMANDS.keys.join(' | ')))
  end

  def choice_menu_process(command_name)
    case command_name
    when COMMANDS[:start] then start && game_process
    when COMMANDS[:exit] then exit_from_game
    when COMMANDS[:rules] then rules && game_menu
    when COMMANDS[:stats] then stats && game_menu
    else
      @output.command_error
      game_menu
    end
  end

  def start(name = '', level = '')
    @name = name
    @name = register_user if name.empty?
    @level = level
    level_choice if level.empty?
    @code = Array.new(DIGITS_COUNT) { rand(RANGE) }
    @hints = @code.sample(DIFFICULTIES[@level.to_sym][:hints])
    @attempts = (DIFFICULTIES[@level.to_sym])[:attempts]
    @output.put_storage(name: @name, level: @level,
                        attempts: (DIFFICULTIES[@level.to_sym])[:attempts],
                        hints: (DIFFICULTIES[@level.to_sym])[:hints],
                        code_array: @code, hints_array: @hints)
  end

  def register_user
    loop do
      @name = ask(:registration)
      return @name if name_valid?(@name)

      @output.length_name_error
    end
  end

  def level_choice
    loop do
      @level = ask(:hard_level, levels: DIFFICULTIES.keys.join(' | '))
      return start_info(DIFFICULTIES[@level.to_sym]) if DIFFICULTIES[@level.to_sym]

      return game_menu if @level == COMMANDS[:exit]

      @output.command_error
    end
  end

  def start_info(difficulty)
    setup_difficulty(difficulty)
    @output.put_console(:difficulty,
                        hints: difficulty[:hints],
                        attempts: difficulty[:attempts])
  end

  def setup_difficulty(difficulty)
    @difficulty = difficulty
    @code = Array.new(DIGITS_COUNT) { rand(RANGE) }
    @hints = @code.sample(difficulty[:hints])
    @attempts = difficulty[:attempts]
  end

  def game_process(guess = '', update_data = {})
    update_game(update_data) && @guess = guess unless guess.empty?
    while @attempts.positive?
      @guess = ask if guess.empty?
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
    @output.put_storage(to_h(@name).update(code: @code.join))
    game_menu if @update_game == false
  end

  def handle_win
    @output.win_game_message
    @output.put_storage(to_h(@name).update(code: @code.join))
    save_result
    game_menu if @update_game == false
  end

  def save_result
    return @store.save_game_result(to_h(@name)) if @update_game == true

    @store.save_game_result(to_h(@name)) if ask(:save_results_message) == CHOOSE_COMMANDS[:yes]
  end

  def to_h(name)
    {
      name: name,
      difficulty: DIFFICULTIES.key(@difficulty),
      all_attempts: @difficulty[:attempts],
      all_hints: @difficulty[:hints],
      attempts_used: @difficulty[:attempts] - @attempts,
      hints_used: @difficulty[:hints] - @hints.length,
      date: Time.now.strftime('%d-%m-%Y %R')
    }
  end

  def choice_code_process
    case @guess
    when HINT_COMMAND then hint_process
    when COMMANDS[:exit] then game_menu
    else
      handle_command
    end
  end

  def hint_process
    return @output.no_hints_message? if hints_spent?

    @output.print_hint_number(take_hint!)
  end

  def take_hint!
    @hints.pop
  end

  def hints_spent?
    @hints.empty?
  end

  def handle_command
    return @output.command_error unless check_command_range(@guess, VALUE_FORMAT)

    puts start_process(@guess)
    @output.round_message
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
    @difficulty = DIFFICULTIES[@level.to_sym]
    @update_game = true
  end

  def rules
    @output.rules
  end

  def stats
    stats = @statistics.get_stats(@store.load)
    stats = [] if stats.nil?
    @output.put_storage(stats)
    stats
  end

  def exit_from_game
    @output.goodbye_message
    exit
  end

  def ask(phrase_key = nil, options = {})
    @output.put_console(phrase_key, options) if phrase_key
    gets.chomp
  end

  def name_valid?(name)
    !check_emptyness(name) && check_length(name, MIN_SIZE_VALUE, MAX_SIZE_VALUE)
  end

  def check_emptyness(value)
    value.empty?
  end

  def check_length(value, min_size, max_size)
    value.size.between?(min_size, max_size)
  end

  def check_command_range(command, format)
    command =~ format
  end
end
