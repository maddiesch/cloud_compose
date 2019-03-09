require 'pry'

module CloudCompose
  module Cli
    class Build
      class << self
        def call(args)
          input_file = args.shift

          if input_file.nil?
            raise ArgumentError, 'Missing input path `cloud-compose build <input-path>`'
          end

          template_path = File.expand_path(input_file)
          template = CloudCompose::Template.new(template_path, File.expand_path('.'))
          content = template.to_s

          file_name = File.basename(template_path)
          file_name.slice!(File.extname(file_name))
          file_name += '-build.yml'
          output_path = File.dirname(template_path)
          output_path += "/#{file_name}"

          File.open(output_path, 'w') do |f|
            f.write(content)
          end

          STDERR.puts "Built: #{output_path}"
        end
      end
    end
  end
end
