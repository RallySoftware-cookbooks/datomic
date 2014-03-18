datomic 'upgrade datomic' do
  datomic_user_name node[:datomic][:user]
  version '0.9.4324'
  action :install
end

