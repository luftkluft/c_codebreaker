# frozen_string_literal: true

class Game
  include Validator
  include DataStorage
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
  HINT_COMMAND = 'hint'
  MIN_SIZE_VALUE = 3
  MAX_SIZE_VALUE = 20
  VALUE_FORMAT = /^[1-6]{4}$/.freeze

  attr_accessor :attempts, :hints, :code, :name, :level, :guess, :difficulty, :game_mode, :renderer
  def initialize
    @game_mode = CONSOLE
    @process = Processor.new
    @renderer = Renderer.new
    @statistics = Statistics.new
    @attempts = 0
  end

  def setup_game_mode(mode = CONSOLE)
    if mode == WEB
      @game_mode = WEB
      @renderer.game_mode = WEB
      @statistics.game_mode = WEB
    end
  end

  def game_menu
    @renderer.start_message
    choice_menu_process(ask(:choice_options, commands: COMMANDS.keys.join(' | ')))
  end

  def stats
    @statistics.get_stats(load)
    game_menu unless @game_mode == WEB
  end

  def rules
    if @game_mode == WEB
      rules = Rules.new
      put_data(rules.load_rules)
      return
    else
      @renderer.rules
      game_menu
    end
  end

  # private

  def generate_game(difficulty)
    generate(difficulty)
    @renderer.message(:difficulty,
                      hints: difficulty[:hints],
                      attempts: difficulty[:attempts])
  end

  def exit_from_game
    @renderer.goodbye_message
    exit
  end

  def ask(phrase_key = nil, options = {})
    @renderer.message(phrase_key, options) if phrase_key
    gets.chomp
  end

  def level_choice
    loop do
      @level = ask(:hard_level, levels: Game::DIFFICULTIES.keys.join(' | '))
      return generate_game(Game::DIFFICULTIES[level.to_sym]) if Game::DIFFICULTIES[level.to_sym]

      return game_menu if @level == COMMANDS[:exit]

      @renderer.command_error
    end
  end

  def save_result
    if @game_mode == WEB
      @guess = ''
      put_data(to_h(@name))
      save_game_result(to_h(@name))
      return
    else
      save_game_result(to_h(@name)) if ask(:save_results_message) == CHOOSE_COMMANDS[:yes]
    end

  end

  def register_user
    loop do
      @name = ask(:registration)
      return name if name_valid?(@name)

      @renderer.length_name_error
    end
  end

  def name_valid?(name)
    !check_emptyness(name) && check_length(name, MIN_SIZE_VALUE, MAX_SIZE_VALUE)
  end

  def handle_lose
    if @game_mode == WEB
      @guess = ''
      put_data(to_h(@name).update({code: @code.join}))
      return
    else
      @renderer.lost_game_message(@code)
      game_menu
    end
  end

  def choice_code_process
    case @guess
    when HINT_COMMAND then hint_process
    when COMMANDS[:exit] then game_menu
    else
      handle_command
    end
  end

  def handle_command
    if @game_mode == WEB
      put_data(start_process(@guess))
      @guess = ''
    else
      return @renderer.command_error unless check_command_range(@guess, VALUE_FORMAT)
      p start_process(@guess)
      @renderer.round_message
    end
    decrease_attempts!
  end

  def hint_process
    if @game_mode == WEB
      @guess = ''
      put_data('no hints') and return if hints_spent?
      put_data(take_hint!)
    else
      return @renderer.no_hints_message? if hints_spent?

      @renderer.print_hint_number(take_hint!)
    end
  end

  def handle_win
    if @game_mode == WEB
      @guess = ''
      save_result
      return
    else
      @renderer.win_game_message
      save_result
      game_menu
    end
  end

  def choice_menu_process(command_name)
    case command_name
    when COMMANDS[:start] then start
    when COMMANDS[:exit] then exit_from_game
    when COMMANDS[:rules] then rules
    when COMMANDS[:stats] then stats
    else
      @renderer.command_error
      game_menu unless @game_mode == WEB
    end
  end

  def start(name = '', level = '')
    @name = name
    @name = register_user if name.empty?
    @level = level
    @level = level_choice if level.empty?
    if @game_mode == WEB
      @code = Array.new(DIGITS_COUNT) { rand(RANGE) }
      @hints = @code.sample(Game::DIFFICULTIES[level.to_sym][:hints])
      @attempts = (Game::DIFFICULTIES[level.to_sym])[:attempts]
      put_data({name: @name, level: @level,
                attempts: (Game::DIFFICULTIES[level.to_sym])[:attempts],
                hints: (Game::DIFFICULTIES[level.to_sym])[:hints],
                code_array: @code, hints_array: @hints})
    end
    
    game_process if @game_mode == CONSOLE
  end

  def game_process(guess = '', update_data = {})
    if @game_mode == WEB
      return if guess.empty?

      @guess = guess
      update_game(update_data)
    end

    while @attempts.positive?
      @guess = ask if guess.empty? && @game_mode == CONSOLE
      return handle_win if win?(@guess)
      choice_code_process
      return if @guess.empty?
    end

    handle_lose
  end

  def decrease_attempts!
    @attempts -= 1
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

  def hints_spent?
    @hints.empty?
  end

  def take_hint!
    @hints.pop
  end

  def generate(difficulty)
    @difficulty = difficulty
    if @game_mode == CONSOLE
      @code = Array.new(DIGITS_COUNT) { rand(RANGE) }
      @hints = @code.sample(difficulty[:hints])
      @attempts = difficulty[:attempts]
    end
  end

  def start_process(command)
    @process.secret_code_proc(@code.join, command)
  end

  def win?(guess)
    @code.join == guess
  end

  def update_game(update_data)
    @name = update_data[:name]
    @level = update_data[:level]
    @code = update_data[:code_array]
    @hints = update_data[:hints_array]
    @attempts = update_data[:attempts]
    @difficulty = Game::DIFFICULTIES[@level.to_sym]
  end
end
