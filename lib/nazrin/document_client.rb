module Nazrin
  class DocumentClient
    attr_reader :client

    def initialize(config=Nazrin.config)
      @client = Aws::CloudSearchDomain::Client.new(
        endpoint: config.document_endpoint,
        region: config.region,
        access_key_id: config.access_key_id,
        secret_access_key: config.secret_access_key,
        logger: config.logger)
    end

    def add_document(id, field_data)
      ActiveSupport::Deprecation.warn 'config.debug_mode is deprecated. Use config.mode = \'sandbox\' instead.' and return nil if Nazrin.config.debug_mode
      return nil if Nazrin.config.mode == 'sandbox'
      client.upload_documents(
        documents: [
          {
            type: 'add',
            id: id,
            fields: field_data
          }
        ].to_json,
        content_type: 'application/json')
    end

    def delete_document(id)
      ActiveSupport::Deprecation.warn 'config.debug_mode is deprecated. Use config.mode = \'sandbox\' instead.' and return nil if Nazrin.config.debug_mode
      return nil if Nazrin.config.mode == 'sandbox'
      client.upload_documents(
        documents: [
          {
            type: 'delete',
            id: id
          }
        ].to_json,
        content_type: 'application/json')
    end

    def batch(operations)
      ActiveSupport::Deprecation.warn 'config.debug_mode is deprecated. Use config.mode = \'sandbox\' instead.' and return nil if Nazrin.config.debug_mode
      return nil if Nazrin.config.mode == 'sandbox'

      documents = operations.each_with_object([]) do |(type, tuple), arr|
        if type.to_sym == :add
          tuple.each do |id, field_data|
            arr.push(
              type: 'add',
              id: id,
              fields: field_data
            )
          end
        else
          tuple.map do |id|
            arr.push(
              type: 'delete',
              id: id
            )
          end
        end
      end

      client.upload_documents(
        documents: documents.to_json,
        content_type: 'application/json'
      )
    end
  end
end
