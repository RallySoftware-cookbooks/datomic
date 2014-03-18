datomic 'stop datomic' do
  datomic_user_name node[:datomic][:user]
  action :stop
end