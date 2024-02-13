class JobCategory
  attr_accessor :id, :name, :description

  def initialize(id:, name:, description: nil)
    @id = id
    @name = name
    @description = description
  end

  def self.all
    url = 'http://localhost:4000/api/v1/job_categories'
    fetch_job_categories(url)
  end

  def self.fetch_job_categories_by_project(project_job_categories)
    job_categories = []
    project_job_categories.each do |project_job_category|
      job_categories << JobCategory.find(project_job_category.job_category_id)
    end

    job_categories
  end

  def self.find(id)
    url = "http://localhost:4000/api/v1/job_categories/#{id}"
    response = Faraday.get(url)

    return {} unless response.success?

    job_category_json = JSON.parse(response.body, symbolize_names: true)[:data]
    new_job_category(job_category_json)
  rescue Faraday::ConnectionFailed
    {}
  end

  def self.build_categories(job_categories_json)
    job_categories_json.map do |category|
      new(id: category[:id], name: category[:title] || category[:name], description: category[:description])
    end
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

  private_class_method :fetch_job_categories, :new_job_category
end
