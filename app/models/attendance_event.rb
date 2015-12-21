class AttendanceEvent < ActiveRecord::Base
  belongs_to :student_school_year

  has_one :student, through: :student_school_year
  has_one :school_year, through: :student_school_year

  validates_presence_of :event_date

  def self.absences
    where(absence: true)
  end

  def self.tardies
    where(tardy: true)
  end

  def self.absences_count
    absences.count
  end

  def self.tardies_count
    tardies.count
  end
end
