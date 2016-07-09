USER_REMIND_FOLDER = File.join(Dir.home, '.remind')
DATA_FOLDER = File.join(USER_REMIND_FOLDER, 'data')
FILE_NAME_SIZE = 10
ALERT_POLLING_IN_MINUTES = 60

module Config
  def self.data_folder
    return DATA_FOLDER
  end

  def self.user_remind_folder
    return USER_REMIND_FOLDER
  end

  def self.file_name_size
    return FILE_NAME_SIZE
  end

  def self.alert_polling_in_minutes
    return ALERT_POLLING_IN_MINUTES
  end
end
