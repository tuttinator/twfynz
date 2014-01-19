# encoding: UTF-8
require File.dirname(__FILE__) + '/../spec_helper'
require "#{Rails.root}/lib/hansard_parser.rb"

PARSED = {} unless defined?(PARSED)

def parse_hansard name, debate_index
  @url = 'http://www.parliament.nz/en-NZ/PB/Debates/Debates/c/5/7/'+name
  HansardParser.new(File.dirname(__FILE__) + "/../data/#{name}", @url, @date).parse debate_index
end

module ParserHelperMethods
  def parse_hansards
    @url = 'http://www.parliament.nz/en-NZ/PB/Debates/Debates/c/5/7/'+@file_name
    HansardParser.new(File.dirname(__FILE__) + "/../data/#{@file_name}", @url, @date).parse @debate_index
  end

  def def_party name, id
    party = double(Party)
    party.stub(:id).and_return id
    party.stub(:id_name).and_return(nil)
    party.stub(:vote_name).and_return name
    Party.stub(:from_vote_name).with(name).and_return(party)
    Party.stub(:find).with(id, {:select=>nil, :conditions=>nil, :readonly=>nil, :include=>nil}).and_return(party)
    party.stub(:new_record?).and_return false
    party
  end

  def def_parties
    @labour = def_party 'New Zealand Labour', 1
    @nz_first = def_party 'New Zealand First', 2
    @uf = def_party 'United Future', 3
    @progressive = def_party 'Progressive', 4
    @national = def_party 'New Zealand National', 5
    @act = def_party 'ACT New Zealand', 6
    @greens = def_party 'Green Party', 7
    @maori = def_party 'Māori Party', 8
    @independent = def_party 'Independent', 9
  end

  def parse_debate
    if PARSED[@file_name]
      @url = 'http://www.parliament.nz/en-NZ/PB/Debates/Debates/c/5/7/'+@file_name
      @debate = PARSED[@file_name]
    else
      if @bill_id
        @bill = double(Bill)
        @bill.stub(:id).and_return @bill_id
        @first_bill_name = @name unless @first_bill_name
        Bill.stub(:from_name_and_date).with(@first_bill_name, @date).and_return(@bill)
      end
      if @bill_id2
        @bill2 = double(Bill)
        @bill2.stub(:id).and_return @bill_id2
        Bill.stub(:from_name_and_date).with(@second_bill_name, @date).and_return(@bill2)
      end
      if @bill_id3
        @bill3 = double(Bill)
        @bill3.stub(:id).and_return @bill_id3
        Bill.stub(:from_name_and_date).with(@third_bill_name, @date).and_return(@bill3)
      end

      SubDebate.stub(:find_all_by_date_and_about_id).and_return([])
      @mp = double(Mp)
      @mp.stub(:party).and_return nil
      @mp.stub(:id).and_return 123
      Mp.stub(:from_name).and_return @mp
      Mp.stub(:from_vote_name).and_return @mp

      @debate = parse_hansards
      @debate.stub(:has_bill?).and_return false
      @debate.save!
      PARSED[@file_name] = @debate
    end
  end
end
