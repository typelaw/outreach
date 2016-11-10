module Outreach
  class Prospect
    attr_accessor :id, :email, :first_name, :last_name, :company, :contact, :tags, :id, :custom, :raw_attrs, :updated_after

    def initialize(attrs)
      @id = attrs['id']
      @first_name = attrs['attributes']['personal']['name']['first']
      @last_name = attrs['attributes']['personal']['name']['last']
      @email = attrs['attributes']['contact']['email']
      @company = to_ostruct(attrs['attributes']['company'])
      @contact = to_ostruct(attrs['attributes']['contact'])
      @tags = attrs['attributes']['metadata']['tags']
      @id = attrs['id']
      @custom = Hash[attrs['attributes']['metadata']['custom'].each_with_index.map{|v,index| ["custom#{index}",v]}]
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

