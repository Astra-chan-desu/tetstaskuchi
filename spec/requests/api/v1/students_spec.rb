require 'rails_helper'

RSpec.describe "Api::V1::Students", type: :request do
  let(:school) { School.create!(name: "Тестовая школа") }
  let(:school_class) { school.school_classes.create!(number: 1, letter: "А") }

  describe "POST /api/v1/students" do
    let(:valid_attributes) do
      {
        student: {
          first_name: "Вячеслав",
          last_name: "Абдурахмангаджиевич",
          surname: "Мухобойников-Сыркин",
          class_id: school_class.id,
          school_id: school.id
        }
      }
    end

    it "student is created, token is returned" do
      post api_v1_students_path, params: valid_attributes, as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["first_name"]).to eq("Вячеслав")
      expect(json["class_id"]).to eq(school_class.id)
      expect(response.headers["X-Auth-Token"]).to be_present
    end

    it "throws err at bad input" do
      post api_v1_students_path, params: { student: { first_name: "" } }, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /api/v1/students/:user_id" do
    let(:student) do
      school.students.create!(
        first_name: "Иван",
        last_name: "Иванов",
        surname: "Иванович",
        school_class_id: school_class.id,
        school_id: school.id
      )
    end

    def auth_header(user_id)
      secret = ENV.fetch('SECRET_SALT', 'default_salt_change_me')
      token = Digest::SHA256.hexdigest("#{user_id}#{secret}")
      { "Authorization" => "Bearer #{token}" }
    end

    it "deletes student with token" do
      delete api_v1_student_path(student.id), headers: auth_header(student.id)

      expect(response).to have_http_status(:no_content)
      expect(Student.find_by(id: student.id)).to be_nil
    end

    it "401 for no token" do
      delete api_v1_student_path(student.id)
      expect(response).to have_http_status(:unauthorized)
    end

    it "401 for bad token" do
      delete api_v1_student_path(student.id), headers: { "Authorization" => "Bearer badtoken" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end