require 'rails_helper'

RSpec.describe StudentRecentAttendanceEvents do
  let(:student) { FactoryGirl.create(:student) }
  let(:school_year_2012) { FactoryGirl.create(:school_year, start: Date.new(2012, 8, 1)) }
  let(:school_year_2013) { FactoryGirl.create(:school_year, start: Date.new(2013, 8, 1)) }
  let!(:student_school_year_2012) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year_2012) }
  let!(:student_school_year_2013) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year_2013) }

  let(:recent_attendance_events) { StudentRecentAttendanceEvents.new(student) }

  before do
    FactoryGirl.create(:attendance_event, absence: true, student_school_year: student_school_year_2013)
  end

  describe '#absences_count' do
    it 'returns the correct number of absences' do
      expect(recent_attendance_events.absences_count).to eq 1
    end
  end

  describe '#tardies_count' do
    it 'returns the correct number of tardies' do
      expect(recent_attendance_events.tardies_count).to eq 0
    end
  end

  describe '#update_absences_count' do
    it 'updates the student model correctly' do
      recent_attendance_events.update_absences_count
      expect(student.reload.absences_count_most_recent_school_year).to eq 1
    end
  end

  describe '#update_tardies_count' do
    it 'updates the student model correctly' do
      recent_attendance_events.update_tardies_count
      expect(student.reload.tardies_count_most_recent_school_year).to eq 0
    end
  end
end
