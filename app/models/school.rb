class School < ApplicationRecord
  has_many :school_classes, dependent: :destroy
  has_many :students, dependent: :destroy
end
