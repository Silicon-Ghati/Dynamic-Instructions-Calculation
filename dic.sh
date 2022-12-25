#!/usr/bin/sh

echo -n "" > $1_analysis
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
	echo "IyEvdXNyL2Jpbi9weXRob24zCgpwcmludCgic3RhcnRpIDwgaW5wdXRfZmlsZSIpCgpmb3IgaSBpbiByYW5nZSAoMTAwMDApOgoJcHJpbnQoInNpIikK" | base64 -d > gdb_instructions
	echo $2 | xargs -I{} sh -c "sed -i 's/input_file/{}/g' gdb_instructions"
elif [ $# -eq 1 ]
then
	echo "IyEvdXNyL2Jpbi9weXRob24zCgpwcmludCgic3RhcnRpIikKCmZvciBpIGluIHJhbmdlICgxMDAwMCk6CglwcmludCgic2kiKQo" | base64 -d > gdb_instructions
else
	echo "Usage : ./dic.sh binary input_file(optional)\nUse the input file if the program needs user input"
	exit
fi

chmod +x $1
chmod +x gdb_instructions

echo "[+] Analyzing the binary dynamically"
echo "[+] Parsing the instructions from the user application"
echo ""

./gdb_instructions | gdb $1 2>/dev/null | grep "=>" | cut -c 10- > $1_ins

echo "==================================="
echo "[+] Performing instruction analysis"
echo ""

echo Total Number Of Instructions \: $(cat $1_ins | wc -l) | tee -a $1_analysis
echo "" | tee -a $1_analysis
echo Number of Instructions of Different Types \: | tee -a $1_analysis

i=0

cat $1_ins | cut -d ":" -f 2 | awk '{$1=$1};1' | cut -d " " -f 1 | sort | uniq | while read operand
do
	echo -n '\t'
	echo -n $operand : $(cat $1_ins | cut -d ":" -f 2 | awk '{$1=$1};1' | cut -d " " -f 1 | grep $operand | wc -l) | tee -a $1_analysis
	echo -n ' \t\t'
	echo '' >> $1_analysis
	i=$((($i)+1))
	if [ $((($i)%3)) -eq 0 ]
	then
		echo ""
	fi
done

################################################################################################################################

cat templates/chartStart > $1_chart

cat $1_analysis | head -n $(($(cat $1_analysis |  wc -l) - 3)) | tail -n $(($(cat $1_analysis |  wc -l) - 6)) | sort -h --key 3 -r | while read line
do
        echo -n \[\'$(echo $line | cut -d ":" -f 1 | awk '{$1=$1};1')\'\, >> $1_chart
        echo $(echo $line | cut -d ":" -f 2)\]\, >> $1_chart
done

echo "['dummy',0]" >> $1_chart

cat templates/chartEnd >> $1_chart

################################################################################################################################

if [ $((($(cat $1_ins | cut -d ":" -f 2 | awk '{$1=$1};1' | cut -d " " -f 1 | sort | uniq | wc -l))%3)) -eq 0 ]
then
        echo "">/dev/null
else
        echo "" | tee -a $1_analysis
fi

echo ""
echo "" | tee -a $1_analysis
echo "======================="
echo "[+] Analyzing Branching\n"
echo -n "Number Of Branches : " | tee -a $1_analysis
echo $(cat $1_ins | grep -i "JA\|JAE\|JB\|JBE\|JC\|JCXZ\|JECXZ\|JRCXZ\|JE\|JG\|JGE\|JL\|JLE\|JNA\|JNAE\|JNB\|JNBE\|JNC\|JNE\|JNG\|JNGE\|JNL\|JNLE\|JNO\|JNP\|JNS\|JNZ\|JO\|JP\|JPE\|JPO\|JS\|JZ\|LOOP\|LOOPE\|LOOPNE\|LOOPNZ\|LOOPZ\|JMP\|CALL\|RET\|INT1\|INT3\|INTn\|INTO\|IRET\|IRETD\|IRETQ\|SYSCALL\|SYSRET\|SYSENTER\|SYSEXIT\|VMLAUNCH\|VMRESUME" | wc -l) | tee -a $1_analysis

echo ''
echo [+] Cleaning up

rm gdb_instructions
#Delete files older than 5 mins.
find static/dic_temp_files -mmin +5 -exec rm -f {} \;  
rm /tmp/gdberr
