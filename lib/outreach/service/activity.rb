module Outreach
  module Service
    class Activity

      class InvalidOutreachArguments < StandardError
      end


      def initialize(client)
        @request = client.request
      end

      def find(id)
        page = 1
        data = []
        attrs = {}
        attrs[:prospect_id] = id


        loop do
          # Set page #
          attrs[:page] = page

          # Query outreach
          begin
            response = @request.get(api_url, attribute_mapping(attrs))
          rescue JSON::ParserError => e
            response = @request.get(api_url, attribute_mapping(attrs))
          end

          # If there is an error break
          if response['errors']
            raise OutreachException.new("Exception trying to reach outreach. #{api_url}")
            break
          end

          data += response['data'].map {|attrs| collection_class.new(attrs)}

          # Stop if we've gotten the last page
          break if page * response['meta']['page']['maximum'] >= response['meta']['results']['total']

          # Add to page counter
          page += 1
        end
        data
      end

      protected

      def attribute_mapping(attrs)
        mapped_attrs = {}

        if attrs[:prospect_id]
          mapped_attrs["filter[prospect/id]"] = attrs.delete(:prospect_id)
        end


        # Pagination
        if attrs[:page]
          mapped_attrs["page[number]"] = attrs.delete(:page)
        end

        if attrs[:page_size]
          mapped_attrs["page[size]"] = attrs.delete(:page_size)
        end

        if attrs.present?
          # There are other attrs in Throw error, dont know how to filter for that attr
          raise InvalidOutreachArguments.new("Invalid outreach prospect filter parameters: #{attrs.keys.to_sentence}")
        end

        mapped_attrs
      end

      def api_url
        "https://api.outreach.io/1.0/activities"
      end

      def collection_class
        Outreach::Activity
      end
    end
  end
end
