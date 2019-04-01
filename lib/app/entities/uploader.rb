class Uploader
  FILE_NAME = 'database/data.yml'.freeze
  CHOOSE_COMMANDS = {
    yes: 'y'
  }.freeze

  def initialize
    @output ||= Output.new
  end

  def create
    File.new(FILE_NAME, 'w')
    File.write(FILE_NAME, [].to_yaml)
  end

  def load
    YAML.load_file(File.open(FILE_NAME)) if storage_exist?
  end

  def save(object)
    File.open(FILE_NAME, 'w') { |file| file.write(YAML.dump(object)) }
  end

  def storage_exist?
    File.exist?(FILE_NAME)
  end

  def save_game_result(object)
    create unless storage_exist?
    save(load.push(object))
    @output.put_storage(object)
  end

  def save_winner_result(saved_data)
    return save_game_result(to_h(saved_data)) if saved_data[:update_game] == true

    save_game_result(to_h(saved_data)) if @output.ask(:save_results_message) == CHOOSE_COMMANDS[:yes]
  end

  def send_lose_result(saved_data)
    lose_result = to_h(saved_data).update(code: saved_data[:code].join)
    @output.put_storage(lose_result)
  end

  def to_h(saved_data)
    {
      name: saved_data[:name],
      difficulty: Registration::DIFFICULTIES.key(saved_data[:difficulty]),
      all_attempts: saved_data[:difficulty][:attempts],
      all_hints: saved_data[:difficulty][:hints],
      attempts_used: saved_data[:difficulty][:attempts] - saved_data[:attempts],
      hints_used: saved_data[:difficulty][:hints] - saved_data[:hints].length,
      date: Time.now.strftime('%d-%m-%Y %R')
    }
  end
end
