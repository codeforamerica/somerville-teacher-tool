class AttendanceEventRow < Struct.new(:row)
  def build
    attendance_event = student_school_year.attendance_events.first_or_initialize(event_date: row[:event_date])
    attendance_event.assign_attributes(absence: row[:absence], tardy: row[:tardy])
    attendance_event
  end

  private

  def student
    Student.find_or_create_by(local_id: row[:local_id])
  end

  def school_year
    DateToSchoolYear.new(row[:event_date]).convert
  end

  def student_school_year
    student.student_school_years.find_or_create_by(school_year: school_year)
  end
end
