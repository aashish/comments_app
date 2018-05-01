class UserComment < ApplicationRecord
  before_save :parse_description

  def self.valid_comments(ip)
    start_time = order("created_at asc").first.created_at
    last_time = order("created_at asc").last.created_at
    arr = []
    while start_time <= last_time do
      record = where("(ip = ? AND created_at >= ? AND created_at < ?) OR (ip = ? AND created_at > ?)", ip, start_time, start_time + 5.minutes, ip, start_time ).order("created_at asc").first
      if record && start_time < record.created_at
        arr << record
        start_time = record.created_at
      else
        start_time += 5.minutes
      end
    end
    arr.compact
  end

  private

  def parse_description
    description.gsub!(/[\<\/]+[a-z]+\>/) do |match|
      if ['<i>', '</i>', '<b>', '</b>'].include? match
        match
      else
        match = ''
      end
    end
  end
end
