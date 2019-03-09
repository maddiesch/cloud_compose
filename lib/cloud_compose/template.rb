require 'pathname'
require 'time'
require 'digest'

require_relative 'parser'
require_relative 'config'
require_relative 'processor'

module CloudCompose
  class Template
    IMPORT_MERGE_KEYS = %w[
      Metadata
      Parameters
      Mappings
      Conditions
      Transform
      Resources
      Outputs
    ].freeze

    class Error < StandardError; end

    Partial = Struct.new(:name, :template, :parameters) do
      def context
        Hash(parameters).merge('name' => name)
      end
    end

    attr_reader :root, :config, :content, :file_name

    def initialize(path, pwd)
      @pwd = pwd
      @file_name = File.basename(path)
      @root = Pathname.new(File.dirname(path))
      content = File.read(path)
      @checksum = Digest::SHA256.hexdigest(content)
      parts = content.split(/^---/, 3)
      @config = CloudCompose::Config.new(parts[1], @root)
      @content = parts[2]
    end

    def to_h
      template_body = create_hash(parameters)
      imported.each do |imp|
        formatted_imp = imp.template.send(:create_hash, imp.context)
        merge_imported(template_body, formatted_imp, imp.name)
      end

      template_body.keys.each do |key|
        template_body.delete(key) if template_body[key].empty?
      end

      template_body
    end

    def to_s
      yaml = CloudCompose::Parser.dump_yaml(to_h)

      <<~EOF
        # This Template was generated on #{Time.now.utc.iso8601} by CloudCompose #{CloudCompose::VERSION}
        #
        # Structure
        #{description(0)}
        #
        # Integrity
        #{checksum_print}
        #
        #{yaml}
      EOF
    end

    def imported
      preload_imports!
      @imported
    end

    def parameters
      @config.parameters
    end

    def required_parameters
      @config.required_parameters
    end

    def description(depth)
      callouts = depth.zero? ? '├─' : '↳'
      leading = depth.zero? ? '' : '|'
      padding = ' ' * depth
      joined = imported.map { |i| i.template.description(depth + 2) }
      [
        "# #{leading}#{padding}#{callouts} #{working_path}/#{file_name}",
        *joined
      ].join("\n")
    end

    def checksums
      return @checksums if @checksums

      checksums = {}
      checksums["#{working_path}/#{file_name}"] = @checksum
      imported.each do |imp|
        imp.template.checksums.each do |key, value|
          checksums[key] = value
        end
      end
      @checksums = checksums
      @checksums
    end

    private

    def checksum_print
      checksums.keys.sort.map do |key|
        "#   #{checksums[key]} ✓ #{key}"
      end.join("\n")
    end

    def working_path
      root.to_s.gsub("#{@pwd}/", '')
    end

    def merge_imported(body, imported, name)
      IMPORT_MERGE_KEYS.each do |merge_key|
        current = body.fetch(merge_key, {})
        imported_current = imported.fetch(merge_key, {})
        imported_current.keys.each do |merging|
          next unless current.key?(merging)

          raise Error, "Template #{file_name} already contains a key #{merge_key}.#{merging}. Merging from #{name}"
        end
        body[merge_key] = current.merge(imported_current)
      end
    end

    def create_hash(context)
      CloudCompose::Parser.load_yaml(
        CloudCompose::Processor.preprocess(content, context)
      )
    end

    def preload_imports!
      return if defined?(@imported)

      @imported = @config.imports.map do |imported|
        create_template(imported)
      end
    end

    def validate_parameters!(imported, full_params, required)
      required.each do |key|
        next if full_params.key?(key)

        raise Error, "Missing Required Parameter #{key} in #{imported.name}"
      end
    end

    def create_template(imported)
      template = CloudCompose::Template.new(imported.path, @pwd)
      raise Error, "Template #{File.basename(imported.path)} imported from #{@file_name} is not a partial" unless template.config.partial?

      full_params = parameters.merge(imported.parameters).merge(template.parameters)

      validate_parameters!(imported, full_params, template.required_parameters)

      Partial.new(
        imported.name,
        template,
        full_params
      )
    end
  end
end
