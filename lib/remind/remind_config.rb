module Config
  def self.data_folder
    return File.join(self.user_remind_folder, 'data')
  end

  def self.scheduler_folder
    return File.join(self.user_remind_folder, 'scheduler')
  end

  def self.user_remind_folder
    return File.join(Dir.home, '.remind')
  end

  def self.file_name_size
    return 10
  end

  def self.alert_polling_in_minutes
    return 60
  end

  def self.alert_type
    return "text"
  end

  def self.email
    return "3145465655@txt.att.net"
  end
end
