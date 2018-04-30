class UserComment < ApplicationRecord

  before_save :parse_description


  private

  def parse_description
    description.gsub!(/[\<\/]+[a-z]+\>/) do |match|
      if ['<em>', '</em>', '<strong>', '</strong>'].include? match
        match
      else
        match = ''
      end
    end
  end
end
