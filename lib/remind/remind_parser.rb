require 'chronic'
require 'remind/remind_error'

module Marker

  class Base end

  class On < Base
    def self.val
      return "on"
    end
  end

  class At < Base
    def self.val
      return "@|at"
    end
  end

end

class RemindTimeParser

  def initialize(time_phrase)
    @time_phrase = time_phrase
  end

  def parse
    [Marker::On, Marker::At].each do |marker|
      time = to_time(marker.val)
      return [time, marker] if not time.nil?
    end

    return nil, nil
  end

  def to_time(timer_marker)

    time = nil
    if @time_phrase[/^(#{timer_marker})\s/]
      time = nil
      time_phrase_arr = @time_phrase.split
      phrase = time_phrase_arr[0..-1].join(' ')
      time = Chronic.parse(phrase)

      if time.nil?
        phrase = time_phrase_arr[1..-1].join(' ')
        time = Chronic.parse(phrase)
      end

    end

    return time
  end

end
