module DataStorage
  FILE_NAME = 'database/data.yml'.freeze
  FILE_STORE = 'database/store.yml'.freeze

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
  end

  def put_data(object)
    File.new(FILE_STORE, 'w') unless File.exist?(FILE_STORE)
    File.open(FILE_STORE, 'w') { |file| file.write object.to_yaml }
  end

  def send_data
    if File.exist?(FILE_STORE)
      data = YAML.load_file(File.open(FILE_STORE))
      File.delete(FILE_STORE)
      return data
    end
    [Time.now.strftime('%d-%m-%Y %R')]
  end
end
