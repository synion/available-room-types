class LinksPaginationGenerator
  DEFAULT_FIRST = 1.freeze
  PAGE_REGEX = /page=(\d)/.freeze

  def initialize(path, total_pages:)
    @path = path
    @total_pages = total_pages
  end

  def self.call(path, total_pages:)
    new(path, total_pages: total_pages).call
  end

  def call
    meta_total_pages_information.merge(links_informations)
  end

  private

  attr_reader :path, :total_pages

  def meta_total_pages_information
    { meta: { total_pages: total_pages.to_s } }
  end

  def current_page
    @current_page ||= (query_url_with_page? && query_url[PAGE_REGEX,1].to_i) || DEFAULT_FIRST
  end

  def links_informations
    all_links = total_pages != 0 ? { **self_page, **first_page, **last_page } : {}

    all_links.merge!(next_page) if (total_pages > DEFAULT_FIRST) && (total_pages > current_page) && total_pages != 0
    all_links.merge!(prev_page) if (total_pages > DEFAULT_FIRST) && (current_page > DEFAULT_FIRST) && total_pages != 0

    { links: all_links }
  end

  def query_url_with_page?
    query_url.present? && query_url[PAGE_REGEX].present?
  end

  def url
    @url ||= ENV.fetch('DOMAIN_URL') + path
  end

  def new_url
    @new_url ||= ENV.fetch('DOMAIN_URL') + new_path
  end

  def new_path
    @new_path ||= path.gsub(/\W+page=\d/,'')
  end

  def page_number(number)
    "page=#{number}"
  end

  def self_page
    { self:  "#{new_url}#{connection_operator}#{page_number(current_page)}" }
  end

  def first_page
    { first: "#{new_url}#{connection_operator}#{page_number(DEFAULT_FIRST)}" }
  end

  def next_page
    { next: "#{new_url}#{connection_operator}#{page_number(current_page.to_i + DEFAULT_FIRST)}" }
  end

  def prev_page
    { prev: "#{new_url}#{connection_operator}#{page_number(current_page.to_i - DEFAULT_FIRST)}" }
  end

  def last_page
    { last: "#{new_url}#{connection_operator}#{page_number(total_pages)}" }
  end

  def connection_operator
    @connection_operator ||= begin
      query_url&.include?('&')  ? '&' : '?'
    end
  end

  def query_url
    @query_url ||= begin
      uri = URI(url)
      queries = URI.parse(url).query
    end
  end
end
