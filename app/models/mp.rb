# encoding: UTF-8
require 'expire_cache'

class Mp < ActiveRecord::Base

  validates_presence_of :last
  validates_presence_of :first
  validates_presence_of :elected
  validates_presence_of :id_name
  validates_uniqueness_of :id_name
  # validates_presence_of :img

  belongs_to :party, :foreign_key => 'member_of_id'

  has_many :members, :foreign_key => 'person_id', :include => :party
  has_many :pecuniary_interests
  has_many :bills, :foreign_key => 'member_in_charge_id'
  has_many :contributions, :foreign_key => 'spoken_by_id'

  TITLES = ['Dr The Rt Hon', 'Dr the Hon', 'Rt Hon', 'Hon Dr', 'Hon', 'Dr', 'Sir']

  after_save :expire_cached_page

  include ExpireCache

  # before_save :set_wikipedia

  class << self

    def all_mps
      # @all_mps ||= Mp.find_by_sql('select id,first,alt,last from mps')
      Mp.find_by_sql('select id,first,alt,last from mps')
    end

    def all_mp_names
      all_mps.collect {|mp| "#{mp.alt.blank? ? mp.first : mp.alt} #{mp.last}" }
    end

    def from_vote_name name, date, party
      name = 'Roy E' if name == 'E Roy'
      name_downcase = name.downcase.strip.gsub('’',"'")
      mps = all_mps
      matching = mps.select {|mp| mp.last.downcase == name_downcase }
      if matching.size == 0
        matching = mps.select {|mp| (mp.last.downcase + ' ' + mp.first.downcase[0..0]) == name_downcase}
        if matching.size == 0
          matching = mps.select {|mp| (mp.last.downcase + mp.first.downcase[0..0]) == name_downcase}
          if matching.size == 0
            matching = mps.select {|mp| !mp.alt.blank? && (mp.last.downcase + ' ' + mp.alt.downcase[0..0]) == name_downcase}
          end
        end
      end

      if party
        matching = matching.select {|mp| mp.party_on_date(date) == party}
      else
        matching = matching.select {|mp| mp.member_on_date(date) != nil}
      end
      if matching.size == 1
        return matching[0]
      elsif matching.empty?
        raise "no matching MP for vote name/party/date: #{name} ; #{party ? party.short : 'no party'} ; #{date}"
      else
        raise "more than one matching MP for vote name: #{name} ; #{party.short} ; #{date}"
      end
    end

    def from_name speaker_name, date
      mp = nil
      unless speaker_name.blank?
        name = String.new speaker_name
        TITLES.each {|t| name.gsub!(t+' ', '')}
        name.strip!
        speaker = name.split('(')[0].downcase.strip.gsub('’',"'")

        speaker.gsub!(/\b -/, '-') # bad formatting of "Jami -Lee Ross"

        unless speaker[/speaker|member|chairperson/]
          all_mps.each do |m|
            if ((m.downcase_name == speaker) or
                (m.alt_downcase_name and m.alt_downcase_name == speaker) or
                (m.downcase_name.gsub(' ','') == speaker) or
                (speaker.index(m.downcase_name)) or
                (m.alt_downcase_name and m.alt_downcase_name.sub(' ','') == speaker))
              mp = find(m.id)
              break
            end
          end
        end

        if [ 'the assistant speaker',
          'the chairperson',
          'the temporary speaker',
          'the temporary chairperson' ].include?(speaker)
          sub_name = name.split('(')[1].chop.strip
          mp = Mp.from_name sub_name, date
        end

        mp = Role.find_speaker_at(speaker, date) if mp.nil?
      end
      mp
    end

    def all_by_last
      mps = Mp.find(:all, :order => "last", :include => [:party, :members])
      mps.delete_if{|mp| mp.is_former?}
    end

    def all_by_first
      mps = Mp.find(:all, :order => "first", :include => [:party,:members])
      mps.delete_if{|mp| mp.is_former?}
    end

    def all_by_electorate
      mps = Mp.find(:all, :include => [:party,:members])
      members = mps.collect{|mp| mp.member}.compact
      list_members = members.select {|m| m.electorate == 'List'}
      electorate_members = members.select {|m| m.electorate != 'List'}.sort_by(&:electorate)

      list_mps = list_members.collect(&:person).sort{|a,b| a.first <=> b.first}
      electorate_mps = electorate_members.collect(&:person)

      mps = (electorate_mps + list_mps)
    end

    def all_by_party
      mps = Mp.find(:all, :include => [:party,:members])
      members = mps.collect{|mp| mp.member}.compact
      members = members.select {|m| m.party}
      members_by_party = members.group_by {|m| m.party.short }
      parties = members_by_party.keys.sort

      mps = []
      parties.each do |party|
        mps << members_by_party[party].sort{|a,b| a.person.first <=> b.person.first}
      end
      mps = mps.flatten.collect(&:person)
    end
  end

  def anchor(date)
    party = party_on_date(date)
    raise date.to_s + ' ' + first + ' ' + last + ' ' + former.to_s unless party
    party.short == 'Independent' ? last.downcase : party.short.downcase.gsub(' ','_')
  end

  def set_wikipedia
    self.wikipedia_url = "http://en.wikipedia.org/wiki/#{first}_#{last.downcase.titleize}" unless !self.wikipedia_url.blank?
  end

  def full_name
    @full_name = first + ' ' + last unless @full_name
    @full_name
  end

  def downcase_name
    @downcase_name = (first.downcase + ' ' + last.downcase) unless @downcase_name
    @downcase_name
  end

  def alt_downcase_name
    if alt
      @alt_downcase_name = (alt.downcase + ' ' + last.downcase) unless @alt_downcase_name
    end
    @alt_downcase_name
  end

  def member_on_date date
    members.detect { |m| m.is_active_on(date) }
  end

  def member
    @member ||= member_on_date(Date.today)
  end

  def electorate
    member ? member.electorate : nil
  end

  def party_on_date date
    (member = member_on_date(date)) ? member.party : nil
  end

  def is_former?
    member ? false : true
  end

  def bills_in_charge_of
    bills.select { |b| b.current? }
  end

  def wordle_text
    name = "#{alt.blank? ? first : alt}~#{last}~words"
    Debate.wordlize_text unique_contributions.collect(&:wordle_text).join("\n"), name, 1
  end

  def unique_contributions
    debates = contributions.collect(&:debate).uniq.compact.sort { |a,b| b.date <=> a.date }
    debates = Debate::remove_duplicates(debates)
    contributions.select {|c| debates.include? c.debate }
  end

  def recent_contributions
    Contribution::recent_contributions contributions, id, Mp
  end

  def list_mp?
    member ? member.electorate == 'List' : false
  end

  def pecuniary_interests_by_category
    interests = pecuniary_interests

    categories = {}
    interests.each do |interest|
      categories[interest.pecuniary_category] = [] unless categories[interest.pecuniary_category]
      categories[interest.pecuniary_category] << interest
    end
    categories.sort {|a,b| a[0].id <=> b[0].id}
  end

  def portfolios_asked_about
    portfolios = question_debates.select {|d| d.about_type == 'Portfolio' }.group_by {|d| d.about}
    portfolios = most_frequent portfolios
    portfolios.sort! { |a,b| b[1].size <=> a[1].size }
    portfolios
  end

  def portfolios_answered_about
    portfolios = answer_debates.select {|d| d.about_type == 'Portfolio' }.group_by {|d| d.about}
    portfolios = most_frequent portfolios
    portfolios.sort! { |a,b| b[1].size <=> a[1].size }
    portfolios
  end

  def subjects_asked_about
    subjects = question_debates.group_by {|d| d.name.split('—').first }
    subjects = most_frequent subjects
    subjects.sort! { |a,b| b[1].last.date <=> a[1].last.date }
    subjects
  end

  def subjects_answered_about
    subjects = answer_debates.group_by {|d| d.name.split('—').first }
    subjects = most_frequent subjects
    subjects.sort! { |a,b| b[1].last.date <=> a[1].last.date }
    subjects
  end

  def question_debates
    oral_answer_debates SubsQuestion, SupQuestion
  end

  def answer_debates
    oral_answer_debates SubsAnswer, SupAnswer
  end

  def expire_cached_page
    uncache "/mps/#{id_name}.cache" if is_file_cache?
  end

  def set_resignation_details parliament_number, resignation_url, valedictory_url, to_what, to_date, replaced_by_id
    m = members.select{|x| x.parliament_id == parliament_number}.first
    m.resignation_url = resignation_url if resignation_url
    m.valedictory_statement_url = valedictory_url if valedictory_url
    m.to_what = to_what if to_what
    m.to_date = to_date if to_date
    m.replaced_by_id = replaced_by_id if replaced_by_id
    m.save
    self.former = true
    self.save
  end

  private

    def oral_answer_debates type, supplementary_type
      oral_answers = contributions.select {|o| o.debate.class == OralAnswer}
      debates = oral_answers.select {|o| o.class == type}.collect {|o| o.debate}.uniq

      supplementary_debates = oral_answers.select {|o| o.class == supplementary_type}.collect {|o| o.debate}.uniq

      supplementary_debates.delete_if {|d| debates.include? d}
      debates = Debate::remove_duplicates debates
      supplementary_debates = Debate::remove_duplicates supplementary_debates

      debates = (debates << supplementary_debates).flatten
      debates
    end

    def most_frequent subjects
      name_to_count = {}
      subjects.keys.each do |name|
        x = subjects[name].size
        name_to_count[name] = x
      end
      name_and_count = name_to_count.sort {|a,b| b[1]<=>a[1]}
      if name_and_count.size > 5
        frequency = name_and_count[4][1]
        index = 4
        while index.next < name_and_count.size and name_and_count[index.next][1] == frequency
          index += 1
        end
        name_and_count = name_and_count[0..index]
      end

      if name_and_count.size > 8
        frequency = name_and_count.last[1]
        index = name_and_count.size-1
        while index-1 > 0 and name_and_count[index-1][1] == frequency
          index -= 1
        end
        name_and_count = name_and_count[0..index-1]
      end

      frequent = subjects.select {|name, debates| name_and_count.assoc(name)}
      frequent.each do |name_and_debates|
        name_and_debates[1].sort! {|a,b| a.date <=> b.date}
      end

      frequent
    end
end
