node[:deploy].each do |app_name, deploy|

  cookbook_file "/tmp/jpetstore-mysql-schema.sql" do
     source "jpetstore-mysql-schema.sql"
  end

  cookbook_file "/tmp/jpetstore-mysql-dataload.sql" do
     source "jpetstore-mysql-dataload.sql"
  end

  mysql_command = "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]}"

  execute "execute-query" do
     command "#{mysql_command} < /tmp/jpetstore-mysql-schema.sql"
     not_if "#{mysql_command} -e 'SHOW TABLES' | grep #{deploy[:database][:database]}"
     action :run
  end

  execute "execute-query-load" do
     command "#{mysql_command} < /tmp/jpetstore-mysql-dataload.sql"
     not_if "#{mysql_command} -e 'SHOW TABLES' | grep #{deploy[:database][:database]}"
     action :run
  end
end
