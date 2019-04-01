RSpec.describe Game do
  let(:hints_array) { [1, 2] }
  let(:code) { [1, 2, 3, 4] }
  let(:command) { '1111' }
  let(:informat_guess) { '12345' }
  let(:invalid_name) { 'a' * rand(0..2) }
  let(:list) do
    [{
      name: valid_name,
      difficulty: Registration::DIFFICULTIES.keys.first.to_s,
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

  let(:hint) { Hint.new }

  context 'when testing #game_menu method' do
    it 'works with choice_options' do
      expect(subject.output).to receive(:start_message)
      expect(subject.output).to receive(:ask)
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
      expect(subject.output).to receive(:exit_from_game)
      subject.send(:choice_menu_process, Game::COMMANDS[:exit])
    end

    it 'returns #command_error' do
      expect(subject.output).to receive(:command_error)
      expect(subject).to receive(:game_menu)
      subject.send(:choice_menu_process, command)
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
      subject.instance_variable_set(:@attempts, Registration::DIFFICULTIES[:easy][:attempts])
      expect(subject.output).to receive(:ask) { command }
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
end
