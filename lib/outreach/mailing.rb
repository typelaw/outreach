module Outreach
  class Mailing
    attr_accessor :id, :prospect_id, :source, :state, :raw_attrs

    def initialize(attrs)
      @id = attrs['id']
      @prospect_id  = attrs['attributes']['prospect']['id']
      @source = attrs['attributes']['source']
      @state = attrs['attributes']['state']

      @raw_attrs = attrs
    end

    private

    def to_ostruct(hash)
      o = OpenStruct.new(hash)
      hash.each.with_object(o) do |(k,v), o|
        o.send(:"#{k}=", to_ostruct(v)) if v.is_a? Hash
      end
      o
    end
  end
end

