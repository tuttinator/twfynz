require 'open-uri'
require 'nokogiri'

module Scrapers

  class MPs

    URL = 'http://www.parliament.nz/en-nz/mpp/mps/current/?pf=&sf=&lgc=1'

    def scrape
      doc = Nokogiri::HTML(open(URL))
      mps = []

      doc.css("table.listing tbody tr").each do |tr|
       mps << extract_mp_details(tr)
      end

      mps
    end

    def extract_mp_details(tr)
      link = tr.css("td").first.css("a").attr('href').value
      parliament_id = link.match(/\/en-nz\/mpp\/mps\/current\/([A-Z0-9]+)\//)[1]
      name = tr.css("td").first.text.strip

      last_name, first_name = name.split(', ')

      party = tr.css("td").last.text.strip.split(', ').first
      electorate = tr.css("td").last.text.strip.split(', ').last

      case electorate
      when "List"
        electorate = nil
        list = true
      else
        list = false
      end

      {
        parliament_id:  parliament_id,
        link:           link,
        first_name:     first_name,
        last_name:      last_name,
        party:          party,
        electorate:     electorate,
        list:           list
      }

    end

  end

end