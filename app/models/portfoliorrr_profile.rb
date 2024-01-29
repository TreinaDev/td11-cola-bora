class PortfoliorrrProfile
  attr_accessor :id, :name, :job_category

  def initialize(id:, name:, job_category:)
    @id = id
    @name = name
    @job_category = job_category
  end

  def self.all
    url = 'http://localhost:8000/api/v1/users'
    fetch_portfoliorrr_profiles(url)
  end

  def self.find(query)
    url = "http://localhost:8000/api/v1/users?search=#{query}"
    fetch_portfoliorrr_profiles(url)
  end

  def self.fetch_portfoliorrr_profiles(url)
    response = Faraday.get(url)

    return [] unless response.success?

    json = JSON.parse(response.body, symbolize_names: true)[:data]
    json.map do |portfoliorrr_profile|
      new(id: portfoliorrr_profile[:id], name: portfoliorrr_profile[:name],
          job_category: portfoliorrr_profile[:job_category])
    end
  rescue Faraday::ConnectionFailed
    []
  end

  private_class_method :fetch_portfoliorrr_profiles
end
