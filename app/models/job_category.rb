class JobCategory
  attr_accessor :id, :name

  def initialize(name:)
    @id = id
    @name = name
  end

  def self.all
    url = 'http://localhost:8000/api/v1/job_categories'
    fetch_job_categories(url)
  end

  def self.build_categories(job_categories_json)
    job_categories_json.map do |category|
      new(id: category[:id], name: category[:name])
    end
  end
end
