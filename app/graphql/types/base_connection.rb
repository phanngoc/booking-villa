module Types
  class BaseConnection < GraphQL::Types::Relay::BaseConnection
    field_class Types::BaseField
  end
end 