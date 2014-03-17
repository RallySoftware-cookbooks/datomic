datomic 'start datomic' do
  datomic_user_name node[:datomic][:user]
  action :start
end