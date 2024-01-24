module MeetingsHelper
  def format_duration(duration)
    return "#{duration}m" if duration < 60
    return "#{duration / 60}h" if (duration % 60).zero?

    "#{duration / 60}h#{duration % 60}"
  end
end
