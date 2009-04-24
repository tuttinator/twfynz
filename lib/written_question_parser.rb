require 'hpricot'

class WrittenQuestionParser
  def parse html
    q = WrittenQuestion.new
    @doc = Hpricot.parse(html)

    date_text = @doc.at("meta[@name='DC.Date']").get_attribute(:content)
    q.date_asked = Date.parse(date_text[0,10])

    title = @doc.at("meta[@name='DC.Title']").get_attribute(:content)
    matches = /^(\d+) \((\d{4})\)\. (.+?) to the(( (?:Deputy )?Leader of the House)|( Attorney-General)|( (?:Deputy )?Prime Minister)|(?:(?: Associate)? Minister(?: Responsible| in Charge)? (?:for|of) (.+)))/i.match(title)

    q.question_number = matches[1]
    q.question_year = matches[2]

    portfolio_name = matches[5] || matches[6] || matches[7] || matches[8] || matches[9]
    q.portfolio_name = matches[4].strip
    q.portfolio = Portfolio.from_name(portfolio_name)

    asker_name = matches[3]
    q.asker = Mp.from_name(asker_name, q.date_asked)

    q_text = @doc.at(".qandaset .question").inner_html.gsub(/[\t\n]/, " ").squeeze(" ")
    q.question = /.+\(\d{1,2} \w{3} \d{4}\):(.+)/.match(q_text)[1].strip

    q.subject = @doc.at("meta[@name='DC.Subject']").get_attribute(:content)

    answer = @doc.at(".qandaset .answer")
    a_text = answer.inner_html
    q.answer = /.+\) replied: (.+)/m.match(a_text)[1].gsub(/\n/, ' ').squeeze(' ').strip

    if /Reply due: \d{1,2} \w{3} \d{4}/.match(q.answer).nil?
      q.status = "reply"
    else
      q.status = "question"
    end

    if q.status == "reply"
      respondent_name = answer.at(".Minister").inner_html.gsub(/[\n\t]/, "").squeeze(" ").strip
      q.respondent = Mp.from_name(respondent_name,  q.date_asked)
    end
    q
  end
end