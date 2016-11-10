module Outreach
  module Service
    class Prospect

      class InvalidOutreachArguments < StandardError
      class OutreachException < StandardError

      end
      end
      def initialize(client)
        @request = client.request
      end

      def find(id)
        response = @request.get("#{api_url}/#{id}")
        collection_class.new(response['data'])
      end

      def find_all(attrs={})
        page = 1
        data = []

        loop do
          # Set page #
          attrs[:page] = page

          # Query outreach
          response = @request.get(api_url, attribute_mapping(attrs))

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

      def create(attrs)
        @request.post(api_url, attrs)
      end

      def update(id,attrs)
        @request.patch("#{api_url}/#{id}", attrs)
      end

      protected

      def api_url
        "https://api.outreach.io/1.0/prospects"
      end

      def collection_class
        Outreach::Prospect
      end

      def attribute_mapping(attrs)
        mapped_attrs = {}
        if attrs[:first_name]
          mapped_attrs["filter[personal/name/first]"] = attrs.delete(:first_name)
        end
        if attrs[:last_name]
          mapped_attrs["filter[personal/name/last]"] = attrs.delete(:last_name)
        end

        if attrs[:email]
          mapped_attrs["filter[contact/email]"] = attrs.delete(:email)
        end

        if attrs[:company_name]
          mapped_attrs["filter[company/name]"] = attrs.delete(company_name)
        end

        if attrs[:updated_after]
          mapped_attrs["filter[metadata/updated/after]"] = attrs.delete(:updated_after)
        end

        if attrs[:updated_before]
          mapped_attrs["filter[metadata/updated/before]"] = attrs.delete(:updated_before)
        end

        if attrs[:opted_out]
          mapped_attrs["filter[metadata/opted_out]"] = attrs.delete(:opted_out)
        end

        if attrs[:title]
          mapped_attrs["filter[personal/title]"] = attrs.delete(:title)
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
    end
  end
end
