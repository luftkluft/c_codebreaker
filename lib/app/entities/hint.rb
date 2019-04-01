class Hint
  def initialize
    @output ||= Output.new
  end

  def hint_process(hints)
    return @output.no_hints_message? if hints_spent?(hints)

    @output.print_hint_number(take_hint!(hints))
  end

  def take_hint!(hints)
    hints.pop
  end

  def hints_spent?(hints)
    hints.empty?
  end
end
