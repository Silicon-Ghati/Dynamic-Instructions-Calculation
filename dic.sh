#!/usr/bin/sh

echo "set disassembly-flavor intel

define hook-stop
x/1i \$rip
end" > ~/.gdbinit

./gdb_instructions | gdb $1 2>/dev/null | grep "=>" | cut -c 10- > $1_ins

echo Total Number Of Instructions \: $(cat $1_ins | wc -l)
echo ""
