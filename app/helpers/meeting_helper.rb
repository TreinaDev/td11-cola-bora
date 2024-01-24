module MeetingHelper
  def format_duration(duration)
    return "#{duration}m" if duration < 60
    return "#{duration / 60}h" if (duration % 60).zero?

    "#{duration / 60}h#{duration % 60}"
  end

  def link_to_address(address)
    return link_to address, address if address.include?('http')

    address
  end
end
