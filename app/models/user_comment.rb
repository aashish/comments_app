class UserComment < ApplicationRecord
  before_save :parse_description

  def self.valid_comments(ip)
    start_time = order("created_at asc").first.created_at
    last_time = order("created_at asc").last.created_at
    arr = []
    while start_time < last_time do
      arr << where("ip = ? AND created_at >= ? AND created_at < ?", ip, start_time, start_time + 5.minutes ).order("created_at asc").first
      start_time += 5.minutes
    end
    arr.compact!
  end

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
