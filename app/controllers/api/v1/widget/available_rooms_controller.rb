module Api
  module V1
    module Widget
      class AvailableRoomsController < ApplicationController
        before_action :authorize_user
        def index
          form = ::Widget::AvailableRoomForm.new(params)
          if form.valid?
            render json: Widgets::AvailableRoomTypeSerializer.new(paginate_room_type,
                                                                  pagination_links.merge(**meta_information))
          else
            render json: form.errors, status: 400
          end
        end

        private

        def pagination_links
          @pagination_links ||= LinksPaginationGenerator.call(request.original_fullpath,
                                                           total_pages: paginate_room_type.total_pages)
        end

        def available_room_types
          @available_room_types ||= RoomType.grouped_available_rooms_types(params[:checkin_date]..params[:checkout_date])
        end

        def paginate_room_type
          @paginate_room_type ||= available_room_types.page(params[:page])
        end

        def meta_information
          @meta_information ||= { meta: { room_types: available_room_types.pluck(:name).sort } }
        end

        def authorize_user
          user_authorization = UserAuthorization.call(request.headers)
          render json: user_authorization.errors.first, status: 401 unless user_authorization.errors.empty?
        end
      end
    end
  end
end
