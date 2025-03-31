module Types
  class BaseEnum < GraphQL::Schema::Enum
    value_class Types::BaseEnumValue
  end
end 