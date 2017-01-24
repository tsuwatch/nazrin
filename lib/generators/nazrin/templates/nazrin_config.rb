Nazrin.configure do |config|
  config.mode = :production # or sandbox (It does nothing with any requests to CloudSearch)
  config.search_endpoint = ''
  config.document_endpoint = ''
  config.region = ''
  config.access_key_id = ''
  config.secret_access_key = ''
end
