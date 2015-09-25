require 'uri'
module Scrapers::UrlHelpers
  # Find the HTML base tag if it is defined
  # page - A Nokogiri document
  def base_tag(page)
    page.xpath('//base/@href').first
  end

  # Given a page returns the base_url that should be prepended to a tags
  # Ex: url is http://google.com/one/two.html
  # Base url is http://google.com
  def base_url(page, page_url)
    uri = URI(page_url)
    # Some sites have a <base> element that overrides the base url
    if !base_tag(page).nil?
      base_tag(page).text
    else
      "#{uri.scheme}://#{uri.host}"
    end
  end

  # Assemble a url based on an existing url and a path from an href attribute
  # page - a Nokogiri document
  # path - value from an href attribute on that page
  def full_url(page, page_url, path)
    return path if path.starts_with?('http')
    if path.starts_with?('/')
      url = "#{base_url(page, page_url)}/#{path}"
    else
      url = "#{page_url.gsub(/\/[^\/]+\Z/, '')}/#{path}"
    end
    clean_extra_slashes(url)
  end

  def clean_extra_slashes(url)
    url.gsub(/(?<!:)\/{2,}/, '/')
  end
end
