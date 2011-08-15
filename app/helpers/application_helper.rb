#$LastChangedDate: 2010-02-02 11:14:32 -0800 (Tue, 02 Feb 2010) $
#$LastChangedBy: asmyth $

module ApplicationHelper

  # flash helper
  def flash_helper
    flash_keys = [:notice, :warning, :message]
    flash_message = ''
    for key in flash_keys
      if flash[key]
        color = key == :warning ? 'red' : 'blue'
        heading = key == :warning ? 'Error:' : 'Message:'
        flash_message = flash_message + "<div id=\"flash\" style=\"border: 1px dashed #{color};\">#{heading} #{flash[key]}</div>"
      end
      flash[key] = nil;
    end
    flash_message
  end
  
  def copyright_year(start = 2009)
    now = Date.today.year
    "#{start}" + (now == start ? '' : "-#{now}")
  end

end
