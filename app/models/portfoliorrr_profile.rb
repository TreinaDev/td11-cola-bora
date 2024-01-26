class PortfoliorrrProfile
  attr_accessor :id, :name, :job_category, :email, :job_categories, :cover_letter

  def initialize(id:, name:, job_category:)
    @id = id
    @name = name
    @job_category = job_category
  end

  def self.all
    url = 'http://localhost:8000/api/v1/users'
    fetch_portfoliorrr_profiles(url)
  end

  def self.search(query)
    url = "http://localhost:8000/api/v1/users?search=#{query}"
    fetch_portfoliorrr_profiles(url)
  end

  def self.find(id)
    url = "http://localhost:8000/api/v1/users/#{id}"
    response = Faraday.get(url)

    return {} unless response.success?

    profile_json = JSON.parse(response.body, symbolize_names: true)[:data]
    profile = new_profile(profile_json)
    profile.build_details(profile_json)
  rescue Faraday::ConnectionFailed
    {}
  end

  def self.new_profile(profile_json)
    new(id: profile_json[:id],
        name: profile_json[:name],
        job_category: profile_json[:job_category])
  end

  def self.fetch_portfoliorrr_profiles(url)
    response = Faraday.get(url)

    return [] unless response.success?

    json = JSON.parse(response.body, symbolize_names: true)[:data]
    json.map { |portfoliorrr_profile| new_profile(portfoliorrr_profile) }
  rescue Faraday::ConnectionFailed
    []
  end

  def build_details(profile_json)
    @email = profile_json[:email]
    @cover_letter = profile_json[:profile][:cover_letter]
    @job_categories = build_categories(profile_json[:job_categories])
    self
  end

  private

  def build_categories(job_categories)
    job_categories.map do |category|
      JobCategory.new(name: category[:name], description: category[:description])
    end
  end

  private_class_method :fetch_portfoliorrr_profiles, :new_profile
end
