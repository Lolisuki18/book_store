# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  
  path '/categories' do
    get 'List all categories' do
      tags 'Categories'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Categories retrieved successfully' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   category_name: { type: :string },
                   description: { type: :string },
                   active: { type: :boolean }
                 }
               }
        run_test!
      end
    end

    post 'Create a new category' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              category_name: { type: :string, example: 'Science Fiction' },
              description: { type: :string, example: 'Books about science and future technology' },
              active: { type: :boolean, example: true }
            },
            required: %w[category_name]
          }
        }
      }

      response '201', 'Category created successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 category_name: { type: :string },
                 description: { type: :string },
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

  path '/categories/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get a specific category' do
      tags 'Categories'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Category found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 category_name: { type: :string },
                 description: { type: :string },
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

      response '404', 'Category not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Category not found' }
               }
        run_test!
      end
    end

    put 'Update a category' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          category: {
            type: :object,
            properties: {
              category_name: { type: :string },
              description: { type: :string },
              active: { type: :boolean }
            }
          }
        }
      }

      response '200', 'Category updated successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 category_name: { type: :string },
                 description: { type: :string },
                 active: { type: :boolean }
               }
        run_test!
      end

      response '422', 'Invalid parameters' do
        schema type: :array,
               items: { type: :string }
        run_test!
      end

      response '404', 'Category not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Category not found' }
               }
        run_test!
      end
    end

    delete 'Soft delete a category' do
      tags 'Categories'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Category deleted successfully' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Category deleted successfully' }
               }
        run_test!
      end

      response '404', 'Category not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Category not found' }
               }
        run_test!
      end

      response '422', 'Unable to delete category' do
        schema type: :array,
               items: { type: :string }
        run_test!
      end
    end
  end
end