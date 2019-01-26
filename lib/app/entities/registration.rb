class Registration
  DIGITS_COUNT = 4
  RANGE = (1..6).freeze
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

  attr_accessor :attempts, :hints, :code, :name, :level, :guess, :difficulty, :output

  def initialize
    @output = Output.new
    @validator = Validator.new
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
                        attempts: @attempts,
                        code_array: @code,
                        hints_array: @hints,
                        difficulty: @difficulty)
  end

  def register_user
    loop do
      @name = @output.ask(:registration)
      return @name if @validator.name_valid?(@name)

      @output.length_name_error
    end
  end

  def level_choice
    loop do
      @level = @output.ask(:hard_level, levels: DIFFICULTIES.keys.join(' | '))
      return start_info(DIFFICULTIES[@level.to_sym]) if DIFFICULTIES[@level.to_sym]

      @output.exit_from_game if @level == Game::COMMANDS[:exit]
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
end
