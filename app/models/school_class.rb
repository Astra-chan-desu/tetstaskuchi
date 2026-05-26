class SchoolClass < ApplicationRecord
  belongs_to :school
  has_many :students, foreign_key: :school_class_id, dependent: :destroy

  def students_count
    students.count
  end
end
