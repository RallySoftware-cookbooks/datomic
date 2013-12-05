include_recipe 'integration::install'

datomic_install node[:datomic][:user] do
  version '0.9.4324'
end

