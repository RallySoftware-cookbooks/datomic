if defined?(ChefSpec)
  def create_datomic_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:datomic_user, :create, resource_name)
  end

  def install_datomic_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:datomic, :install, resource_name)
  end

  def stop_datomic_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:datomic, :stop, resource_name)
  end

  def start_datomic_instance(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:datomic, :start, resource_name)
  end
end
