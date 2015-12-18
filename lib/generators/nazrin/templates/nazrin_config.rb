Nazrin.configure do |config|
  config.debug_mode = false
  config.search_endpoint = ''
  config.document_endpoint = ''
  config.region = ''
  config.access_key_id = ''
  config.secret_access_key = ''
  # currently support 'kaminari', 'will_paginate' or 'nazrin'
  config.pagination = 'kaminari'
end
