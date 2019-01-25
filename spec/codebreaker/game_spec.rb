RSpec.describe Game do
  let(:hints_array) { [1, 2] }
  let(:code) { [1, 2, 3, 4] }
  let(:command) { '1111' }
  let(:informat_guess) { '12345' }
  let(:valid_name) { 'a' * rand(3..20) }
  let(:invalid_name) { 'a' * rand(0..2) }
  let(:list) do
    [{
      name: valid_name,
      difficulty: Game::DIFFICULTIES.keys.first.to_s,
      all_attempts: 15,
      attempts_used: 15,
      all_hints: 2,
      hints_used: 0
    }]
  end

  let(:lose_result) { '-+++' }
  let(:start_code) { '1111' }
  let(:hints_array) { [1, 1] }
  let(:valid_name) { 'a' * rand(3..20) }
  let(:code) { [1, 1, 1, 1] }
  let(:path) { 'database/store.yml' }
  let(:store) { Uploader.new }
  let(:statistics) { Statistics.new }
  let(:output) { Output.new }

  let(:name) { 'Name' }
  let(:level) { 'easy' }
  let(:code_array) { [1, 2, 3, 4] }
  let(:attempts) { 5 }
  let(:update_data) do
    { name: name, level: level,
      code_array: code_array,
      hints_array: hints_array,
      attempts: attempts }
  end

  context 'when testing #exit_from_game method' do
    it 'returns message' do
      expect(subject.output).to receive(:goodbye_message)
      expect(subject).to receive(:exit)
      subject.send(:exit_from_game)
    end
  end

  context 'when testing #game_menu method' do
    it 'works with choice_options' do
      expect(subject.output).to receive(:start_message)
      expect(subject).to receive(:ask)
      expect(subject).to receive(:choice_menu_process).once
      subject.game_menu
    end
  end

  context 'when testing #choice_menu_process' do
    %i[rules stats start].each do |command|
      it "returns ##{command}" do
        expect(subject).to receive(command)
        subject.send(:choice_menu_process, Game::COMMANDS[command])
      end
    end

    it 'returns #exit_from_game' do
      expect(subject).to receive(:exit_from_game)
      subject.send(:choice_menu_process, Game::COMMANDS[:exit])
    end

    it 'returns #command_error' do
      expect(subject.output).to receive(:command_error)
      expect(subject).to receive(:game_menu)
      subject.send(:choice_menu_process, command)
    end
  end

  context 'when #start_info method' do
    it do
      difficulty = Game::DIFFICULTIES[:easy]
      subject.send(:setup_difficulty, difficulty)
      expect(subject.attempts).to eq difficulty[:attempts]
      expect(subject.instance_variable_get(:@difficulty)).to eq difficulty
      subject.instance_variable_set(:@hints, hints_array)
      expect(code).to include(*subject.instance_variable_get(:@hints))
    end
  end

  context 'when testing #registration method' do
    it 'set name' do
      expect(subject).to receive(:ask).with(:registration).and_return(valid_name)
      subject.send(:register_user)
    end
  end

  context 'when testing #level_choice method' do
    it 'returns #generate_game' do
      level = Game::DIFFICULTIES.keys.first
      expect(subject).to receive(:ask).with(:hard_level, levels: Game::DIFFICULTIES.keys.join(' | ')) { level }
      expect(subject).to receive(:start_info).with(Game::DIFFICULTIES[level.to_sym])
      subject.send(:level_choice)
    end

    it 'returns #game_menu' do
      exit = Game::COMMANDS[:exit]
      expect(subject).to receive(:ask).with(:hard_level, levels: Game::DIFFICULTIES.keys.join(' | ')) { exit }
      expect(subject).to receive(:game_menu)
      subject.send(:level_choice)
    end

    it 'returns #command_error' do
      expect(subject).to receive(:ask).with(:hard_level, levels: Game::DIFFICULTIES.keys.join(' | ')) { command }
      expect(subject.output).to receive(:command_error)
      allow(subject).to receive(:loop).and_yield
      subject.send(:level_choice)
    end
  end

  it '.update_game' do
    subject.send(:update_game, update_data)
    expect(subject.instance_variable_get('@hints')).to be_a Array
    expect(subject.instance_variable_get('@hints').size).to be 2
    expect(subject.instance_variable_get('@attempts')).to be 5
  end

  context 'when testing #game_process method' do
    before do
      subject.send(:update_game, update_data)
    end

    it 'returns #handle_win' do
      subject.instance_variable_set(:@attempts, Game::DIFFICULTIES[:easy][:attempts])
      expect(subject).to receive(:ask) { command }
      expect(subject).to receive(:win?).with(command) { true }
      expect(subject).to receive(:handle_win)
      subject.send(:game_process)
    end
    it 'retuns #handle_lose' do
      subject.instance_variable_set(:@attempts, 0)
      expect(subject).to receive(:handle_lose)
      subject.send(:game_process)
    end

    it '#handle_lose message' do
      subject.instance_variable_set(:@attempts, 0)
      subject.send(:handle_lose)
      expect(output.take_storage[:code]).to eq(code_array.join)
    end
  end

  context 'when testing #choice_code_process method' do
    it 'returns #take_hint!' do
      subject.instance_variable_set(:@guess, Game::HINT_COMMAND)
      expect(subject).to receive(:hint_process)
      subject.send(:choice_code_process)
    end

    it 'returns #game_menu' do
      subject.instance_variable_set(:@guess, Game::COMMANDS[:exit])
      expect(subject).to receive(:game_menu)
      subject.send(:choice_code_process)
    end

    it 'returns #handle_command' do
      subject.instance_variable_set(:@guess, command)
      expect(subject).to receive(:handle_command)
      subject.send(:choice_code_process)
    end
  end

  context '.handle_command' do
    before do
      subject.send(:update_game, update_data)
    end

    it '#true guess' do
      subject.instance_variable_set(:@guess, command)
      subject.send(:handle_command)
      expect(output.take_storage).to match(ANSWER)
    end

    it '#informat guess' do
      subject.instance_variable_set(:@guess, informat_guess)
      subject.send(:handle_command)
      expect(output.take_storage).to match(I18n.t('command_error'))
    end
  end

  context '.hint_process' do
    it 'hint array is empty' do
      subject.instance_variable_set(:@hints, [])
      subject.send(:hint_process)
      expect(output.take_storage).to match(I18n.t('have_no_hints_message'))
    end

    it 'hint array is sized' do
      subject.instance_variable_set(:@hints, hints_array)
      subject.send(:hint_process)
      expect(output.take_storage).to match(HINT_NUMBER)
    end
  end
end
