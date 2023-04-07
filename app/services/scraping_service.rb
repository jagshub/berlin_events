class ScrapingService
  require 'open-uri'
  require 'nokogiri'
  require 'sidekiq-scheduler'
  include Sidekiq::Worker

  def perform(*args)
    web_sources = WebSource.all

    web_sources.each do |source|

      web_page = Nokogiri::HTML(open(source.url))
      scrape_co_berlin(web_page, source) if source.title == "Co_Berlin"
      scrape_berghain(web_page, source) if source.title == "Berghain"
    rescue StandardError => e
      p e.inspect
      Rails.logger.error(e.inspect)
    end
  end

  def scrape_co_berlin(web_page, source)
    web_page.css('div.views-row').each do |event|
      days = event.css(".layout__region--second").at('.date-display-range').content.strip
      title = event.css(".layout__region--second").at('.field--name-title').content.strip
      subtitle = event.css(".layout__region--second").at('.field--name-field-subtitle').content.strip
      category = event.css(".layout__region--second").at('.field--name-field-category').content.strip
      url = [source.base_url, event&.css('a')&.attribute('href')&.value].join
      start_date, end_date = days.split(/\–/)
      end_date = end_date.nil? ? start_date : end_date
      start_date, end_date = start_date.strip, end_date.strip
      day, mon_dt, year = end_date.split(/,/)
      mon, dt = mon_dt.split
      year = year.strip
      formatted_end_date = Date.strptime("#{day}#{dt}#{mon}#{year}", '%a%d%b%Y')

      day, mon_dt = start_date.split(/,/)
      mon, dt = mon_dt.split
      formatted_start_date = Date.strptime("#{day}#{dt}#{mon}#{year}", '%a%d%b%Y')

      source.events.find_or_create_by(
        title: title.to_s,
        subtitle: subtitle.to_s,
        start_date: formatted_start_date,
        end_date: formatted_end_date,
        url: url.to_s,
        category: category.to_s,
      )
    rescue ActiveRecord::RecordNotUnique => e
      p e.inspect
      Rails.logger.error(e.inspect)
    end
  end

  def scrape_berghain(web_page, source)
    web_page.css('.upcoming-event').each do |event|

      url = [source.base_url, event.attribute('href')&.value].join
      title = event.at('.text-lg').content.strip
      subtitle = event.at('.ml-3\/4').content.strip.delete!("\n").squeeze(" ")
      start_date = event.at('.font-bold').content.strip.gsub(/\./,'-')
      formatted_start_date = formatted_end_date = Date.strptime(start_date, '%d-%m-%Y')
      category = nil

      source.events.find_or_create_by(
        title: title.to_s,
        subtitle: subtitle.to_s,
        start_date: formatted_start_date,
        end_date: formatted_end_date,
        url: url.to_s,
        category: category.to_s,
        )
      p title
    rescue ActiveRecord::RecordNotUnique => e
      p e.inspect
      Rails.logger.error(e.inspect)
    end
  end
end
