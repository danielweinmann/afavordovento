class Chart < ApplicationRecord
  validates :name, presence: true
  validates :birth_date, presence: true
  belongs_to :user
  store_accessor :birth_chart 
  before_save :calculate_numbers

  def personal_year_number
    digits = "#{self.birth_date.strftime("%d%m")}#{Time.now.strftime("%Y")}".scan(/\d/).map(&:to_i)
    calculate_number(digits_sum(digits), single_digit: true)
  end

  def world_year_number
    digits = Time.now.strftime("%Y").scan(/\d/).map(&:to_i)
    calculate_number(digits_sum(digits), single_digit: true)
  end

  def arrow_of_determination?
    has_arrow_of_strength?(1, 5, 9)
  end

  def arrow_of_procrastination?
    has_arrow_of_weakness?(1, 5, 9)
  end

  def arrow_of_spirituality?
    has_arrow_of_strength?(3, 5, 7)
  end

  def arrow_of_the_enquirer?
    has_arrow_of_weakness?(3, 5, 7)
  end

  def arrow_of_the_intellect?
    has_arrow_of_strength?(3, 6, 9)
  end

  def arrow_of_poor_memory?
    has_arrow_of_weakness?(3, 6, 9)
  end

  def arrow_of_emotional_balance?
    has_arrow_of_strength?(2, 5, 8)
  end

  def arrow_of_hypersensitivity?
    has_arrow_of_weakness?(2, 5, 8)
  end

  def arrow_of_practicality?
    has_arrow_of_strength?(1, 4, 7)
  end

  def arrow_of_disorder?
    has_arrow_of_weakness?(1, 4, 7)
  end

  def arrow_of_the_planner?
    has_arrow_of_strength?(1, 2, 3)
  end

  def arrow_of_the_will?
    has_arrow_of_strength?(4, 5, 6)
  end

  def arrow_of_frustration?
    has_arrow_of_weakness?(4, 5, 6)
  end

  def arrow_of_activity?
    has_arrow_of_strength?(7, 8, 9)
  end

  def arrow_of_passivity?
    has_arrow_of_weakness?(7, 8, 9)
  end

  def chart_number(number)
    numbers = []
    (self.birth_chart[number.to_s].to_i || 0).times do
      numbers << number.to_s
    end
    numbers.join("")
  end

  private

  def has_arrow_of_strength?(first, second, third)
    self.birth_chart && 
    self.birth_chart[first.to_s].to_i > 0 && 
    self.birth_chart[second.to_s].to_i > 0 && 
    self.birth_chart[third.to_s].to_i > 0
  end

  def has_arrow_of_weakness?(first, second, third)
    self.birth_chart && 
    self.birth_chart[first.to_s].to_i == 0 && 
    self.birth_chart[second.to_s].to_i == 0 && 
    self.birth_chart[third.to_s].to_i == 0
  end

  def digits_sum(digits, options = {})
    return digits[0] if digits.size == 1
    if !options[:single_digit]
      return 10 if digits == [1, 0]
      return 11 if digits == [1, 1]
      return 22 if digits == [2, 2]
    end
    digits.inject(0){ |sum, x| sum + x }
  end

  def calculate_number(number, options = {})
    if !options[:single_digit]
      return number if number <= 11 || number == 22
    end
    digits = number.to_s.scan(/\d/).map(&:to_i)
    digits_sum(digits, options)
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
