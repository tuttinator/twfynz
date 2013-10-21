require 'nokogiri'
require 'open-uri'

namespace :kiwimp do
  desc "fetch any new portfolios" 
  task :update_portfolios => :environment do
    doc = Nokogiri::HTML(open("http://beehive.govt.nz/portfolios"))

    doc.search(".item-list li a").each do |link|
      name = link.inner_text

      portfolio = Portfolio.where(portfolio_name: name).first

      if portfolio.nil?
        Portfolio.create_portfolio(name, link.attr('href').to_s, "Minister of #{name}")
      end
    end
  end
end
