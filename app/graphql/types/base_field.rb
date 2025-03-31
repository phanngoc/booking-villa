module Types
  class BaseField < GraphQL::Schema::Field
    def initialize(*args, null: true, **kwargs, &block)
      super(*args, null: null, **kwargs, &block)
    end
  end
end 