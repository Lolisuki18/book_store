class ApplicationController < ActionController::API

  def render_success (message = "" , data = {}, status = :ok)
    render json: { success: true, message: message, data: data }, status: status
  end

  def render_error (message = "" , errors = [], status = :unprocessable_entity)
    render json: { success: false, message: message, errors: errors }, status: status
  end
  
end
