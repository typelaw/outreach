module Outreach
  class Sequence
    attr_accessor :id, :name, :raw_attrs

    def initialize(attrs)
      @name = attrs['attributes']['name']
      @id = attrs['id']
      @raw_attrs = attrs
    end
  end
end

