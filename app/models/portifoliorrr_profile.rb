class PortifoliorrrProfile
  attr_accessor :id, :name, :job_category

  def initialize(id:, name:, job_category:)
    @id = id
    @name = name
    @job_category = job_category
  end

  def self.all
    url = 'http://localhost:8000/api/v1/users'
    fetch_portifoliorrr_profiles(url)
  end

  def self.find(query)
    url = "http://localhost:8000/api/v1/users?search=#{query}"
    fetch_portifoliorrr_profiles(url)
  end

  def self.fetch_portifoliorrr_profiles(url)
    response = Faraday.get(url)

    return [] unless response.success?

    json = JSON.parse(response.body, symbolize_names: true)[:data]
    json.map do |portifoliorrr_profile|
      new(id: portifoliorrr_profile[:id], name: portifoliorrr_profile[:name],
          job_category: portifoliorrr_profile[:job_category])
    end
  end

  private_class_method :fetch_portifoliorrr_profiles
end
