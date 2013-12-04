if defined?(ChefSpec)
  def create_datomic_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:datomic_user, :create, resource_name)
  end

  def perform_datomic_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:datomic_install, :install, resource_name)
  end
end
