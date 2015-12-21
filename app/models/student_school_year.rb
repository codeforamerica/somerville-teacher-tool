class StudentSchoolYear < ActiveRecord::Base
  belongs_to :student
  belongs_to :school_year

  has_many :attendance_events, dependent: :destroy
  has_many :student_assessments, dependent: :destroy
  has_many :discipline_incidents, dependent: :destroy
  has_many :interventions, dependent: :destroy

  validates_presence_of :student, :school_year

  delegate :name, to: :school_year

  def self.order_by_start
    joins(:school_year).order(SchoolYear.arel_table[:start].desc)
  end

  def mcas_math_result
    student_assessments.order_by_date_taken_asc
                       .by_family_and_subject("MCAS", "Math")
                       .last
  end

  def mcas_ela_result
    student_assessments.order_by_date_taken_asc
                       .by_family_and_subject("MCAS", "ELA")
                       .last
  end

  def star
    student_assessments.by_family("STAR")
                       .group_by { |result| result.date_taken }
  end

  def dibels
    student_assessments.by_family("DIBELS")
                       .order_by_date_taken_desc
  end

  def access
    student_assessments.order_by_date_taken_asc
                       .by_family("ACCESS")
                       .last
  end

  def absences
    attendance_events.absences_count
  end

  def tardies
    attendance_events.tardies_count
  end

end
