require "time"
require "textbelt"

require "remind/helper"
require "remind/config"
require "remind/note"

class AlertException < Exception
end

class BaseAlert
  def send
    fail NotImplementedError, "BaseAlert.send requires implemention"
  end

  def call_service
    fail NotImplementedError, "BaseAlert.call_service requires implemention"
  end
end

class TextAlert
  def self.send(message)
    call_service(message)
  end

  def self.call_service(message)
    if !Config.email.nil?
      TextBelt.text(Config.email, message)
    end
  end
end

class AlertType
  TEXT = "text"
end

class RemindAlert

  def self.send_all
    message = ""
    RemindNotes.with_due_notes do |note|
      break if note.sent

      message << "#{note.title}\n"
      note.set_sent(true)
      note.save()
    end

    alert = make_alert()
    alert.send(message) if !message.empty?
  end

  private
  def self.make_alert
    alerts = {
      AlertType::TEXT => TextAlert
    }

    return alerts[Config.alert_type]
  end
end
