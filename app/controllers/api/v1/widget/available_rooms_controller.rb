module Api
  module V1
    module Widget
      class AvailableRoomsController < ApplicationController
        def index
          respond_to do |format|
            format.json { render json:  Room.available_rooms(params[:checkin_date]..params[:checkout_date]) }
          end
        end
      end
    end
  end
end
