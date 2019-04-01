RSpec.describe Registration do
  let(:hints_array) { [1, 2] }
  let(:code) { [1, 2, 3, 4] }
  let(:output) { Output.new }
  let(:valid_name) { 'a' * rand(3..20) }
  context 'when #start_info method' do
    it do
      difficulty = Registration::DIFFICULTIES[:easy]
      subject.send(:setup_difficulty, difficulty)
      expect(subject.attempts).to eq difficulty[:attempts]
      expect(subject.instance_variable_get(:@difficulty)).to eq difficulty
      subject.instance_variable_set(:@hints, hints_array)
      expect(code).to include(*subject.instance_variable_get(:@hints))
    end
  end

  context 'when testing #registration method' do
    it 'set name' do
      expect(subject.output).to receive(:ask).with(:registration).and_return(valid_name)
      subject.send(:register_user)
    end
  end

  context 'when testing #level_choice method' do
    it 'returns #generate_game' do
      level = Registration::DIFFICULTIES.keys.first
      expect(subject.output)
        .to receive(:ask)
          .with(:hard_level, levels: Registration::DIFFICULTIES.keys.join(' | ')) { level }
      expect(subject).to receive(:start_info).with(Registration::DIFFICULTIES[level.to_sym])
      subject.send(:level_choice)
    end

    it 'returns #exit' do
      exit = Game::COMMANDS[:exit]
      expect(subject.output)
        .to receive(:ask)
          .with(:hard_level, levels: Registration::DIFFICULTIES.keys.join(' | ')) { exit }
      expect(subject).to receive(:game_menu)
      subject.send(:level_choice)
    end

    it 'returns #command_error' do
      expect(subject.output)
        .to receive(:ask)
          .with(:hard_level, levels: Registration::DIFFICULTIES.keys.join(' | ')) { command }
      expect(subject.output).to receive(:command_error)
      allow(subject).to receive(:loop).and_yield
      subject.send(:level_choice)
    end
  end
end
