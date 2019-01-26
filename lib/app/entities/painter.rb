class Painter
  def paint_answer(answer)
    mark = []
    Registration::DIGITS_COUNT.times do |index|
      next mark[index] = 'success' if answer[index] == '+'
      next mark[index] = 'primary' if answer[index] == '-'

      answer[index] = 'x'
      mark[index] = 'danger'
    end
    { answer: answer, mark: mark }
  end
end
