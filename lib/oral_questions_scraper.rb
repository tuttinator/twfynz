require 'capybara'
require 'capybara/dsl'
require 'capybara/mechanize'

# NOTE about Capybara

# IMPORTANT! Some of the defaults have changed in Capybara 2.1. If you're experiencing failures,
# please revert to the old behaviour by setting:

#     Capybara.configure do |config|
#       config.match = :one
#       config.exact_options = true
#       config.ignore_hidden_elements = true
#       config.visible_text_only = true
#     end

# If you're migrating from Capybara 1.x, try:

#     Capybara.configure do |config|
#       config.match = :prefer_exact
#       config.ignore_hidden_elements = false
#     end

# Details here: http://www.elabs.se/blog/60-introducing-capybara-2-1

module Parliament
  
  class Question
    attr_accessor :date, :number, :topic, :mp, :minister, :url
  end

  class Scraper


  # Questions for Oral Answer - data structure
    # Date
      # Question Number
        # Topic
        # MP asking the question
        # Minister asked
        # URL



    include Capybara::DSL

    QUESTIONS_PER_PAGE = 20

    def initialize
      Capybara.current_driver = :mechanize
      Capybara.run_server = false
      Capybara.app_host = "http://www.parliament.nz"
    end

    def find_number_of_pages

      ### Crap, these links now seem to be deprecated :( :( :(

      # This link is for every Question for Oral Answer since 2003, in groups of 20 questions per page
      visit "/en-NZ/PB/Business/QOA/Default.htm?p=0&sort=PublicationDate&order=0"

      # Assumes that it'll find this: <td class='summary'><h3>Questions for oral answer 1 to 20 of 9721</h3></td>
      @total_questions = page.find("td.summary h3").text.match(/of ([\d]*)/)[1].to_i # should be a number like 9721

      # Return the number of page to loop through
      # Cast to floats and then Floor'ed as the list is zero indexed
      (@total_questions.to_f / QUESTIONS_PER_PAGE.to_f).floor
    end

    def scrape
      questions = []
      (0..find_number_of_pages).each do |n|
        visit "/en-NZ/PB/Business/QOA/Default.htm?p=#{n}&sort=PublicationDate&order=0"

        page.all("table.listing tbody tr").each do |tr|

          # There are entries that say "List of questions for oral answer"
          # which are just lists of the primary questions
          next if tr.find("h4 a").text =~ /List of questions for oral answer/

          question = Question.new

          # Parse the date of the Question Time session
          question.date = Date.parse(tr.find("td.attrPublicationDate").text)

          # Assign the question number and topic
          question.number, question.topic = tr.find("h4 a").text.split('.')

          # get the link (probably the most valuable thing)
          question.url = tr.find("h4 a")[:href]

          begin
            # Splits on the word ' to ' - first the MP asking the question
            # second is the minister answering the question
            question.mp, question.minister = tr.find("td p").text.split(' to ')

            [question.mp, question.minister, question.topic].each { |q| q.strip! }

          rescue
            puts "-- Possibly a question to the select committee chairperson"
          end

          puts question.to_yaml

          questions << question
        end       

      end


      puts questions.to_yaml

    end

  end
end