class Processor
  MATCHED_DIGIT_CHAR = '+'.freeze
  UNMATCHED_DIGIT_CHAR = '-'.freeze

  attr_reader :guess, :code

  def guess_test(code, guess)
    @code = code.split('')
    @guess = guess.split('')
    (handle_matched_digits + handle_matched_digits_with_wrong_position).join
  end

  private

  def handle_matched_digits
    code.map.with_index do |_, index|
      next unless code[index] == guess[index]

      @guess[index] = nil
      @code[index] = nil
      MATCHED_DIGIT_CHAR
    end
  end

  def handle_matched_digits_with_wrong_position
    guess.compact.map do |number|
      next unless @code.include?(number)

      @code.delete_at(code.index(number))
      UNMATCHED_DIGIT_CHAR
    end
  end
end
