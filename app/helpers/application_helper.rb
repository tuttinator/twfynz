# encoding: UTF-8

require 'date_extension'

module ApplicationHelper
  def calendar_nav current_date, heading_prefix=''
    sitting_days = SittingDay.find(:all)
    first_sitting = sitting_days.select{|s| s.date.year == current_date.year && s.date.month == current_date.month}.first

    if first_sitting
      calendar(:year => current_date.year, :month => current_date.month, :heading_prefix => heading_prefix) do |date|
        day = date.matching_day(sitting_days)
        unless day.nil?
          display = date.has_debates? ? on_date_debates_url(date) : date.mday
          css_class = "sitting-day"
          css_class = css_class + ' current-day' if date.mday == current_date.day
          [display, {:class => "sitting-day", :title => 'Sitting day'+title_for_sitting_day(day)}]
        else
          [date.mday, nil]
        end
      end
    else
      month = Date::MONTHNAMES[current_date.month][0..2]
      %Q|<table class="calendar" border="0" cellpadding="0" cellspacing="0"><thead><tr class="monthName"><th>#{heading_prefix} #{month} #{current_date.year}</th></tr></thead><tbody><tr><td style="text-align:center">(no sittings in  #{month} #{current_date.year})</td></tr></tbody></table>|
      ""
    end
  end

  def party_logo_small party, polls=nil
    if party.logo
      if polls
        factor = polls * 6
        height = [30 * factor, 30].min.to_i
        if height < 10
          ''
        else
          width = [60 * factor, 60].min.to_i
          image_tag('parties/'+party.logo, :class => 'logo_small', :alt => "Logo for #{party.name}", :size=>"#{width}x#{height}")
        end
      else
        image_tag('parties/'+party.logo, :class => 'logo_small', :alt => "Logo for #{party.name}", :size=>'60x30')
      end
    else
      ''
    end
  end

  def portrait mp, new=false
    if mp.image.blank?
      if mp.img.blank?
        if mp.member && mp.member.image
          src = mp.member.image
        elsif mp.members.last && mp.members.last.image
          src = mp.members.last.image
        else
          src = nil
        end
      else
        src = mp.img
      end
    else
      src = mp.image
    end
    src ? image_tag('mps/'+src, :size => '49x59', :class => 'portrait', :alt => mp.last) : ''
  end

  def current_user
    session[:user]
  end

  def about_title about
    if about
      about.full_name + ': ' + about.class.to_s.gsub(/([a-z])([A-Z])/, '\1 \2') + ': NZ Parliament '
    else
      'Parliamentary Debates: '
    end
  end

  def bill_type bill
    case bill.class.to_s
      when 'GovernmentBill'
        'Government bill'
      when 'MembersBill'
        "Member's bill"
      when 'PrivateBill'
        'Private bill'
      when 'LocalBill'
        'Local bill'
      else
        ''
    end
  end

  def link_to_recent_debate debate, include_date=false
    if (debate.is_a? BillDebate)
      text = debate.sub_debate.name
    elsif (debate.is_a? SubDebate and !debate.is_a?(OralAnswer))
      text = debate.parent.name + ' <br /> ' + debate.name
    elsif debate.is_a? OralAnswer
      text = debate.title_name
    elsif debate.instance_of?(ParentDebate) && debate.sub_debate
      text = debate.name + ' - ' + debate.sub_debate.name
    else
      text = debate.name
    end
    url = get_url(debate)
    date = include_date ? %Q[<span class="inform_date">#{format_date(debate.date)}</span>] : ''
    link_to(text, url) + ' ' + date
  end

  def format_date date
    text = date.strftime "%d %b %Y"
    text = text[1..(text.size-1)] if text.size > 0 and text[0..0] == '0'
    text
  end

  def get_url debate
    if debate.is_a? OralAnswer
      if debate.about_type == Portfolio.name
        show_portfolio_debate_url(debate.id_hash)
      elsif (debate.about_type == Bill.name && debate.about_id)
        show_bill_debate_url(debate.id_hash)
      elsif debate.about_type == Committee.name
        show_committee_debate_url(debate.id_hash)
      else
        show_debate_url(debate.id_hash)
      end
    elsif debate.is_a? OralAnswers and debate.sub_debates.size > 0
      get_url debate.sub_debates.sort_by(&:debate_index)[0]
    elsif (debate.is_a? SubDebate and debate.about_type == Bill.name)
      show_bill_debate_url(debate.id_hash)
    elsif (debate.is_a?(BillDebate) && debate.sub_debate.about_id)
      show_bill_debate_url(debate.sub_debate.id_hash)
    elsif debate.is_a?(ParentDebate)
      show_debate_url(debate.sub_debate.id_hash)
    else
      show_debate_url(debate.id_hash)
    end
  end

  def title_for_sitting_day day
    title = ''
    if day.has_final?
      title = ' with final debates'
    elsif day.has_advance?
      title = ' with advance debates'
    elsif day.has_oral_answers?
      title = ' with uncorrected oral answers'
    end
    title
  end
end
