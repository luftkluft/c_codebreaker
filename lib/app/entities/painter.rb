class Painter
  def paint_answer(answer)
    mark = []
    sign = []
    Registration::DIGITS_COUNT.times do |index|
      mark[index] = 'success' if answer[index] == '+'
      next sign[index] = '+' if answer[index] == '+'

      mark[index] = 'primary' if answer[index] == '-'
      next sign[index] = '-' if answer[index] == '-'

      sign[index] = 'x'
      mark[index] = 'danger'
    end
    { answer: sign, mark: mark }
  end
end
