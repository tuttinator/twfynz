# encoding: UTF-8
require File.dirname(__FILE__) + '/hansard_parser_spec_helper'

describe HansardParser, "when passed comittee and third reading html" do
  include ParserHelperMethods

  before do
    @name = 'Bail Amendment Bill'
    @sub_name = 'In Committee'
    @class = BillDebate
    @css_class = 'billdebate'
    @publication_status = 'F'
    @bill_id = 111
    @date = Date.new(2013,8,27)

    @debate_index = 1
    @file_name = 'nil'

    def_parties
    HansardParser.stub(:load_file).and_return html
    @debate = parse_debate
    @sub_debate = @debate.sub_debate
  end

  after(:all) do
    Debate.find(:all).each {|d| d.destroy}
    PARSED.clear
  end

  it_should_behave_like "All parent debates"

  def html
    %Q|<html>
<head>
<title>New Zealand Parliament - Bail Amendment Bill — In Committee, Third Reading</title>
<meta name="DC.Date" content="2013-08-27T12:00:00.000Z" />
</head>
<body>
<div class="copy">
  <div class="section">
    <a name="DocumentTitle" ></a>
    <h1>Bail Amendment Bill — In Committee, Third Reading</h1>
    <a name="DocumentReference" ></a>
    <p>[Sitting date: 27 August 2013. Volume:693;Page:72. Text is subject to correction.]</p>
    <div class="BillDebate">
		<h1>Bail Amendment Bill</h1>
		<div class="SubDebate">
			<h2>
				In Committee
			</h2>
			<div class="Speech">
				<p class="Speech">
					<a name="time_21:07:17" ></a>
					<strong> CHRIS HIPKINS (Senior Whip—Labour) </strong>
					<strong> : </strong> I raise a point of order, Mr Chairperson. I seek leave for all stages of the Bail Amendment Bill to be debated as one question, with all questions to be put to the vote at the end of the debate.</p>
			</div>
				<div class="section"><h3>
					Parts 1 and 2, and clauses 1 to 3
				</h3></div>
		</div>
			<h1> Third Reading </h1>
			<div class="Speech">
				<p class="Speech">
					<a name="time_21:59:00" ></a>
					<strong> Hon JUDITH COLLINS (Minister of Justice) </strong>
					<strong> : </strong> I move,
 <em>That the Bail Amendment Bill be now read a third time</em> <strong> </strong>. This bill will make it harder for those accused of serious offences to get bail.</p>
				<p class="a">The bill also expands the list of offences where a defendant faces a reverse burden of proof when they are being considered for bail, if they have been convicted of one of these offences before.</p>
					<ul class=""><li>Debate interrupted.</li></ul>
			</div>
	</div>
  </div>
</body>
	</div>
					</div>
				</div>
				<br class="clear" />
	<hr />
			</div>
		</div>
	</body>
</html>|
  end
end
