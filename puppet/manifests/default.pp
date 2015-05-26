
Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

host { 'affy-master.example.com': ip => '10.211.55.100' }
host { 'affy-slave1.example.com': ip => '10.211.55.101' }
host { 'affy-slave2.example.com': ip => '10.211.55.102' }

sysctl::value { "vm.swappiness": value => "10"}
