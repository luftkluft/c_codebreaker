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
  let(:store) { Uploader.new }
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
end
