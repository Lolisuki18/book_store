# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Books API', type: :request do
  
  path '/books' do
    get 'List all books' do
      tags 'Books'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Books retrieved successfully' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   title: { type: :string },
                   isbn: { type: :string },
                   publication_date: { type: :string, format: :date },
                   price: { type: :number, format: :decimal },
                   stock_quantity: { type: :integer },
                   description: { type: :string },
                   page_count: { type: :integer },
                   language: { type: :string },
                   cover_image_url: { type: :string },
                   active: { type: :boolean },
                   publisher: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   },
                   authors: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         name: { type: :string },
                         stage_name: { type: :string }
                       }
                     }
                   },
                   categories: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         name: { type: :string }
                       }
                     }
                   }
                 }
               }
        run_test!
      end
    end

    post 'Create a new book' do
      tags 'Books'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          book: {
            type: :object,
            properties: {
              title: { type: :string, example: 'Sample Book Title' },
              isbn: { type: :string, example: '978-0123456789' },
              publication_date: { type: :string, format: :date, example: '2024-01-01' },
              price: { type: :number, format: :decimal, example: 29.99 },
              stock_quantity: { type: :integer, example: 100 },
              description: { type: :string, example: 'A great book about...' },
              page_count: { type: :integer, example: 300 },
              language: { type: :string, example: 'Vietnamese' },
              cover_image_url: { type: :string, example: 'http://example.com/cover.jpg' },
              active: { type: :boolean, example: true },
              publisher_id: { type: :integer, example: 1 }
            },
            required: %w[title isbn publisher_id]
          }
        }
      }

      response '201', 'Book created successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 isbn: { type: :string },
                 publication_date: { type: :string },
                 price: { type: :number },
                 stock_quantity: { type: :integer },
                 description: { type: :string },
                 page_count: { type: :integer },
                 language: { type: :string },
                 cover_image_url: { type: :string },
                 active: { type: :boolean },
                 publisher_id: { type: :integer }
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

  path '/books/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Get a specific book' do
      tags 'Books'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Book found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 isbn: { type: :string },
                 publication_date: { type: :string },
                 price: { type: :number },
                 stock_quantity: { type: :integer },
                 description: { type: :string },
                 page_count: { type: :integer },
                 language: { type: :string },
                 cover_image_url: { type: :string },
                 active: { type: :boolean },
                 publisher: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string }
                   }
                 },
                 authors: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   }
                 },
                 categories: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string }
                     }
                   }
                 }
               }
        run_test!
      end

      response '404', 'Book not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Book not found' }
               }
        run_test!
      end
    end

    put 'Update a book' do
      tags 'Books'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: {}]
      
      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          book: {
            type: :object,
            properties: {
              title: { type: :string },
              isbn: { type: :string },
              publication_date: { type: :string, format: :date },
              price: { type: :number, format: :decimal },
              stock_quantity: { type: :integer },
              description: { type: :string },
              page_count: { type: :integer },
              language: { type: :string },
              cover_image_url: { type: :string },
              active: { type: :boolean },
              publisher_id: { type: :integer }
            }
          }
        }
      }

      response '200', 'Book updated successfully' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 title: { type: :string },
                 isbn: { type: :string }
               }
        run_test!
      end

      response '422', 'Invalid parameters' do
        schema type: :array,
               items: { type: :string }
        run_test!
      end

      response '404', 'Book not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Book not found' }
               }
        run_test!
      end
    end

    delete 'Soft delete a book' do
      tags 'Books'
      produces 'application/json'
      security [Bearer: {}]

      response '200', 'Book deleted successfully' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Book delete successfully' }
               }
        run_test!
      end

      response '404', 'Book not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Book not found' }
               }
        run_test!
      end

      response '422', 'Unable to delete book' do
        schema type: :array,
               items: { type: :string }
        run_test!
      end
    end
  end
end