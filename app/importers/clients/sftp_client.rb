class SftpClient

  attr_reader :credentials

  def initialize(options = {})
    # Credentials take the form of a hash with the following keys:
    # user:, host:, (password: or key_data:)
    @credentials = options[:credentials]
  end

  def read_file(remote_file_name)
    sftp_session.download!(remote_file_name).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  end

  def download_file_to_tmp(remote_file_name)
    sftp_session.download!(remote_file_name, file_tmp_path(remote_file_name))
  end

  def file_tmp_path(remote_file_name)
    "#{Rails.root}/tmp/#{remote_file_name}"
  end

  def sftp_session
    if sftp_info_present?
      auth = {}
      auth[:password] = @credentials[:password] if @credentials[:password].present?
      auth[:key_data] = @credentials[:key_data] if @credentials[:key_data].present?
      Net::SFTP.start(@credentials[:host], @credentials[:user], auth)
    else
      raise "SFTP information missing"
    end
  end

  def sftp_info_present?
    @credentials[:user].present? &&
    @credentials[:host].present? &&
    (@credentials[:password].present? || @credentials[:key_data].present?)
  end
end
