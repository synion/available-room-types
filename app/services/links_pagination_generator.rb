class LinksPaginationGenerator
  DEFAULT_FIRST = 1.freeze
  def initialize(path, total_pages:, current_page: nil)
    @path = path
    @total_pages = total_pages
    @current_page = current_page.present? ? current_page : DEFAULT_FIRST
  end

  def self.call(path, total_pages:, current_page: nil)
    new(path, total_pages: total_pages, current_page: current_page).call
  end

  def call
    meta_total_pages_information.merge(links_informations)
  end

  private

  attr_reader :path, :total_pages, :current_page

  def meta_total_pages_information
    { meta: { total_pages: total_pages } }
  end

  def links_informations
    all_links = { **self_page, **first_page, **last_page }

    all_links.merge!(next_page) if (total_pages > DEFAULT_FIRST) && (total_pages > current_page)
    all_links.merge!(prev_page) if (total_pages > DEFAULT_FIRST) && (current_page > DEFAULT_FIRST)

    { links: all_links }
  end

  def url
    @url ||= ENV.fetch('DOMAIN_URL') + path
  end

  def page_number(number)
    "page[number]=#{number}"
  end

  def self_page
    { self:  "#{url}#{connection_operator}#{page_number(current_page)}" }
  end

  def first_page
    { first: "#{url}#{connection_operator}#{page_number(DEFAULT_FIRST)}" }
  end

  def next_page
    { next: "#{url}#{connection_operator}#{page_number(current_page.to_i + DEFAULT_FIRST)}" }
  end

  def prev_page
    { prev: "#{url}#{connection_operator}#{page_number(current_page.to_i - DEFAULT_FIRST)}" }
  end

  def last_page
    { last: "#{url}#{connection_operator}#{page_number(total_pages)}" }
  end

  def connection_operator
    @connection_operator ||= begin
      uri = URI(url)
      queries = URI.parse(url).query
      queries.nil? ? '?' : '&'
    end
  end
end
