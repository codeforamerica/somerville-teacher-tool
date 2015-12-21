require 'rails_helper'
require 'capybara/rspec'

describe 'export profile', :type => :feature do
  context 'educator with account' do
    let!(:school_year_2014) { FactoryGirl.create(:school_year, start: Date.new(2014, 8, 1)) }
    let!(:school_year_2013) { FactoryGirl.create(:school_year, start: Date.new(2013, 8, 1)) }
    let!(:educator) { FactoryGirl.create(:educator_with_homeroom) }
    let!(:student) {
      Timecop.freeze(DateTime.new(2015, 5, 1)) do
        FactoryGirl.create(:student)
      end
    }
    let!(:student_school_year_2014) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year_2014) }
    let!(:student_school_year_2013) { FactoryGirl.create(:student_school_year, student: student, school_year: school_year_2013) }

    def educator_sign_in(educator)
      visit root_url
      click_link 'Sign In'
      fill_in 'educator_email', with: educator.email
      fill_in 'educator_password', with: educator.password
      click_button 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end

    before(:each) do
      FactoryGirl.create(:attendance_event, absence: true, student_school_year: student_school_year_2014)
      Timecop.freeze(DateTime.new(2015, 5, 1)) do
        educator_sign_in(educator)
        visit "/students/#{student.id}"
        click_on 'Export'
      end
    end

    context 'csv' do
      it 'sends a csv' do
        content_type = page.response_headers['Content-Type']
        expect(content_type).to eq 'text/csv'
      end
      it 'sets the right values' do
        csv = CSV.parse(page.body)
        expect(csv[0]).to eq ["Demographics"]
        expect(csv[9]).to eq ["School Year", "Number of Absences"]
        expect(csv[10]).to eq ["2014-2015", "1"]
        expect(csv[11]).to eq ["2013-2014", "0"]
        expect(csv[12]).to eq []
      end
    end
  end
  context 'someone without account' do
    let!(:student) { FactoryGirl.create(:student_who_registered_in_2013_2014) }
    it 'does not work' do
      visit "/students/#{student.id}.csv"
      expect(page).to have_content 'You need to sign in before continuing.'
    end
  end
end
