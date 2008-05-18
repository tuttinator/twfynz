require 'acts_as_slugged'

class Debate < ActiveRecord::Base

  has_many :contributions, :foreign_key => 'spoken_in_id', :dependent => :destroy, :order => 'id'
  has_many :debate_topics, :foreign_key => 'debate_id', :dependent => :destroy

  after_save :expire_cached_pages

  before_create :create_url_slug
  acts_as_slugged

  CATEGORIES = %w[visitors motions urgent_debates_declined points_of_order
      tabling_of_documents obituaries speakers_rulings personal_explanations
      appointments urgent_debates privilege speakers_statements resignations
      ministerial_statements adjournment parliamentary_service_commission
      business_of_select_committees
      business_statement general_debate business_of_the_house sittings_of_the_house
      members_sworn address_in_reply debate_on_prime_ministers_statement list_member_vacancy
      budget_debate standing_orders maiden_statement valedictory_statement members_bills
      prime_ministers_statement debate_on_budget_policy_statement offices_of_parliament
      state_opening officers_of_parliament reinstatement_of_business commission_opening_of_parliament]

  MONTHS_LC = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec']

  class << self

    def find_by_url_category_and_url_slug date, category, url_slug
      debates = find_all_by_date_and_url_category_and_url_slug date.yyyy_mm_dd, category, url_slug
      remove_duplicates(debates).first
    end

    def recent
      debates = remove_duplicates find_by_sql("select * from debates where type != 'BillDebate' and type != 'OralAnswer' and type != 'SubDebate' and type != 'OralAnswers' order by date DESC limit 20")
      debates.sort! {|a,b| (comparison = a.name <=> b.name) == 0 ? (a.date <=> b.date) : comparison }
      debates.in_groups_by(&:name)
    end

    def find_referred_oral_answer debate
      find_by_date_and_oral_answer_no(debate.date, debate.re_oral_answer_no)
    end

    def find_by_about_on_date about_type, about_url, date
      about = about_type.find_by_url about_url
      type = about_type.name
      id = about.id
      @debates = Debate.find_by_about(type, id, date.year, date.month, date.day, nil)
    end

    def find_by_about_on_date_with_index about_type, about_url, date, index
      abouts = about_type.find_all_by_url(about_url)
      debate = find_by_about_with_index(about_type, abouts.first.id, date, index)
      debate = find_by_about_with_index(about_type, abouts.last.id,  date, index) unless debate
      debate
    end

    def find_by_about_with_index about_type, about_id, date, index
      debates = find_by_about(about_type.to_s, about_id, date.year, date.month, date.day, index)
      remove_duplicates(debates).first
    end

    def find_by_about about_type, about_id, year, month, day, index
      month = mmm_to_mm month if month
      date = year+'-'+month+'-'+day if day

      if index
        index_prefix = index[0..0]
        type = 'OralAnswer' if index_prefix == 'o'
        type = 'SubDebate' if index_prefix == 'd'
        debates = find_all_by_date_and_about_id_and_about_type_and_about_index_and_type(date, about_id, about_type, index[1..2], type)
      elsif day
        debates = find_all_by_date_and_about_id_and_about_type(date, about_id, about_type)
      elsif month
        debates = find(:all,
           :conditions => ['year(date) = ? and month(date) = ? and about_id = ? and about_type = ?',
           year, month, about_id, about_type])
      elsif year
        debates = find(:all,
            :conditions => ['year(date) = ? and about_id = ? and about_type = ?',
            year, about_id, about_type])
      else
        debates = find_all_by_about_id_and_about_type(about_id, about_type)
      end

      debates
    end

    def find_by_date_and_index(date, index)
      find_by_index(date.year, date.month, date.day, index)
    end

    def find_by_index(year, month, day, index)
      month = mmm_to_mm month if month
      if index
        date = year+'-'+month+'-'+day
        debates = find_all_by_date_and_debate_index(date, index.to_i)

        debate = remove_duplicates(debates, false)[0]

        raise ActiveRecord::RecordNotFound.new('ActiveRecord::RecordNotFound: date ' + date + ' index ' + index.to_i.to_s + '   ' + debates.to_s) unless debate
        debate
      elsif day
        find_all_by_date(year+'-'+month+'-'+day, :order => "id")
      elsif month
          find(:all,
            :conditions => ['year(date) = ? and month(date) = ?', year, month],
            :order => "id")
      else
          find(:all,
            :conditions => ['year(date) = ?', year],
            :order => "id")
      end
    end

    def find_by_date(year, month, day)
      find_by_index(year, month, day, nil) # Finds debates by date, ordered by ascending date
    end

    def match name
      find(:all, :conditions => "name like '%#{name}%'", :order => "date DESC")
    end

    def get_by_type type, debates
      debates.select {|d| d.publication_status == type}.group_by {|d| d.date}.to_hash
    end

    def remove_duplicates debates, exclude_bill_parents=true
      uncorrected = get_by_type 'U', debates
      advance = get_by_type 'A', debates
      final = get_by_type 'F', debates
      remove_duplicates_using uncorrected, advance, final, exclude_bill_parents
    end

    def remove_duplicates_using uncorrected, advance, final, exclude_bill_parents=true
      # puts uncorrected.size.to_s + ' ' + advance.size.to_s + ' ' + final.size.to_s
      final = final.to_hash if final.is_a?(ActiveSupport::OrderedHash)
      advance = advance.to_hash if advance.is_a?(ActiveSupport::OrderedHash)
      uncorrected = uncorrected.to_hash if uncorrected.is_a?(ActiveSupport::OrderedHash)

      final.each_key do |date|
        advance.delete date
        uncorrected.delete date
      end

      # puts uncorrected.size.to_s + ' ' + advance.size.to_s + ' ' + final.size.to_s
      advance.each_key do |date|
        uncorrected.delete date
      end

      # puts uncorrected.size.to_s + ' ' + advance.size.to_s + ' ' + final.size.to_s
      debates = (uncorrected.values << advance.values << final.values).flatten.sort {|a,b| b.date <=> a.date}

      if exclude_bill_parents
        bill_debates = debates.select {|d| d.is_a? BillDebate and d.sub_debates.size > 0}
        debates = debates.delete_if {|d| bill_debates.include? d }
      end
      debates
    end

    def to_num_str num
      (num < 10) ? "0#{num}" : num.to_s
    end

    def mm_to_mmm mm
      Debate::MONTHS_LC[mm.to_i - 1]
    end

    def mmm_to_mm mmm
      mm = (Debate::MONTHS_LC.index(mmm) + 1).to_s
    end

    def to_date_hash date
      { :year => date.year.to_s,
        :month => mm_to_mmm(date.month),
        :day => to_num_str(date.mday) }
    end

    def get_debates_by_name debates
      debates = remove_duplicates debates
      debates_by_name = debates.group_by {|d| d.name.split('—')[0].sub('Third Readings','Third Reading')}
      debates_by_name.values.each do |list|
        list.sort! do |a,b|
          comparison = b.date <=> a.date
          if comparison == 0
            comparison = b.id <=> a.id
          end
          comparison
        end
      end

      names = debates_by_name.keys.sort do |a,b|
        debate = debates_by_name[a]
        other_debate = debates_by_name[b]
        comparison = other_debate.first.date <=> debate.first.date
        if comparison == 0
          comparison = debate.first.id <=> other_debate.first.id
        end
        comparison
      end

      return debates_by_name, names
    end
  end

  def make_category
  end

  def find_by_candidate_category
  end

  def create_url_slug
    populate_url_slug make_url_slug_text.gsub(' and ',' ')
    self.url_slug
  end

  def populate_url_slug slug_text
    self.url_slug = make_slug(slug_text) do |candidate_slug|
      non_numbered_slug = !candidate_slug[/_\d+$/]

      duplicate = find_by_candidate_slug candidate_slug
      if non_numbered_slug
        if duplicate
          duplicate.url_slug = "#{duplicate.url_slug}_1"
          duplicate.save!
        else
          duplicate = find_by_candidate_slug "#{candidate_slug}_1"
        end
      end
      duplicate
    end unless slug_text.blank?
  end

  def is_uncorrected?
    publication_status == 'U'
  end

  def is_advance?
    publication_status == 'A'
  end

  def is_final?
    publication_status == 'F'
  end

  def short_name
    (name.size < 35) ? name : "#{name[0..35]}..."
  end

  def year
    date.year.to_s
  end

  def month
    Debate.mm_to_mmm date.month
  end

  def day
    Debate.to_num_str date.day
  end

  def index
    Debate.to_num_str debate_index
  end

  def date_hash
    {:year => year, :month => month, :day => day}
  end

  def calendar_hash
    {:year => date.year, :month => date.month, :day => date.day}
  end

  def id_hash
    hash = {}.merge(date_hash)
    hash.merge!(:url_category => url_category) unless url_category.blank?
    hash.merge!(:url_slug => url_slug) unless url_slug.blank?
    hash.merge!({:index => index}) if (!url_category.blank? && !url_slug.blank?)
    hash
  end

  def next_debate_id_hash
    begin
      debate = Debate.find_by_index year, month, day, next_index
      return nil unless debate
    rescue Exception => e
      return nil
    end

    case debate
      when BillDebate
        debate.sub_debates.empty? ? debate.id_hash : debate.sub_debates[0].id_hash
      when OralAnswers
        debate.sub_debates[0].id_hash
      else
        debate.id_hash
    end
  end

  def prev_debate_id_hash
    begin
      can_have_previous = (index != '01') && !(index == '02' && self.is_a?(SubDebate) && parent.sub_debates.size == 1)
      return nil unless can_have_previous
      prev_index = Debate.to_num_str index.to_i-1
      debate = Debate.find_by_index year, month, day, prev_index
      return nil unless debate
    rescue Exception => e
      return nil
    end

    case debate
      when BillDebate, OralAnswers
        debate.prev_debate_id_hash
      when OralAnswer
        debate.id_hash
      when SubDebate
        parent = debate.debate
        if parent.is_a? BillDebate || parent.sub_debates.size != 1
          debate.id_hash
        else
          parent.id_hash
        end
      else
        debate.id_hash
    end
  end

  def contribution_id contribution
    anchor = nil

    if contributions and contributions.include? contribution
      anchor = (contributions.index(contribution) + 1).to_s
    elsif sub_debates and sub_debates.size > 0
      index = 1
      sub_debates.each do |sub_debate|
        anchor = sub_debate.contribution_index(contribution)
        if anchor
          anchor = (anchor+1).to_s
          break
        else
          index = index.next
        end
      end
    end

    anchor
  end

  def date_to_s
    date_str = date.strftime "%d %b %Y"
    date_str = date_str[1, date_str.length - 1] if date_str.index('0') == 0
    date_str
  end

  def title_name s=':'
    name
  end

  def title separator=':'
    %Q[#{title_name}#{separator} #{date_to_s}#{separator} NZ Parliament]
  end

  def votes
    contributions.select(&:is_vote?).collect(&:vote)
  end

  def geonames
    contributions.collect(&:geonames).flatten.uniq
  end

  CACHE_ROOT = RAILS_ROOT + '/tmp/cache/views/theyworkforyou.co.nz'

  protected

    def uncache path
      if File.exist?(path)
        puts 'deleting: ' + path.sub(Debate::CACHE_ROOT, '')
        File.delete(path)
      end
    end

    def expire_cached_pages
      return unless ActionController::Base.perform_caching

      self.contributions.each do |contribution|
        if (mp = contribution.mp)
          uncache "#{Debate::CACHE_ROOT}/mps/#{mp.id_name}.cache"
        end
      end

      hash = id_hash
      year = hash[:year]
      month = hash[:month]
      day = hash[:day]
      index = hash[:index]
      index_path = "#{year}/#{month}/#{day}/#{index}"

      path = nil
      if hash.has_key? :portfolio_url
        uncache "#{CACHE_ROOT}/portfolios.cache"
        path = "#{CACHE_ROOT}/portfolios/#{hash[:portfolio_url]}/#{index_path}.cache"
      elsif hash.has_key? :bill_url
        uncache "#{CACHE_ROOT}/bills.cache"
        path = "#{CACHE_ROOT}/bills/#{hash[:bill_url]}/#{index_path}.cache"
      elsif hash.has_key? :committee_url
        path = "#{CACHE_ROOT}/committees/#{hash[:committee_url]}/#{index_path}.cache"
      else
        path = "#{CACHE_ROOT}/debates/#{index_path}.cache"
      end

      uncache path
      uncache path.sub("/#{index}", '')
      uncache path.sub("/#{day}/#{index}", '')
      uncache path.sub("/#{month}/#{day}/#{index}", '')
      uncache path.sub("/#{index_path}", '')

      unless path.include?('debates')
        uncache CACHE_ROOT + '/debates.cache'
      end

      unless debate_topics.blank?
        debate_topics.each do |debate_topic|
          if debate_topic.topic.is_a? Bill
            path = "#{CACHE_ROOT}/bills/#{debate_topic.topic.url}.cache"
            uncache path
          end
        end
      end
      uncache CACHE_ROOT + '/index.cache'
    end

end
