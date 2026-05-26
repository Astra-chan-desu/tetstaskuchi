module Api
  module V1
    class ClassesController < BaseController
      # GET /api/v1/schools/:school_id/classes
      def index
        school = School.find(params[:school_id])
        classes = school.school_classes
        render json: { data: classes.map { |c| class_json(c) } }
      end

      private

      def class_json(klass)
        {
          id: klass.id,
          number: klass.number,
          letter: klass.letter,
          students_count: klass.students_count
        }
      end
    end
  end
end