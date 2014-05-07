sqlfiles.each do |sqlfile|
  mysql_command = "/usr/bin/mysql -u #{deploy[:database][:username]} #{node[:mysql][:server_root_password].blank? ? '' : "-p#{node[:mysql][:server_root_password]}"}"

  execute "execute-query" do
     command "#{mysql_command} < /tmp/jpetstore-mysql-schema.sql"
  end
  execute "execute-query-load" do
     command "#{mysql_command} < /tmp/jpetstore-mysql-dataload.sql"
  end
end
