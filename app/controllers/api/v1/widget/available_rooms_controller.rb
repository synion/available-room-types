module Api
  module V1
    module Widget
      class AvailableRoomsController < ApplicationController
        def index
          respond_to do |format|
            msg = { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
            format.json  { render :json => msg } # don't do msg.to_json
          end
        end
      end
    end
  end
end
