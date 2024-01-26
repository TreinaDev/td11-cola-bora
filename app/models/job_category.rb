class JobCategory
  attr_accessor :name, :description

  def initialize(name:, description: nil)
    @name = name
    @description = description
  end

  def self.build_categories(job_categories_json)
    job_categories_json.map do |category|
      new(name: category[:name], description: category[:description])
    end
  end
end
