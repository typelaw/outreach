module Outreach
  module Service
    class Mailing

      def initialize(client)
        @request = client.request
      end

      def find(id)

        begin
          response = @request.get("#{api_url}/#{id}")
        rescue JSON::ParserError => e
          # retry
          response = @request.get("#{api_url}/#{id}")
        end

        #TODO: Add pagination functionality
        collection_class.new(response['data'])
      end

      protected
      def api_url
        "https://api.outreach.io/1.0/mailings"
      end


      def collection_class
        Outreach::Mailing
      end
    end
  end
end
