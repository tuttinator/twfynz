shared_examples "All debates" do
  it 'should create debate with correct type' do
    @debate.should be_an_instance_of(@class)
  end

  it 'should set debate index' do
    @debate.debate_index.should == @debate_index
  end

  it 'should set debate name' do
    @debate.name.should == @name
  end

  it 'should set debate date' do
    @debate.date.to_s.should == @date.to_s
  end

  it 'should set publication status' do
    @debate.publication_status.should == @publication_status
  end

  it 'should set css_class' do
    @debate.css_class.should == @css_class
  end

  it 'should set source_url' do
    @debate.source_url.should == @url
  end
end

shared_examples "All alone debates" do
  it_should_behave_like "All debates"

  before(:all) do
    @css_class = 'debatealone'
    @class = DebateAlone
  end
end

shared_examples "All bill debates" do
  it_should_behave_like "All debates"

  it 'should create ParentDebate with SubDebate' do
    @debate.should be_a_kind_of(ParentDebate)
    @sub_debate.should be_an_instance_of(SubDebate)
  end

end

shared_examples "All parent debates" do
  it_should_behave_like "All debates"

  it 'should create ParentDebate with SubDebate' do
    @debate.should be_a_kind_of(ParentDebate)
    # @sub_debate.should be_an_instance_of(SubDebate)
  end

  it 'should set sub debate name' do
    @sub_debate.name.should == @sub_name
  end

  it 'should set sub debate index' do
    @sub_debate.debate_index.should == @debate_index+1
  end

  it 'should set sub debate date' do
    @sub_debate.date.to_s.should == @date.to_s
  end

  it 'should set subdebate css_class' do
    @sub_debate.css_class.should == 'subdebate'
  end

  it 'should set publication status on sub debate' do
    @sub_debate.publication_status.should == @publication_status
  end
end
