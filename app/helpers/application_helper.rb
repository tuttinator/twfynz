# encoding: UTF-8
module ApplicationHelper
  def calendar_nav current_date, heading_prefix=''
    sitting_days = SittingDay.find(:all)
    first_sitting = sitting_days.select{|s| s.date.year == current_date.year && s.date.month == current_date.month}.first

    if first_sitting
      calendar(:year => current_date.year, :month => current_date.month, :heading_prefix => heading_prefix) do |date|
        day = date.matching_day(sitting_days)
        unless day.nil?
          display = date.has_debates? ? to_show_debates_on_date_url(date) : date.mday
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
end
