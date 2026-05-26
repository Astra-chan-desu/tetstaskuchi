require 'rails_helper'

RSpec.describe "Api::V1::Classes", type: :request do
  let(:school) { School.create!(name: "Школа") }
  let!(:class_a) { school.school_classes.create!(number: 1, letter: "А") }
  let!(:class_b) { school.school_classes.create!(number: 1, letter: "Б") }
  let!(:student) do
    school.students.create!(
      first_name: "Петр",
      last_name: "Петров",
      surname: "Петрович",
      school_class_id: class_a.id,
      school_id: school.id
    )
  end

  describe "GET /api/v1/schools/:school_id/classes" do
    it "returns classes with number of students" do
      get api_v1_school_classes_path(school)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(2)
      class_json = json["data"].find { |c| c["id"] == class_a.id }
      expect(class_json["students_count"]).to eq(1)
    end
  end

  describe "GET /api/v1/schools/:school_id/classes/:class_id/students" do
    it "returns student list" do
      get api_v1_school_class_students_path(school, class_a)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["data"].size).to eq(1)
      student_json = json["data"].first
      expect(student_json["first_name"]).to eq("Петр")
      expect(student_json["class_id"]).to eq(class_a.id)
    end
  end
end