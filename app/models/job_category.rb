class JobCategory
  attr_accessor :id, :name

  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def self.all
    url = 'http://localhost:8000/api/v1/job_categories'
    fetch_job_categories(url)
  end

  def self.find(id)
    url = "http://localhost:8000/api/v1/job_categories/#{id}"
    response = Faraday.get(url)

    return {} unless response.success?

    job_category_json = JSON.parse(response.body, symbolize_names: true)[:data]
    job_category = new_job_category(job_category_json)
    job_category.build_categories(job_category_json)
  rescue Faraday::ConnectionFailed
    {}
  end

  def self.new_job_category(job_category_json)
    new(id: job_category_json[:id],
        name: job_category_json[:name])
  end

  def self.fetch_job_categories(url)
    response = Faraday.get(url)

    return [] unless response.success?

    json = JSON.parse(response.body, symbolize_names: true)[:data]
    json.map { |job_category| new_job_category(job_category) }
  rescue Faraday::ConnectionFailed
    []
  end

  def self.build_categories(job_categories_json)
    job_categories_json.map do |category|
      new(id: category[:id], name: category[:name])
    end
  end

  private_class_method :fetch_job_categories, :new_job_category
end
