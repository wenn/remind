require 'json'

class RemindNote

  def initialize(action:, time_phrase:, time_marker:, title:, body:, time:)
    @action = action
    @time_phrase = time_phrase
    @time_marker = time_marker
    @title = title
    @body = body
    @time = time
  end

  def to_hash
    return {
      "action" => @action,
      "time_phrase" => @time_phrase,
      "time_marker" => @time_marker,
      "title" => @title,
      "body" => @body,
      "time" => @time,
    }
  end

  def to_json
    data = to_hash()
    return JSON.pretty_generate(data)
  end

  def self.make(json)
  end
end
