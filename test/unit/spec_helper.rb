require 'cookbook/development/test/unit/chefspec'

project_root = File.dirname( File.absolute_path( __FILE__ ))

libraries_dir = File.join( '', project_root, '/../../libraries/' )
Dir.glob( libraries_dir + '*.rb' ) { |file| require file }
