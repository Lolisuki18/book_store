# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Authors API', type: :request do
  
  path '/authors' do
    get 'List all authors' do
      tags 'Authors'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Authors retrieved successfully' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   first_name: { type: :string },
                   last_name: { type: :string },
                   stage_name: { type: :string },
                   biography: { type: :string },
                   birth_date: { type: :string, format: :date },
                   nationality: { type: :string },
                   active: { type: :boolean }
                 }
               }
        run_test!
      end
    end

    post 'Create a new author' do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          author: {
            type: :object,
            properties: {
              first_name: { type: :string, example: 'John' },
              last_name: { type: :string, example: 'Doe' },
              stage_name: { type: :string, example: 'J. Doe' },
              biography: { type: :string, example: 'A famous author who...' },
              birth_date: { type: :string, format: :date, example: '1980-01-01' },
              nationality: { type: :string, example: 'Vietnamese' },
              active: { type: :boolean, example: true }
            },
            required: %w[first_name last_name]
          }
        }
      }

      response '201', 'Author created successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 first_name: { type: :string },
                 last_name: { type: :string },
                 stage_name: { type: :string },
                 biography: { type: :string },
                 birth_date: { type: :string },
                 nationality: { type: :string },
                 active: { type: :boolean }
               }
        run_test!
      end

      response '422', 'Invalid parameters' do
        schema type: :array,
               items: { type: :string }
        run_test!
      end
    end
  end

  path '/authors/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get a specific author' do
      tags 'Authors'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Author found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 first_name: { type: :string },
                 last_name: { type: :string },
                 stage_name: { type: :string },
                 biography: { type: :string },
                 birth_date: { type: :string },
                 nationality: { type: :string },
                 active: { type: :boolean },
                 books: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       title: { type: :string },
                       isbn: { type: :string }
                     }
                   }
                 }
               }
        run_test!
      end

      response '404', 'Author not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Author not found' }
               }
        run_test!
      end
    end

    put 'Update an author' do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: {
          author: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              stage_name: { type: :string },
              biography: { type: :string },
              birth_date: { type: :string, format: :date },
              nationality: { type: :string },
              active: { type: :boolean }
            }
          }
        }
      }

      response '200', 'Author updated successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 first_name: { type: :string },
                 last_name: { type: :string },
                 stage_name: { type: :string },
                 biography: { type: :string },
                 birth_date: { type: :string },
                 nationality: { type: :string },
                 active: { type: :boolean }
               }
        run_test!
      end

      response '422', 'Invalid parameters' do
        schema type: :array,
               items: { type: :string }
        run_test!
      end

      response '404', 'Author not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Author not found' }
               }
        run_test!
      end
    end

    delete 'Soft delete an author' do
      tags 'Authors'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Author deleted successfully' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Author deleted successfully' }
               }
        run_test!
      end

      response '404', 'Author not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Author not found' }
               }
        run_test!
      end

      response '422', 'Unable to delete author' do
        schema type: :array,
               items: { type: :string }
        run_test!
      end
    end
  end
end