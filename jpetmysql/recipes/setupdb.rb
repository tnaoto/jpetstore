node[:deploy].each do |app_name, deploy|

  file "/tmp/jpetstore-mysql-schema.sql" do
     mode 00644
  end

  file "/tmp/jpetstore-mysql-dataload.sql" do
      mode 00644
  end

  mysql_command = "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]}"

  execute "execute-query" do
     command "#{mysql_command} < /tmp/jpetstore-mysql-schema.sql"
     not_if "#{mysql_command} -e 'SHOW TABLES' | grep #{node[:mysql][:dbtable]}"
     action :run
  end

  execute "execute-query-load" do
     command "#{mysql_command} < /tmp/jpetstore-mysql-dataload.sql"
     not_if "#{mysql_command} -e 'SHOW TABLES' | grep #{node[:mysql][:dbtable]}"
     action :run
  end
end
