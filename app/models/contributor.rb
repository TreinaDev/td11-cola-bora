class Contributor
  attr_accessor :id, :name, :job_category

  def initialize(id:, name:, job_category:)
    @id = id
    @name = name
    @job_category = job_category
  end

  def self.all
    url = 'http://localhost:8000/api/v1/users'
    response = Faraday.get(url)

    return {} if response.status == 500

    json = JSON.parse(response.body, symbolize_names: true)[:data]
    result = json.map do |contributor|
      new(id: contributor[:id], name: contributor[:name], job_category: contributor[:job_category])
    end

    result
  end

  def self.find(query)
    url = "http://localhost:8000/api/v1/users?search=#{query}"
    response = Faraday.get(url)

    json = JSON.parse(response.body, symbolize_names: true)[:data]
    result = json.map do |contributor|
      new(id: contributor[:id], name: contributor[:name], job_category: contributor[:job_category])
    end

    result
  end
end