RSpec.describe Interface do
  let(:game) { Game.new }
  let(:data) { Output.new }
  let(:name) { 'Name' }
  let(:level) { 'easy' }
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

  it '.rules' do
    subject.rules
    expect(data.take_storage).to match(/Codebreaker is a logic/)
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
end
