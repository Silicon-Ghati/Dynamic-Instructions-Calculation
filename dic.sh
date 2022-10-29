#!/usr/bin/sh

file $1 2>/dev/null | grep 64-bit > /dev/null
if [ $? -eq 0 ]
then
	echo "set disassembly-flavor intel

define hook-stop
x/1i \$rip
end" > ~/.gdbinit
fi

file $1 2>/dev/null | grep 32-bit > /dev/null
if [ $? -eq 0 ]
then
        echo "set disassembly-flavor intel

define hook-stop
x/1i \$eip
end" > ~/.gdbinit
fi

if [ $# -eq 2 ]
then
	echo "IyEvdXNyL2Jpbi9weXRob24zCgpwcmludCgic3RhcnRpIDwgaW5wdXRfZmlsZSIpCgp3aGlsZShUcnVlKToKCXByaW50KCJzaSIpCg==" | base64 -d > gdb_instructions
	echo $2 | xargs -I{} sh -c "sed -i 's/input_file/{}/g' gdb_instructions"
elif [ $# -eq 1 ]
then
	echo "IyEvdXNyL2Jpbi9weXRob24zCgpwcmludCgic3RhcnRpIikKCndoaWxlKFRydWUpOgoJcHJpbnQoInNpIikK" | base64 -d > gdb_instructions
else
	echo "Usage : ./dic.sh binary input_file(optional)\nUse the input file if the program needs user input"
	exit
fi

chmod +x $1
chmod +x gdb_instructions

echo "[+] Analyzing the binary dynamically"
echo "[+] Parsing the instructions from the user application"
echo ""

./pk.sh $1&
./gdb_instructions | gdb $1 2>/tmp/gdberr | grep "=>" | cut -c 10- > $1_ins

echo "==================================="
echo "[+] Performing instruction analysis"
echo ""

echo Total Number Of Instructions \: $(cat $1_ins | wc -l)
echo ""
echo Number of Instructions of Different Types \:

i=0

cat $1_ins | cut -d ":" -f 2 | awk '{$1=$1};1' | cut -d " " -f 1 | sort | uniq | while read operand
do
	echo -n '\t'$operand : $(cat $1_ins | cut -d ":" -f 2 | awk '{$1=$1};1' | cut -d " " -f 1 | grep $operand | wc -l)' \t\t'
	i=$((($i)+1))
	if [ $((($i)%3)) -eq 0 ]
	then
		echo ""
	fi
done

if [ $((($(cat $1_ins | cut -d ":" -f 2 | awk '{$1=$1};1' | cut -d " " -f 1 | sort | uniq | wc -l))%3)) -eq 0 ]
then
        echo "">/dev/null
else
        echo ""
fi

echo ""
echo ""
echo "======================="
echo "[+] Analyzing Branching\n"
echo -n "Number Of Branches : "
echo $(cat $1_ins | grep -i "JA\|JAE\|JB\|JBE\|JC\|JCXZ\|JECXZ\|JRCXZ\|JE\|JG\|JGE\|JL\|JLE\|JNA\|JNAE\|JNB\|JNBE\|JNC\|JNE\|JNG\|JNGE\|JNL\|JNLE\|JNO\|JNP\|JNS\|JNZ\|JO\|JP\|JPE\|JPO\|JS\|JZ\|LOOP\|LOOPE\|LOOPNE\|LOOPNZ\|LOOPZ\|JMP\|CALL\|RET\|INT1\|INT3\|INTn\|INTO\|IRET\|IRETD\|IRETQ\|JMP\|CALL\|RET\|SYSCALL\|SYSRET\|SYSENTER\|SYSEXIT\|VMLAUNCH\|VMRESUME" | wc -l)

echo ''
echo [+] Cleaning up

rm gdb_instructions
#rm $1_ins
rm /tmp/gdberr