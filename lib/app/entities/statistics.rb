class Statistics
  include DataStorage
  attr_accessor :game_mode

  def initialize
    @game_mode = CONSOLE
  end

  def get_stats(scores)
    render_stats(sort(scores)) if scores
  end

  def sort(list)
    list.sort_by do |result|
      [result[:all_attempts], result[:attempts_used], result[:hints_used]]
    end
  end

  def render_stats(list)
    # put_data([list]) && return if @game_mode == WEB
    list.each_with_index do |key, index|
      puts "#{index + 1}: "
      key.each { |param, value| puts "#{param}:#{value}" }
    end
  end
end
