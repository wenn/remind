require 'chronic'
require 'error'


class RemindTimer

  def initialize(time_phrase)
    @time_phrase = time_phrase
  end

  def parse
    ["on", "@|at"].each do |marker|
      time = to_time(marker)
      return time if not time.nil?
    end

    return nil
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
