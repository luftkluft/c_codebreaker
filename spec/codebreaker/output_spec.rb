RSpec.describe Output do
  let(:code) { '1111' }

  context 'when #put_storage method' do
    it 'return data' do
      subject.put_storage(code)
      expect(subject.take_storage).to eq(code)
    end
  end

  context 'when #message method' do
    it 'return puts I18n' do
      msg = :start_message
      expect(I18n).to receive(:t).with(msg, {})
      subject.put_console(msg)
    end
  end

  context 'when #start_message method' do
    it 'return start_message' do
      expect(subject).to receive(:put_console).with(:start_message)
      subject.start_message
    end
  end

  context 'when #rules method' do
    it 'return rules' do
      expect(subject).to receive(:put_console).with(:rules)
      subject.rules
    end
  end

  context 'when #goodbye_message method' do
    it 'return goodbye_message' do
      expect(subject).to receive(:put_console).with(:goodbye_message)
      subject.goodbye_message
    end
  end

  context 'when #save_results_message method' do
    it 'return save_results_message' do
      expect(subject).to receive(:put_console).with(:save_results_message)
      subject.save_results_message
    end
  end

  context 'when #win_game_message method' do
    it 'return win_game_message' do
      expect(subject).to receive(:put_console).with(:win_game_message)
      subject.win_game_message
    end
  end

  context 'when #round_message method' do
    it 'return promt_to_enter_secret_code_hint_exit' do
      expect(subject).to receive(:put_console).with(:round_message)
      subject.round_message
    end
  end

  context 'when #lost_game_message method' do
    it 'return lost_game_message' do
      expect(subject).to receive(:put_console).with(:lost_game_message, code: code)
      subject.lost_game_message(code)
    end
  end

  context 'when #no_hints_message? method' do
    it 'return no_hints_message?' do
      expect(subject).to receive(:put_console).with(:have_no_hints_message)
      subject.no_hints_message?
    end
  end

  context 'when #print_hint_number method' do
    it 'return print_hint_number' do
      expect(subject).to receive(:put_console).with(:print_hint_number, code: code)
      subject.print_hint_number(code)
    end
  end

  context 'when #registration_name_emptyness_error method' do
    it 'return registration_name_emptyness_error' do
      expect(subject).to receive(:put_console).with(:registration_name_emptyness_error)
      subject.registration_name_emptyness_error
    end
  end

  context 'when #registration_name_length_error method' do
    it 'return registration_name_length_error' do
      expect(subject).to receive(:put_console).with(:registration_name_length_error)
      subject.length_name_error
    end
  end

  context 'when #command_error method' do
    it 'return command_error' do
      expect(subject).to receive(:put_console).with(:command_error)
      subject.command_error
    end
  end

  context 'when #command_length_error method' do
    it 'return command_length_error' do
      expect(subject).to receive(:put_console).with(:command_length_error)
      subject.command_length_error
    end
  end

  context 'when #command_int_error method' do
    it 'return command_int_error' do
      expect(subject).to receive(:put_console).with(:command_int_error)
      subject.command_int_error
    end
  end
end
