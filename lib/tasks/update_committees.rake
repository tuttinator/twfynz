require 'nokogiri'
require 'open-uri'

namespace :kiwimp do
  desc "fetch any new committees"
  task :update_committees => :environment do
    doc = Hpricot open('http://www.parliament.nz/en-nz/pb/sc/details/')

    (doc/'.copy li a').each do |c|
      update_committee c
    end
  end

  def update_committee link
    url = 'http://www.parliament.nz' + link[:href]
    name = link.inner_text

    puts "Found committee with name #{name} and url #{url}"

    committee = Committee.find_by_committee_name name

    unless committee
      doc = Nokogiri::HTML(open(url))

      description = doc.search('#content .sectionIntro').inner_text
      description = doc.search('#content .copy .section:nth(1)').inner_text if description.blank?
      description.squish!

      Committee.create(:committee_name => name, :url => url, :description => description)
    end
  end
end
