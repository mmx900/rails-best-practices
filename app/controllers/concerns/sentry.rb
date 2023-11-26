module Sentry
  extend ActiveSupport::Concern

  included do
    before_action do
      if user_signed_in?
        Sentry.set_user({
          id: current_user.id,
          nickname: current_user.nickname,
          ip_address: request.remote_ip
        })
      end
    end
  end
end
