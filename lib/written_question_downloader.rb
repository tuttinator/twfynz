require 'rubygems'
require 'open-uri'
require 'hpricot'

class WrittenQuestionDownloader
  STATUSES = ["Question", "Reply"]

  def download date=Date.parse("1 Jan 2009")
    @date = date
    finished = false
    page = 88
    questions = questions_in_index(page)
    statuses = []
    while !questions.empty? and !finished and (statuses.include?("Question") or statuses.empty?)
      finished, statuses = download_questions(questions)
      puts statuses.inspect
      page = page.next
      questions = questions_in_index(page)
    end

    PersistedFile.set_written_indexes_on_date
  end

  def open_index_page page
    url = "http://www.parliament.nz/en-NZ/PB/Debates/QWA/Default.htm?p=#{page}"
    puts "opening #{url}"
    Hpricot open(url)
  end

  def questions_in_index page
    doc = open_index_page page
    (doc/'.listing tbody tr')
  end

  def download_questions questions
    finished = false
    statuses = []
    questions.each do |question|
      unless finished
        finished, status = download_question(question)
        statuses << status
      end
    end
    return finished, statuses
  end

  def download_question question
    date = date_question question
    status = get_status question
    right_year = date.year == @date.year
    if right_year and STATUSES.include?(status)
      continue_download question, date, status
    end
    finished = !right_year
    return finished, status
  end

  def continue_download question, date, status
    persisted_file = PersistedFile.new({
        :debate_date => date,
        :oral_answer => @downloading_uncorrected,
        :parliament_name => question_name(question),
        :parliament_url => question_url(question),
        :written_status => status,
        :publication_status => 'W'
      })

    download_if_new persisted_file
  end

  def question_name question
    question.at("h4 a").inner_html
  end

  def download_if_new persisted_file
    finished = false
    if persisted_file.exists?
      PersistedFile.add_if_missing persisted_file
    else
      finished = download_this_question persisted_file
    end
    finished
  end

  def download_this_question persisted_file
    contents = question_contents(persisted_file.parliament_url)
    finished = false

    if contents.include? 'Server Error'
      PersistedFile.add_non_downloaded persisted_file
    else
      if persisted_file.exists?
        PersistedFile.add_if_missing persisted_file
      else
        PersistedFile.add_new persisted_file, contents
      end
    end
    finished
  end

  def question_contents url
    contents = nil
    open(url) { |io| contents = io.read }
    contents
  end


  def question_url question
    "http://www.parliament.nz#{question.at("h4 a").attributes["href"]}"
  end

  def get_status question
    question.at('.attrStatus').inner_html
  end

  def date_question question
    date = Date.parse(question.at('.attrPublicationDate').inner_html)
    date = date.advance(:years => 2000) if date.year < 2000
  end
end
