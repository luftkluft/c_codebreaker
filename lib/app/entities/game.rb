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

  attr_accessor :output

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
    when COMMANDS[:start] then start
    when COMMANDS[:exit] then exit_from_game
    when COMMANDS[:rules] then rules && game_menu
    when COMMANDS[:stats] then stats && game_menu
    else
      @output.command_error
      game_menu
    end
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
end
