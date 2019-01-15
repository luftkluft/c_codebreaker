RSpec.describe Interface do
  let(:game) { Game.new }
  let(:name) { 'Name' }
  let(:level) { 'easy' }
  let(:path) { 'database/store.yml' }
  let(:guess) { '1234' }
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

  it 'default initialization game_mode with `console`' do
    expect(game.game_mode).to eq(CONSOLE)
  end

  context 'with web mode' do
    let(:gate) { Interface.new }
    before { gate.setup_web_mode }
    it '.setup_game_mode with `web`' do
      expect(game.game_mode).to eq(WEB)
    end

    it '.game_process#take hint' do
      gate.game_process(hint, update_data)
      expect(game.send_data).to be_a Integer
    end

    it '.stats' do
      expect(gate.stats).to be_a Array
    end

    it '.rules' do
      gate.rules
      expect(game.send_data).to match(/Codebreaker is a logic/)
    end

    it '.start with params' do
      allow(game.start(name, level))
      gate.start(name, level)
      expect(game.game_mode).to eq(WEB)
      expect(game.instance_variable_get('@name')).to eq(name)
      expect(game.instance_variable_get('@level')).to eq(level)
    end

    it '.game_process' do
      game.game_process(guess, update_data)
      expect(game.send_data).to be_a Hash
    end
  end
end
