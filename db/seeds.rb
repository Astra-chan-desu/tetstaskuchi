# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
unless School.exists?
  school = School.create!(name: "Школа №1")

  class_a = school.school_classes.create!(number: 1, letter: "А")
  class_b = school.school_classes.create!(number: 1, letter: "Б")

  school.students.create!(
    first_name: "Вячеслав",
    last_name: "Абдурахмангаджиевич",
    surname: "Мухобойников-Сыркин",
    school_class: class_a
  )

  school.students.create!(
    first_name: "Иван",
    last_name: "Иванов",
    surname: "Иванович",
    school_class: class_a
  )

  school.students.create!(
    first_name: "Петр",
    last_name: "Петров",
    surname: "Петрович",
    school_class: class_b
  )

  puts "Test data is put into DB"
else
  puts "School exists, no test data is put"
end
