class PortifoliorrrProfile
  attr_accessor :id, :name, :job_category, :email, :job_categories, :cover_letter

  def initialize(id:, name:, job_category:)
    @id = id
    @name = name
    @job_category = job_category
  end

  def self.all
    url = 'http://localhost:8000/api/v1/users'
    fetch_portifoliorrr_profiles(url)
  end

  def self.search(query)
    url = "http://localhost:8000/api/v1/users?search=#{query}"
    fetch_portifoliorrr_profiles(url)
  end

  def self.find(id)
    url = "http://localhost:8000/api/v1/users/#{id}"
    response = Faraday.get(url)

    return {} unless response.success?

    profile_json = JSON.parse(response.body, symbolize_names: true)[:data]

    profile = new(id: profile_json[:id],
                  name: profile_json[:name],
                  job_category: profile_json[:job_category])

    build_details(profile, profile_json)
  rescue Faraday::ConnectionFailed
    []
  end

  def self.build_details(profile, profile_json)
    profile.email = profile_json[:email]
    profile.cover_letter = profile_json[:profile][:cover_letter]
    profile.job_categories = build_categories(profile_json[:job_categories])
    profile
  end

  def self.build_categories(job_categories)
    job_categories.map do |category|
      JobCategory.new(name: category[:name], description: category[:description])
    end
  end

  def self.fetch_portifoliorrr_profiles(url)
    response = Faraday.get(url)

    return [] unless response.success?

    json = JSON.parse(response.body, symbolize_names: true)[:data]
    json.map do |portifoliorrr_profile|
      new(id: portifoliorrr_profile[:id], name: portifoliorrr_profile[:name],
          job_category: portifoliorrr_profile[:job_category])
    end
  rescue Faraday::ConnectionFailed
    []
  end

  private_class_method :fetch_portifoliorrr_profiles
end
