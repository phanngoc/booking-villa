module Types
  class FilterFieldType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :field_type, String, null: false
    field :position, Integer, null: false
    field :key_query, String, null: false
    field :column_name, String, null: true
    field :options, GraphQL::Types::JSON, null: true
    field :active, Boolean, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end 