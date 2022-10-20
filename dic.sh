#!/usr/bin/sh

echo "set disassembly-flavor intel

define hook-stop
x/1i \$rip
end" > ~/.gdbinit

./gdb_instructions | gdb $1 2>/dev/null | grep "=>" | cut -c 10- > $1_ins

echo Total Number Of Instructions \: $(cat $1_ins | wc -l)
echo ""
echo Number of Instructions of Different Types \:

i=0

cat $1_ins | cut -d ":" -f 2 | awk '{$1=$1};1' | cut -d " " -f 1 | sort | uniq | while read operand
do
	echo -n '\t'$operand : $(cat $1_ins | cut -d ":" -f 2 | awk '{$1=$1};1' | cut -d " " -f 1 | grep $operand | wc -l)'\t\t'
	i=$((($i)+1))
	if [ $((($i)%3)) -eq 0 ]
	then
		echo '\n'
	fi
done

echo ""
if [ $((($(cat $1_ins | cut -d ":" -f 2 | awk '{$1=$1};1' | cut -d " " -f 1 | sort | uniq | wc -l))%3)) -eq 0 ]
then
	echo "">/dev/null
else
	echo ""
fi