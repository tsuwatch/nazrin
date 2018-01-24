module Nazrin
  module Searchable
    class Configuration
      %i(
        search_endpoint
        document_endpoint
        region
        access_key_id
        secret_access_key
        logger
      ).each do |attr|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{attr}
            @#{attr} || Nazrin.config.#{attr}
          end

          def #{attr}=(v)
            @#{attr} = v
          end
        CODE
      end
    end
  end
end
