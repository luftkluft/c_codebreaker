# frozen_string_literal: true

RSpec.describe Interface do
  include DataStorage
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
    expect(game.instance_variable_get('@game_mode')).to eq(CONSOLE)
    expect(game.renderer.instance_variable_get('@game_mode')).to eq(CONSOLE)
  end

  context 'with web mode' do
    before { game.setup_game_mode(WEB) }
    after { File.delete(path) if File.exist?(path) }
    it '.setup_game_mode with `web`' do
      expect(game.instance_variable_get('@game_mode')).to eq(WEB)
      expect(game.renderer.instance_variable_get('@game_mode')).to eq(WEB)
    end

    it '.game_process#take hint' do
      game.game_process(hint, update_data)
      expect(send_data).to be_a Integer
    end

    it '.rules' do
      game.rules
      expect(send_data).to match(/Codebreaker is a logic/)
    end

    it '.start with params' do
      game.instance_variable_set('@guess', '1234')
      game.start(name, level)
      expect(game.instance_variable_get('@name')).to eq(name)
      expect(game.instance_variable_get('@level')).to eq(level)
      game.instance_variable_set('@guess', guess)
    end

    it '.game_process' do
      game.game_process(guess, update_data)
      expect(send_data).to be_a Hash
    end
  end
end
