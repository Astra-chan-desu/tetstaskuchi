module Api
  module V1
    class StudentsController < BaseController
      before_action :authenticate!, only: [:destroy]

      def create
        student = Student.new(student_params)
        if student.save
          token = generate_token(student.id)
          response.set_header('X-Auth-Token', token)
          render json: student_json(student), status: :created
        else
          render json: { errors: student.errors.full_messages }, status: :method_not_allowed
        end
      end

      def destroy
        student = Student.find_by(id: params[:user_id])
        if student
          student.destroy
          head :no_content
        else
          render json: { error: 'Некорректный id студента' }, status: :bad_request
        end
      end

      private

      def student_params
        permitted = params.require(:student).permit(:first_name, :last_name, :surname, :class_id, :school_id)
        permitted[:school_class_id] = permitted.delete(:class_id) if permitted.key?(:class_id)
        permitted
      end

      def generate_token(user_id)
        secret_salt = ENV.fetch('SECRET_SALT', 'default_salt_change_me')
        Digest::SHA256.hexdigest("#{user_id}#{secret_salt}")
      end

      def authenticate!
        auth_header = request.headers['Authorization']
        token = auth_header&.split(' ')&.last
        expected_token = generate_token(params[:user_id].to_i)

        unless token.present? && ActiveSupport::SecurityUtils.secure_compare(token, expected_token)
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

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