class Chart < ApplicationRecord
  validates :name, presence: true
  validates :birth_date, presence: true
  belongs_to :user
  store_accessor :birth_chart 
  before_save :calculate_numbers

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def birth_chart_text
    numbers = { "0" => "zero", "1" => "one", "2" => "two", "3" => "three", "4" => "four", "5" => "five", "6" => "six", "7" => "seven", "8" => "eight", "9" => "nine" }
    expressions = []
    self.birth_chart.sort_by{ |key, value| "#{("%02d" % (10 - value.to_i))}#{("%02d" % (key.to_i))}" }.to_h.each do |number, total|
      if number == "1" && total == "3" && self.arrow_of_hypersensitivity?
        expressions << I18n.t("birth_chart.one.3_with_hypersensitivity.short", default: I18n.t("birth_chart.one.3_with_hypersensitivity.short_#{self.is_female? ? 'female' : 'male'}"))
      else
        expressions << I18n.t("birth_chart.#{numbers[number]}.#{total}.short", default: I18n.t("birth_chart.#{numbers[number]}.#{total}.short_#{self.is_female? ? 'female' : 'male'}"))
      end
    end
    first_expressions = expressions[0..expressions.size - 2]
    last_expression = expressions[expressions.size - 1]
    numbers_text = "Desde #{self.is_female? ? 'pequena' : 'pequeno'} você foi #{first_expressions.join(", ")} e #{last_expression}."
    arrows_expressions = []
    self.arrows.each_with_index do |arrow, index|
      arrows_expressions << I18n.t("arrows.#{arrow}.short", default: I18n.t("arrows.#{arrow}.short_#{self.is_female? ? 'female' : 'male'}"))
    end
    numbers_text
  end

  def mind_plane_total
    @mind_plane_total ||= number_total(3) + number_total(6) + number_total(9)
  end

  def soul_plane_total
    @soul_plane_total ||= number_total(2) + number_total(5) + number_total(8)
  end

  def physical_plane_total
    @physical_plane_total ||= number_total(1) + number_total(4) + number_total(7)
  end

  def mind_plane_distribution
    @mind_plane_distribution ||= has_number?(3) + has_number?(6) + has_number?(9)
  end

  def soul_plane_distribution
    @soul_plane_distribution ||= has_number?(2) + has_number?(5) + has_number?(8)
  end

  def physical_plane_distribution
    @physical_plane_distribution ||= has_number?(1) + has_number?(4) + has_number?(7)
  end

  def best_level_of_communication
    return @best_level_of_communication if @best_level_of_communication
    maximum = 0
    maximum = self.mind_plane_total if self.mind_plane_total > maximum
    maximum = self.soul_plane_total if self.soul_plane_total > maximum
    maximum = self.physical_plane_total if self.physical_plane_total > maximum
    expressions = []
    expressions << "mind" if self.mind_plane_total == maximum
    expressions << "soul" if self.soul_plane_total == maximum
    expressions << "physical" if self.physical_plane_total == maximum
    @best_level_of_communication = expressions.join("_and_")
  end

  def most_balanced_plane
    return @most_balanced_plane if @most_balanced_plane
    maximum = 0
    maximum = self.mind_plane_distribution if self.mind_plane_distribution > maximum
    maximum = self.soul_plane_distribution if self.soul_plane_distribution > maximum
    maximum = self.physical_plane_distribution if self.physical_plane_distribution > maximum
    expressions = []
    expressions << "mind" if self.mind_plane_distribution == maximum
    expressions << "soul" if self.soul_plane_distribution == maximum
    expressions << "physical" if self.physical_plane_distribution == maximum
    @most_balanced_plane = expressions.join("_and_")
  end

  def ones
    number_total(1)
  end

  def twos
    number_total(2)
  end

  def threes
    number_total(3)
  end

  def fours
    number_total(4)
  end

  def fives
    number_total(5)
  end

  def sixes
    number_total(6)
  end

  def sevens
    number_total(7)
  end

  def eights
    number_total(8)
  end

  def nines
    number_total(9)
  end

  def zeros
    number_total(0)
  end

  def personal_year_number
    digits = "#{self.birth_date.strftime("%d%m")}#{Time.now.strftime("%Y")}".scan(/\d/).map(&:to_i)
    calculate_number(digits_sum(digits), single_digit: true)
  end

  def world_year_number
    digits = Time.now.strftime("%Y").scan(/\d/).map(&:to_i)
    calculate_number(digits_sum(digits), single_digit: true)
  end

  def arrows
    return @arrows if @arrows
    possible_arrows = ["arrow_of_determination", "arrow_of_procrastination", "arrow_of_spirituality", "arrow_of_the_enquirer", "arrow_of_the_intellect", "arrow_of_poor_memory", "arrow_of_emotional_balance", "arrow_of_hypersensitivity", "arrow_of_practicality", "arrow_of_disorder", "arrow_of_the_planner", "arrow_of_the_will", "arrow_of_frustration", "arrow_of_activity", "arrow_of_passivity"]
    @arrows = []
    possible_arrows.each do |arrow|
      @arrows << arrow if self.send("#{arrow}?")
    end
    @arrows
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
    sum = digits.inject(0){ |sum, x| sum + x }
    if options[:single_digit]
      if sum > 9
        digits_sum(sum.to_s.scan(/\d/).map(&:to_i), options)
      else
        sum
      end
    else
      return 10 if digits == [1, 0]
      return 11 if digits == [1, 1]
      return 22 if digits == [2, 2]
      sum
    end
  end

  def calculate_number(number, options = {})
    if !options[:single_digit]
      return number if number <= 11 || number == 22
    end
    digits = number.to_s.scan(/\d/).map(&:to_i)
    digits_sum(digits, options.merge(aki: true))
  end

  def has_number?(number)
    (self.birth_chart[number.to_s] ? 1 : 0)
  end

  def number_total(number)
    self.birth_chart[number.to_s].to_i
  end

  def calculate_chart(digits)
    chart = {}
    digits.each_with_index do |digit, index|
      next if digit == 0 && [0, 2].include?(index)
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
