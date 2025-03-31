class Schema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # Enable batch loading
  use GraphQL::Batch

  # Enable fragment caching
  use GraphQL::FragmentCache

  # Enable persisted queries
  use GraphQL::PersistedQueries, compiled_queries: true

  # Set max depth to prevent malicious queries
  max_depth 10

  # Set max complexity to prevent malicious queries
  max_complexity 300

  # Enable introspection in production
  introspection true
end 