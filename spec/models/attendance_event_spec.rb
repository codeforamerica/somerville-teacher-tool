require 'rails_helper'

RSpec.describe AttendanceEvent do
  it { is_expected.to belong_to(:student_school_year) }
  it { is_expected.to have_one(:school_year).through(:student_school_year) }
  it { is_expected.to have_one(:student).through(:student_school_year) }
  it { is_expected.to validate_presence_of(:event_date) }

  describe '.absences' do
    let!(:attendance_event) { FactoryGirl.create(:attendance_event, absence: absence) }

    context 'when the attendance event is an absence' do
      let(:absence) { true }
      it 'returns the attendance event' do
        expect(AttendanceEvent.absences).to include(attendance_event)
      end
    end

    context 'when the attendance event is not an absence' do
      let(:absence) { false }
      it 'does not return the attendance event' do
        expect(AttendanceEvent.absences).not_to include(attendance_event)
      end
    end
  end

  describe '.tardies' do
    let!(:attendance_event) { FactoryGirl.create(:attendance_event, tardy: tardy) }

    context 'when the attendance event is a tardy' do
      let(:tardy) { true }
      it 'does return the event' do
        expect(AttendanceEvent.tardies).to include(attendance_event)
      end
    end

    context 'when the attendance event is not a tardy' do
      let(:tardy) { false }
      it 'does not return the event' do
        expect(AttendanceEvent.tardies).not_to include(attendance_event)
      end
    end
  end
end
