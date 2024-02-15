class PortfoliorrrProfile
  attr_accessor :id, :name, :email, :job_categories, :cover_letter, :professional_infos, :education_infos

  def initialize(id:, name:, job_categories:)
    @id = id
    @name = name
    @job_categories = job_categories
  end

  def self.all
    url = 'http://localhost:4000/api/v1/profiles'
    fetch_portfoliorrr_profiles(url)
  end

  def self.search(query)
    url = "http://localhost:4000/api/v1/profiles?search=#{query}"
    fetch_portfoliorrr_profiles(url)
  end

  def self.find(id)
    url = "http://localhost:4000/api/v1/profiles/#{id}"
    response = Faraday.get(url)

    return {} unless response.success?

    profile_json = JSON.parse(response.body, symbolize_names: true)[:data]
    profile = new_profile(profile_json)
    profile.build_details(profile_json)
    profile
  rescue Faraday::ConnectionFailed
    {}
  end

  def self.new_profile(profile_json)
    new(id: profile_json[:profile_id] || profile_json[:user_id],
        name: profile_json[:full_name],
        job_categories: JobCategory.build_categories(profile_json[:job_categories]))
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
    @cover_letter = profile_json[:cover_letter]
    @professional_infos = profile_json[:professional_infos]
    @education_infos = profile_json[:education_infos]
    convert_dates(@professional_infos, @education_infos)
  end

  private_class_method :fetch_portfoliorrr_profiles, :new_profile

  private

  def convert_dates(*attribute_array)
    attribute_array.flatten.each do |attribute|
      attribute[:start_date] = Date.parse(attribute[:start_date])
      attribute[:end_date] = Date.parse(attribute[:end_date])
    end
  end
end
