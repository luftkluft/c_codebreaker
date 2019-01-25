require 'pry'
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
  end

  def game_menu
    @output.start_message
    choice_menu_process(ask(:choice_options, commands: COMMANDS.keys.join(' | ')))
  end

  def choice_menu_process(command_name)
    case command_name
    when COMMANDS[:start] then start # && game_process
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
    @guess = guess
    update_game(update_data)
    while @attempts.positive?
      @guess = ask if guess.empty?
      return handle_win if win?(@guess)

      choice_code_process
    end
    handle_lose
  end

  def update_game(update_data)
    @name = update_data[:name]
    @level = update_data[:level]
    @code = update_data[:code_array]
    @hints = update_data[:hints_array]
    @attempts = update_data[:attempts]
    @difficulty = DIFFICULTIES[@level.to_sym]
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
