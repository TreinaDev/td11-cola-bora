class JobCategory
  attr_accessor :name, :description

  def initialize(name:, description:)
    @name = name
    @description = description
  end
end
