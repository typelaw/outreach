module Outreach
  module Service
    class Sequence

      def initialize(client)
        @request = client.request
      end

      def add_prospect(sequence_id, prospect_id)
        attrs={
          data: {
            relationships: {
              prospects: [{
                data: {
                  id: prospect_id
                }
              }]
            }
          }
        }

        @request.patch("#{api_url}/#{sequence_id}",attrs)
      end

      def find_all
        response = @request.get("#{api_url}")

        #TODO: Add pagination functionality
        response['data'].map!{|attrs| collection_class.new(attrs)}
      end

      protected
      def api_url
        "https://api.outreach.io/1.0/sequences"
      end


      def collection_class
        Outreach::Sequence
      end
    end
  end
end
