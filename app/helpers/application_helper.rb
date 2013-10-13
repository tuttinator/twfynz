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
end
