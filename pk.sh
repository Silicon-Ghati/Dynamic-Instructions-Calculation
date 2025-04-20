while :
do
	cat /tmp/gdberr | tail -n 1 | grep "is not being run" >/dev/null
	if [ $? -eq 0 ]
	then
		kill $(ps aux | grep gdb_instructions | head -n 1 | awk '{$1=$1};1' | cut -d " " -f 2 )
		break
	fi
done
