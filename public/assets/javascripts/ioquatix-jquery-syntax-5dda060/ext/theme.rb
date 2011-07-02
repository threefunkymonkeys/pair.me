
class Theme
	def initialize(dst_dir, root = nil)
		@destination = dst_dir
		
		@includes = []
		@root = root
		
		@extends = {}
	end
	
	attr :includes
	
	def load_theme(theme_dir)
		# Themes which are relative paths are designed to reside in the themes subdirectory.
		unless File.directory?(theme_dir)
			theme_dir = File.join(@root, theme_dir)
		end
	
		unless File.directory?(theme_dir)
			raise StandardError.new("Could not find theme #{theme_dir}!")
		end
	
		$stderr.puts "Loading theme from #{theme_dir}..."
		theme_config_path = File.join(theme_dir, "config.yaml")
		config = {}
	
		# Is there a configuration file?
		if File.exist? theme_config_path
			config = YAML::load_file(theme_config_path)
		end
	
		# Load any dependencies recursively - if you have bad configuration this might
		# give you visions of infinity.
		if config['depends']
			config['depends'].each {|name| load_theme(name)}
		end
		
		if config['extends']
			config['extends'].each {|name,extension| @extends[name] = extension}
		end
		
		if config['includes']
			@includes.concat(config['includes'])
		end
	
		# Copy all the theme files
		FileUtils.cp_r(Dir.glob(theme_dir + "/*"), @destination)
	
		# Remove any files/directories that have been excluded
		if config['exclude']
			config['exclude'].each do |name|
				FileUtils.rm_rf(File.join(@destination, name))
			end
		end
	end
	
	def includes_for(path, place)
		case place
		when :prepend
			return @includes
		when :append
			if extension = @extends[File.basename(path)]
				return extension
			end
		end
		
		return []
	end
end
