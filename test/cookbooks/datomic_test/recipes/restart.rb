datomic 'restart datomic' do
  datomic_user_name node[:datomic][:user]
  action :restart
end