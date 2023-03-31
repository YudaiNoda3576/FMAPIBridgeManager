# frozen_string_literal: true

# Use ActiveRecord token store
# FmRest.token_store = FmRest::TokenStore::ActiveRecord

# Use ActiveRecord token store with custom table name
# FmRest.token_store = FmRest::TokenStore::ActiveRecord.new(table_name: "my_token_store")

# Use Redis token store (requires redis gem)
host = ENV.fetch('REDIS_HOST', nil)
port = ENV.fetch('REDIS_PORT', nil)
TOKEN_STORE_DB = 8
token_store_url = "redis://#{host}:#{port}/#{TOKEN_STORE_DB}"
FmRest.token_store = FmRest::TokenStore::Redis.new(url: token_store_url)

# Use Redis token store with custom prefix
# FmRest.token_store = FmRest::TokenStore::Redis.new(prefix: "my-fmrest-token:")

# Use Moneta token store (requires moneta gem)
# FmRest.token_store = FmRest::TokenStore::Moneta.new(backend: )

# Use Memory token store (not suitable for production)
# FmRest.token_store = FmRest::TokenStore::Memory

FmRest.default_connection_settings = {
  host: ENV.fetch('FILEMAKER_HOST', nil),
  database: ENV.fetch('FILEMAKER_DB', nil),
  username: ENV.fetch('CLARIS_ID', nil),
  password: ENV.fetch('CLARIS_PASS', nil)
}
