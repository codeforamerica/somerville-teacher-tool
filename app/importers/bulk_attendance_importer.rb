class BulkAttendanceImporter
  include Connector

  def import(data)
    attendance_events = data.map do |row|
      AttendanceEventRow.new(row).build
    end
    AttendanceEvent.import(attendance_events)
  end
  alias_method :import_locally, :import
end
