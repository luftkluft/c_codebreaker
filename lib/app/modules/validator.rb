module Validator
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
