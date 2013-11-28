require 'nokogiri'
require 'open-uri'

namespace :kiwimp do
  desc "fetch any new portfolios" 
  task :update_portfolios => :environment do
    doc = Nokogiri::HTML(open("http://www.dpmc.govt.nz/cabinet/portfolios/list"))

    doc.search(".item-list li a").each do |link|
      name = link.inner_text.gsub(/\(.+\)/, '').squish

      portfolio = Portfolio.where(portfolio_name: name).first

      portfolio_url = "http://www.dpmc.govt.nz#{link.attr('href')}"

      portfolio_doc = Nokogiri::HTML open(portfolio_url)
      title = portfolio_doc.at_css("#content-area .content tbody tr:nth(1) td").inner_text
      title = title.gsub(/\(.+\)/, '').squish

      if portfolio.nil?
        portfolio = Portfolio.create_portfolio(name, portfolio_url, title)
      else
        portfolio.update_attribute(:url, portfolio_url)
      end

      portfolio.ministers.each{|m|
        m.update_attribute(:title, title)
      }
    end
  end
end
