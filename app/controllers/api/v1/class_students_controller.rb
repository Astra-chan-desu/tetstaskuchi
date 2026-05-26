module Api
  module V1
    class ClassStudentsController < BaseController
      # GET /api/v1/schools/:school_id/classes/:class_id/students
      def index
        school = School.find(params[:school_id])
        school_class = school.school_classes.find(params[:class_id])
        students = school_class.students
        render json: { data: students.map { |s| student_json(s) } }
      end

      private

      def student_json(student)
        {
          id: student.id,
          first_name: student.first_name,
          last_name: student.last_name,
          surname: student.surname,
          class_id: student.school_class_id,
          school_id: student.school_id
        }
      end
    end
  end
end
