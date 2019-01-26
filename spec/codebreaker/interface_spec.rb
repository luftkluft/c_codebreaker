RSpec.describe Interface do
  let(:game) { Game.new }
  let(:data) { Output.new }
  let(:painter) { Painter.new }
  let(:name) { 'Name' }
  let(:level) { 'easy' }
  let(:winner_guess) { '1234' }
  let(:guess) { '1111' }
  let(:hint) { 'hint' }
  let(:code_array) { [1, 2, 3, 4] }
  let(:attempts) { 5 }
  let(:hints_array) { [1, 2] }
  let(:update_data) do
    { name: name, level: level,
      code_array: code_array,
      hints_array: hints_array,
      attempts: attempts }
  end
  let(:answer) { '+-' }
  let(:paint_result) { { answer: '+-xx', mark: %w[success primary danger danger] } }

  it '.paint_answer' do
    expect(subject.paint_answer(answer)).to eq(paint_result)
  end

  it '.rules' do
    subject.rules
    expect(data.take_storage).to match(I18n.t('rules'))
  end

  it '.stats' do
    expect(subject.stats).to be_a Array
  end

  it '.start with params' do
    subject.start(name, level)
    expect(data.take_storage).to be_a Hash
    expect(data.take_storage.size).to be 6
    expect(data.take_storage[:name]).to eq(name)
  end

  context 'with .game_process' do
    it 'winner_guess request' do
      subject.game_process(winner_guess, update_data)
      expect(data.take_storage).to be_a Hash
      expect(data.take_storage.size).to be 7
      expect(data.take_storage[:name]).to eq(name)
    end

    it 'guess request' do
      subject.game_process('1111', update_data)
      expect(data.take_storage).to match(ANSWER)
    end

    it 'hint request' do
      subject.game_process(hint, update_data)
      expect(data.take_storage).to match(HINT_NUMBER)
    end
  end
end
