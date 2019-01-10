# frozen_string_literal: true

class Renderer
  attr_accessor :game_mode
  def initialize
    @game_mode = CONSOLE
  end

  def message(msg_name, hash = {})
    return [I18n.t(msg_name, hash)] if @game_mode == WEB

    puts I18n.t(msg_name, hash)
  end

  def start_message
    message(:start_message)
  end

  def rules
    I18n.t('rules')
    # message(:rules)
  end

  def goodbye_message
    message(:goodbye_message)
  end

  def save_results_message
    message(:save_results_message)
  end

  def win_game_message
    message(:win_game_message)
  end

  def round_message
    message(:round_message)
  end

  def lost_game_message(code)
    message(:lost_game_message, code: code)
  end

  def no_hints_message?
    message(:have_no_hints_message)
  end

  def print_hint_number(code)
    message(:print_hint_number, code: code)
  end

  def registration_name_emptyness_error
    message(:registration_name_emptyness_error)
  end

  def length_name_error
    message(:registration_name_length_error)
  end

  def command_error
    message(:command_error)
  end

  def command_length_error
    message(:command_length_error)
  end

  def command_int_error
    message(:command_int_error)
  end
end
