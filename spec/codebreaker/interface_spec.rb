# frozen_string_literal: true

RSpec.describe Interface do
  let(:game) { Game.new }
  let(:name) { 'Name' }
  let(:level) { 'easy' }
  it 'default initialization game_mode with `console`' do
    expect(game.instance_variable_get('@game_mode')).to eq(CONSOLE)
    expect(game.renderer.instance_variable_get('@game_mode')).to eq(CONSOLE)
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
    end
  end
end
