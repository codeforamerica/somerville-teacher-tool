class AttendanceImporter

  def remote_file_name
    # Expects a CSV with the following headers, transformed to symbols by CsvTransformer during import:
    #
    # [ "state_id", "local_id", "absence", "tardy", "event_date", "school_local_id" ]

    'attendance_export.txt'
  end

  def data_transformer
    CsvTransformer.new
  end

  def import_row(row)
    AttendanceRow.build(row).save!
  end
end
