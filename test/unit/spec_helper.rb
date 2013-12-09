require 'cookbook/development/test/unit/chefspec'

project_root = File.dirname( File.absolute_path( __FILE__ ))

libraries_dir = File.expand_path(File.join(project_root, '..', '..', 'libraries'))
libraries = File.join(libraries_dir, '*.rb')

Dir.glob( libraries ) { |file| require file.gsub!(/\.rb/, '') }
