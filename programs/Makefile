CC=/home/otso/llvm-project/clang_opt
BASIC_CC=/home/otso/llvm-project/build/bin/clang

LLC=/home/otso/llvm-project/build/bin/llc
CFLAGS=-Wall -Iinclude -O3 -g -I/usr/include/x86_64-linux-gnu/ -D__KERNEL__ -D__ASM_SYSREG_H -target bpf



all:
	$(CC) $(CFLAGS) -c hash.c -o hash.o
	$(BASIC_CC) $(CFLAGS) -c hash.c -o hash.no_opt.o

	$(CC) $(CFLAGS) -c drop.c -o drop.o
	$(BASIC_CC) $(CFLAGS) -c drop.c -o drop.no_opt.o

clean:
	rm -f *.o
