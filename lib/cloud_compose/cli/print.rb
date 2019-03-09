require_relative '../template'

module CloudCompose
  module Cli
    class Print
      class << self
        def call(args)
          input_file = args.shift

          if input_file.nil?
            raise ArgumentError, 'Missing input path `cloud-compose print <input-path>`'
          end

          template_path = File.expand_path(input_file)
          template = CloudCompose::Template.new(template_path, File.expand_path('.'))
          STDOUT.puts(template.to_s)
        end
      end
    end
  end
end
