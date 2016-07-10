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
  def self.send(note)
    call_service(note)
  end

  def self.call_service(note)
    TextBelt.text(Config.email, note.title)
  end
end

class AlertType
  TEXT = "text"
end

class RemindAlert

  def self.main
    alert = make_alert()
    RemindNotes.with_due_notes do |note|
      alert.send(note)
    end
  end

  private
  def self.make_alert
    alerts = {
      AlertType::TEXT => TextAlert
    }

    return alerts.fetch(Config.alert_type)
  end
end
