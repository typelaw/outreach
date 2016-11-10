module Outreach
  class Activity
    attr_accessor :id, :type, :actor_id, :actor_type, :action, :account_id, :mailing_id, :message_id, :sequence_id, :timestamp, :raw_attrs

    def initialize(attrs)
      @id = attrs['id']
      @type = attrs['type']
      @action = attrs['attributes']['action']
      @actor_id = attrs['attributes']['actor']['id']
      @actor_type = attrs['attributes']['actor']['type']
      @account_id = attrs['attributes']['metadata']['account']['id']
      @mailing_id = attrs['attributes']['metadata']['mailing']['id']
      @message_id = attrs['attributes']['metadata']['message']['id']
      @sequence_id = attrs['attributes']['metadata']['sequence']['id']
      @timestamp = DateTime.parse(attrs['attributes']['metadata']['timestamp'])

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

