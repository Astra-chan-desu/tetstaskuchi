class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class, optional: true

  validates :first_name, :last_name, :surname, :school_id, :school_class_id, presence: true
end