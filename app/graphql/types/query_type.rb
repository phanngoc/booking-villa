module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :filter_fields, [Types::FilterFieldType], null: false,
      description: "Returns a list of filter fields"

    def filter_fields
      FilterField.active.ordered
    end
  end
end 