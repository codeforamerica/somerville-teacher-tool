class AttendanceImporter
  include Connector
  include Importer

  def remote_file_name
    'attendance_export.txt'
  end

  def import_row(row)
    AttendanceEventRow.new(row).build.save!
  end
end
