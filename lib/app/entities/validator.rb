class Validator
  MIN_SIZE_VALUE = 3
  MAX_SIZE_VALUE = 20
  def name_valid?(name)
    !check_emptyness(name) && check_length(name, MIN_SIZE_VALUE, MAX_SIZE_VALUE)
  end

  def check_emptyness(value)
    value.empty?
  end

  def check_length(value, min_size, max_size)
    value.size.between?(min_size, max_size)
  end

  def check_command_range(command, format)
    command =~ format
  end
end
