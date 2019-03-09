require_relative 'parser'

module CloudCompose
  class Config
    Import = Struct.new(:name, :path, :parameters)

    def initialize(config, root)
      @root = root
      params = CloudCompose::Parser.load_yaml(config)
      @config = params.fetch('$cloud_compose')
    end

    def partial?
      @config.fetch('partial', false) == true
    end

    def imports
      @config.fetch('imports', []).map do |obj|
        Import.new(
          obj.fetch('name'),
          import_path(obj),
          obj.fetch('parameters', {})
        )
      end
    end

    def parameters
      @config.fetch('parameters', {})
    end

    def required_parameters
      @config.fetch('require', [])
    end

    private

    def import_path(obj)
      File.expand_path(obj.fetch('path').to_s, @root)
    end
  end
end
