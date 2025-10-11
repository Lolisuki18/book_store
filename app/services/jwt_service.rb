class JwtService
  
    def sign_access_token(user)
      JsonWebToken.encode({ user_id: user.id, role: user.role, type: "access" }, 1.hour.from_now)
    end

    def sign_refresh_token(user)
      JsonWebToken.encode({ user_id: user.id, role: user.role, type: "refresh" }, 7.days.from_now)
    end

    def generate_tokens(user)
      access_token = sign_access_token(user)
      refresh_token = sign_refresh_token(user)
      return nil unless access_token && refresh_token
      { access: access_token, refresh: refresh_token }
    end

    def refresh_token(token)
      return { success: false, message: 'Token is required' } if token.blank?

      decoded = JsonWebToken.decode(token)
      
      # Kiểm tra token có valid và đúng type không
      unless decoded && decoded[:type] == "refresh"
        return { success: false, message: 'Invalid refresh token' }
      end

      # Tìm user và kiểm tra active
      user = User.find_by(id: decoded[:user_id])
      unless user&.active?
        return { success: false, message: 'User not found or inactive' }
      end

      # Generate tokens mới
      tokens = generate_tokens(user)
      return { success: false, message: 'Failed to generate tokens' } unless tokens

      {
        success: true,
        access_token: tokens[:access],
        refresh_token: tokens[:refresh],
        message: 'Token refreshed successfully'
      }
    rescue StandardError => e
      Rails.logger.error "Refresh token error: #{e.message}"
      { success: false, message: 'Token refresh failed' }
  end
end