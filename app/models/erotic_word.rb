class EroticWord < ActiveRecord::Base

  before_validation do
    self.word = word.gsub(/(\r\n|\r|\n|\f)/,"").strip if word.present?
  end

  before_create do
    self.first_word = first_word.downcase if first_word =~ /^[A-Z]$/
  end

  before_save :check_word_exist

  def self.all_word
    self.pluck(:word)
  end

  private
  def check_word_exist
    if self.class.all_word.include?(word)
      false
    else
      true
    end
  end
end
