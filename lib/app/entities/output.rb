class Output
  TEMP_FILE_NAME = 'database/temp'.freeze
  def initialize
    data = [Time.now.strftime('%d-%m-%Y %R')]
    File.new(TEMP_FILE_NAME, 'w') unless File.exist?(TEMP_FILE_NAME)
    File.open(TEMP_FILE_NAME, 'w') { |file| file.write(YAML.dump(data)) } unless File.size(TEMP_FILE_NAME).positive?
  end

  def put_storage(data)
    File.open(TEMP_FILE_NAME, 'w') { |file| file.write(YAML.dump(data)) }
  end

  def take_storage
    YAML.load_file(File.open(TEMP_FILE_NAME))
  end

  def put_console(msg_name, hash = {})
    puts I18n.t(msg_name, hash)
    put_storage(I18n.t(msg_name, hash))
  end

  def start_message
    put_console(:start_message)
  end

  def rules
    put_console(:rules)
  end

  def goodbye_message
    put_console(:goodbye_message)
  end

  def save_results_message
    put_console(:save_results_message)
  end

  def win_game_message
    put_console(:win_game_message)
  end

  def round_message
    put_console(:round_message)
  end

  def lost_game_message(code)
    put_console(:lost_game_message, code: code)
  end

  def no_hints_message?
    put_console(:have_no_hints_message)
  end

  def print_hint_number(code)
    put_console(:print_hint_number, code: code)
  end

  def registration_name_emptyness_error
    put_console(:registration_name_emptyness_error)
  end

  def length_name_error
    put_console(:registration_name_length_error)
  end

  def command_error
    put_console(:command_error)
  end

  def command_length_error
    put_console(:command_length_error)
  end

  def command_int_error
    put_console(:command_int_error)
  end

  def ask(phrase_key = nil, options = {})
    put_console(phrase_key, options) if phrase_key
    gets.chomp
  end

  def exit_from_game
    goodbye_message
    exit
  end
end
