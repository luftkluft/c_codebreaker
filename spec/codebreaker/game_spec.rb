RSpec.describe Game do
  let(:hints_array) { [1, 2] }
  let(:code) { [1, 2, 3, 4] }
  let(:command) { '1111' }
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
  include DataStorage
  let(:statistics) { Statistics.new }

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

  it '.update_game' do
    subject.update_game(update_data)
    expect(subject.instance_variable_get('@hints')).to be_a Array
    expect(subject.instance_variable_get('@hints').size).to be 2
    expect(subject.instance_variable_get('@attempts')).to be 5
  end

  context 'when testing #take_a_hint! method' do
    it 'returnes last el of hints array' do
      subject.instance_variable_set(:@hints, hints_array)
      expected_value = subject.hints.last
      expect(subject.take_hint!).to eq expected_value
    end
  end

  context 'when #generate method' do
    it do
      difficulty = Game::DIFFICULTIES[:easy]
      subject.generate(difficulty)
      expect(subject.attempts).to eq difficulty[:attempts]
      expect(subject.instance_variable_get(:@difficulty)).to eq difficulty
      subject.instance_variable_set(:@hints, hints_array)
      expect(code).to include(*subject.instance_variable_get(:@hints))
    end
  end

  context 'when #start_process method' do
    it do
      process = subject.instance_variable_get(:@process)
      win_code = Array.new(Game::DIGITS_COUNT, Processor::MATCHED_DIGIT_CHAR)
      subject.instance_variable_set(:@code, win_code)
      expect(process).to receive(:secret_code_proc).with(win_code.join, start_code)
      subject.start_process(start_code)
    end
  end

  context 'used #decrease_attempts! method' do
    it 'decreases attempts by one when used' do
      subject.instance_variable_set(:@attempts, 3)
      expect { subject.decrease_attempts! }.to change(subject, :attempts).by(-1)
    end
  end

  context 'when testing #hints_spent? method' do
    it 'returns true' do
      subject.instance_variable_set(:@hints, [])
      expect(subject.hints_spent?).to be true
    end

    it 'returns false' do
      subject.instance_variable_set(:@hints, [1, 2])
      expect(subject.hints_spent?).to be false
    end
  end

  context 'when testing #to_h method' do
    it 'returns hash' do
      subject.instance_variable_set(:@difficulty, Game::DIFFICULTIES[:easy])
      subject.instance_variable_set(:@attempts, 2)
      subject.instance_variable_set(:@hints, hints_array)
      expect(subject.to_h(valid_name)).to be_an_instance_of(Hash)
    end
  end

  context 'when testing #game_menu method' do
    it 'works with choice_options' do
      expect(subject.renderer).to receive(:start_message)
      expect(subject).to receive(:ask)
      expect(subject).to receive(:choice_menu_process).once
      subject.game_menu
    end
  end

  context 'when testing #rules' do
    it 'calls rules message' do
      expect(subject.renderer).to receive(:rules)
      expect(subject).to receive(:game_menu)
      subject.send(:rules)
    end
  end

  context 'when testing #console start method' do
    it do
      expect(subject).to receive(:register_user)
      expect(subject).to receive(:level_choice)
      expect(subject).to receive(:game_process)
      subject.send(:start)
    end
  end

  context 'when testing data_storage module' do
    let(:path) { 'database/data_test.yml' }
    before do
      File.new(path, 'w+')
      stub_const('DataStorage::FILE_NAME', 'database/data_test.yml')
    end

    after { File.delete(path) }

    context 'when testing #stats method' do
      it 'returns stats' do
        allow(load) { list }
        allow(statistics).to receive(:get_stats).with(load)
        expect(subject).to receive(:game_menu).and_return('exit')
        subject.send(:stats)
      end
    end
  end

  context 'when testing #registration method' do
    it 'set name' do
      expect(subject).to receive(:ask).with(:registration).and_return(valid_name)
      subject.send(:register_user)
    end
  end

  context 'when testing #name_valid? method' do
    it 'returns true' do
      expect(subject.send(:name_valid?, valid_name)).to be true
    end

    it 'returns false' do
      expect(subject.send(:name_valid?, invalid_name)).to be false
    end
  end

  context 'when testing #level_choice method' do
    it 'returns #generate_game' do
      level = Game::DIFFICULTIES.keys.first
      expect(subject).to receive(:ask).with(:hard_level, levels: Game::DIFFICULTIES.keys.join(' | ')) { level }
      expect(subject).to receive(:generate_game).with(Game::DIFFICULTIES[level.to_sym])
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
      expect(subject.renderer).to receive(:command_error)
      allow(subject).to receive(:loop).and_yield
      subject.send(:level_choice)
    end
  end

  context 'when testing #choice_code_process method' do
    it 'returns #take_a_hint!' do
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
      expect(subject.renderer).to receive(:command_error)
      expect(subject).to receive(:game_menu)
      subject.send(:choice_menu_process, command)
    end
  end

  context 'when testing #exit_from_game method' do
    it 'returns message' do
      expect(subject.renderer).to receive(:goodbye_message)
      expect(subject).to receive(:exit)
      subject.send(:exit_from_game)
    end
  end

  context 'when testing #hint_process method' do
    it 'returns no_hints_message?' do
      subject.instance_variable_set(:@hints, [])
      expect(subject.renderer).to receive(:no_hints_message?)
      subject.send(:hint_process)
    end
  end

  context 'when testing #generate_game method' do
    it do
      difficulty = Game::DIFFICULTIES[:easy]
      expect(subject).to receive(:generate).with(difficulty)
      expect(subject.renderer).to receive(:message).with(:difficulty,
                                                         hints: difficulty[:hints],
                                                         attempts: difficulty[:attempts])
      subject.send(:generate_game, difficulty)
    end
  end

  context 'when testing #handle_lose method' do
    it do
      expect(subject.renderer).to receive(:lost_game_message).with(subject.code)
      expect(subject).to receive(:game_menu)
      subject.send(:handle_lose)
    end
  end

  context 'when testing #handle_win method' do
    it do
      expect(subject.renderer).to receive(:win_game_message)
      expect(subject).to receive(:save_result)
      expect(subject).to receive(:game_menu)
      subject.send(:handle_win)
    end
  end

  context 'when testing #game_process method' do
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
  end

  context 'when testing #ask method' do
    it 'retuns msg' do
      phrase_key = :rules
      expect(subject.renderer).to receive(:message).with(phrase_key, {})
      allow(subject).to receive(:gets).and_return('')
      subject.send(:ask, phrase_key)
    end
  end
end
