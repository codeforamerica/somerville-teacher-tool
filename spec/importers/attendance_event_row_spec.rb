require 'rails_helper'

RSpec.describe AttendanceEventRow do
  let(:row) do
    {
      local_id: 'student-id',
      event_date: DateTime.parse('1981-12-30'),
      absence: true,
      tardy: false,
    }
  end

  subject(:event_row) { AttendanceEventRow.new(row) }

  describe '#build' do
    it 'builds an attendence event for the absence and tardiness of the student' do
      expect(event_row.build.attributes).to include(
        'absence' => true,
        'tardy' => false,
      )
    end

    it 'creates the appropriate school year' do
      expect { event_row.build }.to change(SchoolYear, :count).by(1)
      expect(SchoolYear.last.name).to eq('1981-1982')
    end

    it 'creates the appropriate student record' do
      expect { event_row.build }.to change(Student, :count).by(1)
      expect(Student.last.local_id).to eq('student-id')
    end
  end
end
