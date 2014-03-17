datomic 'install datomic' do
  datomic_user_name node[:datomic][:user]
  version node[:datomic][:version]
end