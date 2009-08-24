require 'cucumber/cli/options'
require 'cucumber/constantize'

module Cucumber
  module Cli
    class YmlLoadError < StandardError; end
    class ProfilesNotDefinedError < YmlLoadError; end
    class ProfileNotFound < StandardError; end

    class Configuration
      include Constantize
      
      attr_reader :options

      def initialize(out_stream = STDOUT, error_stream = STDERR)
        @out_stream   = out_stream
        @error_stream = error_stream
        @options = Options.new(@out_stream, @error_stream, :default_profile => 'default')
      end

      def parse!(args)
        @args = args
        @options.parse!(args)
        arrange_formats
        raise("You can't use both --strict and --wip") if strict? && wip?

        return @args.replace(@options.expanded_args_without_drb) if drb?

        set_environment_variables
      end

      def verbose?
        @options[:verbose]
      end

      def strict?
        @options[:strict]
      end

      def wip?
        @options[:wip]
      end

      def guess?
        @options[:guess]
      end

      def diff_enabled?
        @options[:diff_enabled]
      end

      def drb?
        @options[:drb]
      end

      def drb_port
        @options[:drb_port].to_i if @options[:drb_port]
      end

      def build_formatter_broadcaster(step_mother)
        return Formatter::Pretty.new(step_mother, nil, @options) if @options[:autoformat]
        formatters = @options[:formats].map do |format_and_out|
          format = format_and_out[0]
          out    = format_and_out[1]
          if String === out # file name
            unless File.directory?(out)
              out = File.open(out, Cucumber.file_mode('w'))
              at_exit do
                out.flush
                out.close
              end
            end
          end

          begin
            formatter_class = formatter_class(format)
            formatter_class.new(step_mother, out, @options)
          rescue Exception => e
            e.message << "\nError creating formatter: #{format}"
            raise e
          end
        end

        broadcaster = Broadcaster.new(formatters)
        broadcaster.options = @options
        return broadcaster
      end

      def formatter_class(format)
        if(builtin = Options::BUILTIN_FORMATS[format])
          constantize(builtin[0])
        else
          constantize(format)
        end
      end

      def step_defs_to_load
        requires = @options[:require].empty? ? require_dirs : @options[:require]
        files = requires.map do |path|
          path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
          path = path.gsub(/\/$/, '') # Strip trailing slash.
          File.directory?(path) ? Dir["#{path}/**/*"] : path
        end.flatten.uniq
        sorted_files = files.sort { |a,b| (b =~ %r{/support/} || -1) <=> (a =~ %r{/support/} || -1) }.reject{|f| f =~ /^http/}
        env_files = sorted_files.select {|f| f =~ %r{/support/env\..*} }
        files = env_files + sorted_files.reject {|f| f =~ %r{/support/env\..*} }
        remove_excluded_files_from(files)
        files.reject! {|f| !File.file?(f)}
        files.reject! {|f| File.extname(f) == '.feature' }
        files.reject! {|f| f =~ %r{/support/env\..*} } if @options[:dry_run]
        files
      end

      def feature_files
        potential_feature_files = paths.map do |path|
          path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
          path = path.chomp('/')
          File.directory?(path) ? Dir["#{path}/**/*.feature"] : path
        end.flatten.uniq
        remove_excluded_files_from(potential_feature_files)
        potential_feature_files
      end

    private

      def paths
        @options[:paths].empty? ? ['features'] : @options[:paths]
      end

      def set_environment_variables
        @options[:env_vars].each do |var, value|
          ENV[var] = value
        end
      end

      def arrange_formats
        @options[:formats] << ['pretty', @out_stream] if @options[:formats].empty?
        @options[:formats] = @options[:formats].sort_by{|f| f[1] == @out_stream ? -1 : 1}
        if @options[:formats].length > 1 && @options[:formats][1][1] == @out_stream
          raise "All but one formatter must use --out, only one can print to STDOUT"
        end
      end

      def remove_excluded_files_from(files)
        files.reject! {|path| @options[:excludes].detect {|pattern| path =~ pattern } }
      end

      def feature_dirs
        paths.map { |f| File.directory?(f) ? f : File.dirname(f) }.uniq
      end

      def require_dirs
        feature_dirs + Dir['vendor/{gems,plugins}/*/cucumber']
      end
      
    end

  end
end
