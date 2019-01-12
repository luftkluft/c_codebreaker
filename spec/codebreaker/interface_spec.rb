# frozen_string_literal: true

RSpec.describe Interface do
  let(:game) { Game.new }
  let(:name) { 'Name' }
  let(:level) { 'easy' }
  let(:path) { 'database/store.yml' }
  let(:guess) { '1234' }
  let(:code_array) { [1, 2, 3, 4] }
  let(:hints_array) { [1, 2] }
  let(:attempts) { 5 }
  let(:update_data) { {name: name, level: level,
                       code_array: code_array,
                       hints_array: hints_array,
                       attempts: attempts } }
  it 'default initialization game_mode with `console`' do
    expect(game.instance_variable_get('@game_mode')).to eq(CONSOLE)
    expect(game.renderer.instance_variable_get('@game_mode')).to eq(CONSOLE)
  end

  it '.update_game' do
    game.update_game(update_data)
    expect(game.instance_variable_get('@hints')).to be_a Array
    expect(game.instance_variable_get('@hints').size).to be 2
    expect(game.instance_variable_get('@attempts')).to be 5
  end

  context 'with web mode' do
    before { game.setup_game_mode(WEB) }
    it '.setup_game_mode with `web`' do
      expect(game.instance_variable_get('@game_mode')).to eq(WEB)
      expect(game.renderer.instance_variable_get('@game_mode')).to eq(WEB)
    end

    it '.game.start with params' do
      game.instance_variable_set('@guess', '1234') # TODO
      game.start(name, level)
      expect(game.instance_variable_get('@name')).to eq(name)
      expect(game.instance_variable_get('@level')).to eq(level)
      game.instance_variable_set('@guess', guess)
      File.delete(path) if File.exist?(path)
    end
  end
end
