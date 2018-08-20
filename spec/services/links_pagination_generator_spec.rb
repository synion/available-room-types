require 'rails_helper'

describe LinksPaginationGenerator do
  describe '.call' do
    context 'when current page is first page' do
      it 'returns hash with generates links without prev' do
        allow(ENV).to receive(:fetch).with('DOMAIN_URL').and_return('www.available_rooms.com')

        link_genrator = LinksPaginationGenerator.call('/room_types', total_pages: 2)

        expect(link_genrator).to eql(
          meta: { total_pages: 2 },
          links: {
            self: 'www.available_rooms.com/room_types?page=1',
            first: 'www.available_rooms.com/room_types?page=1',
            next: 'www.available_rooms.com/room_types?page=2',
            last: 'www.available_rooms.com/room_types?page=2'
          }
        )
      end
    end

    context 'when current page is last page' do
      it 'returns hash with generates links with next' do
        allow(ENV).to receive(:fetch).with('DOMAIN_URL').and_return('www.available_rooms.com')

        link_genrator = LinksPaginationGenerator.call('/room_types?page=2', total_pages: 2)

        expect(link_genrator).to eql(
          meta: { total_pages: 2 },
          links: {
            self: 'www.available_rooms.com/room_types?page=2',
            first: 'www.available_rooms.com/room_types?page=1',
            prev: 'www.available_rooms.com/room_types?page=1',
            last: 'www.available_rooms.com/room_types?page=2'
          }
        )
      end
    end

    context 'when current page not present' do
      it 'returns hash with generates links with next' do
        allow(ENV).to receive(:fetch).with('DOMAIN_URL').and_return('www.available_rooms.com')

        link_genrator = LinksPaginationGenerator.call('/room_types', total_pages: 2)

        expect(link_genrator).to eql(
          meta: { total_pages: 2 },
          links: {
            self: 'www.available_rooms.com/room_types?page=1',
            first: 'www.available_rooms.com/room_types?page=1',
            next: 'www.available_rooms.com/room_types?page=2',
            last: 'www.available_rooms.com/room_types?page=2'
          }
        )
      end
    end

    context 'when current page middles page' do
      it 'returns hash with generates links with next' do
        allow(ENV).to receive(:fetch).with('DOMAIN_URL').and_return('www.available_rooms.com')

        link_genrator = LinksPaginationGenerator.call('/room_types?page=2', total_pages: 3)

        expect(link_genrator).to eql(
          meta: { total_pages: 3 },
          links: {
            self: 'www.available_rooms.com/room_types?page=2',
            first: 'www.available_rooms.com/room_types?page=1',
            next: 'www.available_rooms.com/room_types?page=3',
            prev: 'www.available_rooms.com/room_types?page=1',
            last: 'www.available_rooms.com/room_types?page=3'
          }
        )
      end
    end

    context 'when total pages is only one' do
      it 'returns hash with generates links without next and prev' do
        allow(ENV).to receive(:fetch).with('DOMAIN_URL').and_return('www.available_rooms.com')

        link_genrator = LinksPaginationGenerator.call('/room_types', total_pages: 1)

        expect(link_genrator).to eql(
          meta: { total_pages: 1 },
          links: {
            self: 'www.available_rooms.com/room_types?page=1',
            first: 'www.available_rooms.com/room_types?page=1',
            last: 'www.available_rooms.com/room_types?page=1'
          }
        )
      end
    end

    context 'when path is already have some params' do
      it 'returns hash with generates links with added page params' do
        allow(ENV).to receive(:fetch).with('DOMAIN_URL').and_return('www.available_rooms.com')

        link_genrator = LinksPaginationGenerator.call('/room_types?checkin_date=20-01-2012&page=1', total_pages: 1)

        expect(link_genrator).to eql(
          meta: { total_pages: 1 },
          links: {
            self: 'www.available_rooms.com/room_types?checkin_date=20-01-2012&page=1',
            first: 'www.available_rooms.com/room_types?checkin_date=20-01-2012&page=1',
            last: 'www.available_rooms.com/room_types?checkin_date=20-01-2012&page=1'
          }
        )
      end
    end

    context 'when url have already a page' do
      it 'returns hash with generates links with added page params' do
        allow(ENV).to receive(:fetch).with('DOMAIN_URL').and_return('www.available_rooms.com')

        link_genrator = LinksPaginationGenerator.call('/room_types?page=2', total_pages: 3)

        expect(link_genrator).to eql(
          meta: { total_pages: 3 },
          links: {
            self: 'www.available_rooms.com/room_types?page=2',
            first: 'www.available_rooms.com/room_types?page=1',
            next: 'www.available_rooms.com/room_types?page=3',
            prev: 'www.available_rooms.com/room_types?page=1',
            last: 'www.available_rooms.com/room_types?page=3'
          }
        )
      end
    end
  end
end
