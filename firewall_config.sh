#！/bin/bash
systemctl start firewalld
port_list=(11116 11111)
result='fail'
for port in "${port_list[@]}"; do
	result=$(firewall-cmd --add-port=${port}/tcp --permanent)
done

result=$(firewall-cmd --reload)
if (("$result"=="success"))
then
	echo 'success'
else
	echo 'fail'
fi
