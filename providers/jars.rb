use_inline_resources

action :install do
  delete_old_jars(current_resource, new_resource)
  download_new_jars(new_resource)
  write_manifest(new_resource.jars)
end

def delete_old_jars(current_resource, new_resource)
  determine_deletes(current_resource.jars, new_resource.jars).each do |jar|
    path = URI.parse(jar).path
    jar_file_name = ::File.basename(path)

    file ::File.join(new_resource.lib_dir, jar_file_name) do
      action :delete
    end
  end
end

def download_new_jars(new_resource)
  new_resource.jars.each do |jar|
    path = URI.parse(jar).path
    jar_file_name = ::File.basename(path)

    remote_file ::File.join(new_resource.lib_dir, jar_file_name) do
      source jar
      owner new_resource.owner
      group new_resource.group
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::DatomicJars.new(@new_resource.name)
  @current_resource.jars(compute_from_manifest)
  @current_resource.lib_dir(new_resource.lib_dir)
  @current_resource
end

def compute_from_manifest
  manifest_file = ::File.join(new_resource.lib_dir, 'EXTRA_JARS.MF')
  JSON.parse(::File.read(manifest_file)) rescue []
end

def determine_deletes(existing_jars, new_jars)
  existing_jars - new_jars
end

def write_manifest(jars)
  manifest_file = ::File.join(new_resource.lib_dir, 'EXTRA_JARS.MF')
  new_manifest = jars.to_json
  old_manifest = ::File.read(manifest_file) rescue nil

  file manifest_file do
    content new_manifest
    not_if { new_manifest == old_manifest }
  end
end
