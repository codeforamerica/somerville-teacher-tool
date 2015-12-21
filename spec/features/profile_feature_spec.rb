require 'rails_helper'
require 'capybara/rspec'

describe 'educator views student profile', :type => :feature do
  context 'educator with account views student profile' do
    let(:educator) { FactoryGirl.create(:educator_with_homeroom) }
    let(:student_profile) do
      educator_sign_in(educator)
      visit student_path(student)
      page
    end

    around(:each) do |example|
      Timecop.freeze(DateTime.new(2015, 5, 1)) do
        example.run
      end
    end

    context 'student has no discipline incidents' do
      let(:student) { FactoryGirl.create(:student) }
      let(:school_year) { FactoryGirl.create(:school_year, start: Date.new(2014, 8, 1)) }
      let!(:student_school_year) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year) }
      it 'shows no discipline incidents' do
        expect(student_profile).to have_content 'No behavior incidents'
      end
    end
    context 'student has discipline incidents' do
      let!(:student) { FactoryGirl.create(:student_with_discipline_incident) }
      it 'shows the discipline incident' do
        expect(student_profile).not_to have_content 'No behavior incidents'
      end
    end
    context 'student has no attendance events' do
      let(:student) { FactoryGirl.create(:student) }
      let(:school_year) { FactoryGirl.create(:school_year, start: Date.new(2014, 8, 1)) }
      let!(:student_school_year) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year) }

      it 'shows no attendance events' do
        visit student_path(student)
        expect(student_profile).to have_content 'No absences or tardies'
      end
    end
    context 'student has absence' do
      let(:student) { FactoryGirl.create(:student) }
      let(:school_year) { FactoryGirl.create(:school_year, start: Date.new(2014, 8, 1)) }
      let!(:student_school_year) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year) }

      before { FactoryGirl.create(:attendance_event, absence: true, student_school_year: student_school_year) }
      it 'shows the absence' do
        visit student_path(student)
        expect(student_profile).not_to have_content 'No absences or tardies'
      end
    end
    context 'student has no MCAS results' do
      let(:student) { FactoryGirl.create(:student) }
      let(:school_year) { FactoryGirl.create(:school_year, start: Date.new(2014, 8, 1)) }
      let!(:student_school_year) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year) }

      it 'shows no MCAS results' do
        visit student_path(student)
        expect(student_profile).not_to have_css '.mcas-result-section'
      end
    end
    context 'student has MCAS results' do
      context 'English' do
        let!(:student) { FactoryGirl.create(:student_with_mcas_ela_assessment) }
        it 'shows MCAS results' do
          expect(student_profile).to have_css '.mcas-ela-values'
        end
      end
      context 'math' do
        let!(:student) { FactoryGirl.create(:student_with_mcas_math_assessment) }
        it 'shows MCAS results' do
          expect(student_profile).to have_css '.mcas-math-values'
        end
      end
    end
    context 'student has no STAR results' do
      let(:student) { FactoryGirl.create(:student) }
      let(:school_year) { FactoryGirl.create(:school_year, start: Date.new(2014, 8, 1)) }
      let!(:student_school_year) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year) }

      it 'shows no STAR results' do
        expect(student_profile).not_to have_css '.star-result-section'
      end
    end
    context 'student has a STAR result' do
      context 'reading' do
        let!(:student) { FactoryGirl.create(:student_ahead_in_reading) }
        it 'shows STAR result' do
          expect(student_profile).to have_css '.star-reading-values'
        end
        it 'shows the right reading level' do
          instructional_reading_level = student_profile.find('.instructional-reading-level')
          expect(instructional_reading_level).to have_content('6.0')
        end
      end
      context 'math' do
        let!(:student) { FactoryGirl.create(:student_with_star_math_assessment) }
        it 'shows STAR result' do
          expect(student_profile).to have_css '.star-math-values'
        end
      end
    end
    context 'student has DIBELS' do
      let!(:student) { FactoryGirl.create(:student_with_dibels) }
      it 'shows DIBELS' do
        expect(student_profile).to have_css '.dibels-values'
      end
    end
    context 'student has no DIBELS' do
      let(:student) { FactoryGirl.create(:student) }
      let(:school_year) { FactoryGirl.create(:school_year, start: Date.new(2014, 8, 1)) }
      let!(:student_school_year) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year) }

      it 'doesn\'t show DIBELS' do
        expect(student_profile).not_to have_css '.dibels-values'
      end
    end
    context 'student has ACCESS' do
      let!(:student) { FactoryGirl.create(:student_with_access) }
      it 'shows ACCESS' do
        expect(student_profile).to have_css '.access-values'
      end
    end
    context 'student has no ACCESS' do
      let(:student) { FactoryGirl.create(:student) }
      let(:school_year) { FactoryGirl.create(:school_year, start: Date.new(2014, 8, 1)) }
      let!(:student_school_year) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year) }

      it 'doesn\'t show ACCESS' do
        expect(student_profile).not_to have_css '.access-values'
      end
    end
  end
end
