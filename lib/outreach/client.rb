module Outreach
  class Client
    def initialize(api_token)
      @api_token = api_token
    end

    def prospects
      Outreach::Service::Prospect.new(self)
    end

    def activities
      Outreach::Service::Activity.new(self)
    end

    def sequences
      Outreach::Service::Sequence.new(self)
    end

    def mailings
      Outreach::Service::Mailing.new(self)
    end

    def request
      Request.new(@api_token)
    end
  end
end
