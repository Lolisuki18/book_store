# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  
  path '/auth/login' do
    post 'Login to the system' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :auth_params, in: :body, schema: {
        type: :object,
        properties: {
          user_name: { type: :string, example: 'admin' },
          password: { type: :string, example: 'password123' }
        },
        required: %w[user_name password]
      }

      response '200', 'Login successful' do
        schema type: :object,
               properties: {
                 access_token: { type: :string },
                 refresh_token: { type: :string },
                 token_type: { type: :string, example: 'Bearer' },
                 expires_in: { type: :integer },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     user_name: { type: :string },
                     email: { type: :string },
                     role: { type: :string }
                   }
                 }
               },
               required: %w[access_token refresh_token token_type expires_in user]

        run_test!
      end

      response '401', 'Invalid credentials' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid credentials' }
               }
        run_test!
      end
    end
  end

  path '/auth/refresh' do
    post 'Refresh access token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :refresh_params, in: :body, schema: {
        type: :object,
        properties: {
          refresh_token: { type: :string }
        },
        required: %w[refresh_token]
      }

      response '200', 'Token refreshed successfully' do
        schema type: :object,
               properties: {
                 access_token: { type: :string },
                 refresh_token: { type: :string },
                 token_type: { type: :string, example: 'Bearer' },
                 expires_in: { type: :integer }
               }
        run_test!
      end

      response '401', 'Invalid refresh token' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid or expired refresh token' }
               }
        run_test!
      end
    end
  end

  path '/auth/logout' do
    post 'Logout from the system' do
      tags 'Authentication'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Logged out successfully' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Logged out successfully' }
               }
        run_test!
      end

      response '401', 'No active session' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'No active session' }
               }
        run_test!
      end
    end
  end

  path '/auth/me' do
    get 'Get current user information' do
      tags 'Authentication'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'User information retrieved' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 user_name: { type: :string },
                 email: { type: :string },
                 role: { type: :string }
               }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'User not found' }
               }
        run_test!
      end
    end
  end
end