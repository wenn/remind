require 'chronic'
require 'error'

class RemindTimer

  def initialize(time_phrase)
    @time_phrase = time_phrase
  end

  def as_on
    return to_time("on")
  end

  def as_at
    return to_time("@|at")
  end

  def to_time(timer_marker)
    
    if not @time_phrase[/^(#{timer_marker})\s/]
      fail ::RemindException, ::REMIND_USAGE
    end

    time = nil
    time_phrase_arr = @time_phrase.split
    phrase = time_phrase_arr[0..-1].join(' ')
    time = Chronic.parse(phrase)

    if time.nil?
      phrase = time_phrase_arr[1..-1].join(' ')
      time = Chronic.parse(phrase)
    end

    return time
  end

end
