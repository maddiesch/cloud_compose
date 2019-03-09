require 'pathname'

module PathHelpers
  def root_path
    Pathname.new(File.expand_path('../../../', __dir__))
  end

  def template_path(*args)
    root_path.join('spec', 'support', 'templates', *args)
  end
end

RSpec.configure do |config|
  config.include(PathHelpers)
end
