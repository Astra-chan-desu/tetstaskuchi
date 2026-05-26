require 'rails_helper'

RSpec.describe "Api::V1::Students", type: :request do
  let(:school) { School.create!(name: "Test School") }
  let(:school_class) { school.school_classes.create!(number: 1, letter: "А") }

  describe "POST /api/v1/students" do
    let(:valid_attributes) do
      {
        student: {
          first_name: "John",
          last_name: "Doe",
          surname: "Smith",
          class_id: school_class.id,
          school_id: school.id
        }
      }
    end

    it "creates a student and returns a token" do
      post api_v1_students_path, params: valid_attributes, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["first_name"]).to eq("John")
      expect(json["class_id"]).to eq(school_class.id)
      expect(response.headers["X-Auth-Token"]).to be_present
    end

    it "returns 405 when input is invalid" do
      post api_v1_students_path, params: { student: { first_name: "" } }, as: :json
      expect(response).to have_http_status(:method_not_allowed)
    end
  end

  describe "DELETE /api/v1/students/:user_id" do
    let(:student) do
      school.students.create!(
        first_name: "Ivan",
        last_name: "Ivanov",
        surname: "Ivanovich",
        school_class_id: school_class.id,
        school_id: school.id
      )
    end

    def auth_header(user_id)
      secret = ENV.fetch('SECRET_SALT', 'default_salt_change_me')
      token = Digest::SHA256.hexdigest("#{user_id}#{secret}")
      { "Authorization" => "Bearer #{token}" }
    end

    it "deletes the student with a valid token" do
      delete api_v1_student_path(student.id), headers: auth_header(student.id)
      expect(response).to have_http_status(:no_content)
      expect(Student.find_by(id: student.id)).to be_nil
    end

    it "returns 400 for a non-existent student" do
      delete api_v1_student_path(999), headers: auth_header(0)
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["error"]).to eq("Некорректный id студента")
    end

    it "returns 401 when no token is provided" do
      delete api_v1_student_path(student.id)
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 with an invalid token" do
      delete api_v1_student_path(student.id), headers: { "Authorization" => "Bearer badtoken" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
