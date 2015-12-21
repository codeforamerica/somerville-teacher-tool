require 'rails_helper'

RSpec.describe StudentSchoolYear do
  let(:student) { FactoryGirl.create(:student) }
  let(:school_year) { FactoryGirl.create(:school_year) }

  it { is_expected.to belong_to(:student) }
  it { is_expected.to belong_to(:school_year) }

  it { is_expected.to have_many(:attendance_events).dependent(:destroy) }
  it { is_expected.to have_many(:interventions).dependent(:destroy) }
  it { is_expected.to have_many(:student_assessments).dependent(:destroy) }
  it { is_expected.to have_many(:discipline_incidents).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:student) }
  it { is_expected.to validate_presence_of(:school_year) }

  describe '.order_by_start' do
    context 'when we have no school years' do
      it 'returns an empty relation' do
        expect(StudentSchoolYear.order_by_start).to eq []
      end
    end
    context 'when we have one school year' do
      it 'returns the student school year' do
        student_school_year = StudentSchoolYear.create!(student: student, school_year: school_year)
        expect(StudentSchoolYear.order_by_start).to eq [student_school_year]
      end
    end
    context 'when we have two school years' do
      let(:earlier_school_year) { FactoryGirl.create(:school_year, start: DateTime.parse('1900-1-1')) }

      it 'returns them in the correct order' do
        student_school_year = StudentSchoolYear.create!(student: student, school_year: school_year)
        earlier_student_school_year = StudentSchoolYear.create!(student: student, school_year: earlier_school_year)
        expect(StudentSchoolYear.order_by_start).to eq([
          student_school_year, earlier_student_school_year
        ])
      end
    end
  end
end
