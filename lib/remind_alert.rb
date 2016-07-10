require "time"
require "textbelt"

require "remind_helper"
require "remind_config"
require "remind_note"

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
    TextBelt.text(Config.email, message)
  end
end

class AlertType
  TEXT = "text"
end

class RemindAlert

  def self.main
    message = ""
    RemindNotes.with_due_notes do |note|
      message << "#{note.title}\n"
    end

    alert = make_alert()
    alert.send(message) if !message.empty?
  end

  private
  def self.make_alert
    alerts = {
      AlertType::TEXT => TextAlert
    }

    return alerts.fetch(Config.alert_type)
  end
end
