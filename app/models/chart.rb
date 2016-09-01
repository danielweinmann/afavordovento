class Chart < ApplicationRecord
  validates :name, presence: true
  validates :birth_date, presence: true
  belongs_to :user
  store_accessor :birth_chart 
  before_save :calculate_numbers

  def chart_number(number)
    numbers = []
    (self.birth_chart[number.to_s].to_i || 0).times do
      numbers << number.to_s
    end
    numbers.join("")
  end

  private

  def digits_sum(digits)
    return digits[0] if digits.size == 1
    return 10 if digits == [1, 0]
    return 11 if digits == [1, 1]
    return 22 if digits == [2, 2]
    digits.inject(0){ |sum, x| sum + x }
  end

  def calculate_number(number)
    return number if number <= 11 || number == 22
    digits = number.to_s.scan(/\d/).map(&:to_i)
    digits_sum(digits)
  end

  def calculate_chart(digits)
    chart = {}
    digits.each do |digit|
      next if digit == 0
      chart[digit] = (chart[digit] || 0) + 1
    end
    chart
  end

  def calculate_numbers
    return unless self.birth_date
    date_digits = self.birth_date.strftime("%d%m%Y").scan(/\d/).map(&:to_i)
    date_sum = digits_sum(date_digits)
    day_digits = date_digits[0..1]
    day_sum = digits_sum(day_digits)
    self.birth_chart = calculate_chart(date_digits)
    self.ruling_number = calculate_number(date_sum)
    self.day_number = calculate_number(day_sum)
  end
end
