Running IR passes with OPT

Go to root directory, run
```
make
```

This creates a fusion.so and and align.so

./build/bin/opt -load-pass-plugin=./align.so -passes=bpfalign tunnel.ll -o tunnel.bc
./build/bin/opt -load-pass-plugin=./fusion.so -passes=bpffusion tunnel.ll -o tunnel.bc

Both:

./build/bin/opt -load-pass-plugin=./align.so -load-pass-plugin=./fusion.so -passes="bpfalign,bpffusion" tunnel.ll -o tunnel.bc




sudo bpftool prog show



sudo bpftool prog profile pinned /sys/fs/bpf/xdp_bench_prog cycles instructions llc_misses


sudo bpftool prog profile name hashfilter cycles




Running suricata:


Linux kernel bpf_stats_enabled


// Run the program
uv tset run
//
bpf prog


Preliminary test:

Example:
With our opts:
uv run test.py -i compiled_benchmarks/opt/suricata_xdp_filter.bpf

- 16428425768 run_cnt 2000000000
- 16372839504 run_cnt 2000000000
- 16179436909 run_cnt 2000000000
- 16311188267
- 16307247121

24.7782204265
8.163450363499999


No opts:
uv run test.py -i compiled_benchmarks/no_opt/suricata_xdp_filter.bpf 

- gpl run_time_ns 16450679530 run_cnt 2000000000
- gpl run_time_ns 16447169591 run_cnt 2000000000
16658591732 
- 16493487181
- 16466496216

24.4903510905

8.259406808833333

https://github.com/xdp-project/xdp-tools?tab=readme-ov-file


https://github.com/xdp-project/xdp-tools/tree/main/xdp-trafficgen





# Location of custom llvm install: /home/otso/llvm_better

Instrumentation places a dyn_inst_cnt global variable





# Things to compile
## Katran

```sh
TODO: figure out how to compile it with a path to our compiler:
./build_katran.sh
```

Will outputs:
- /home/otso/katran/_build/deps/bpfprog/bpf/balancer.bpf.o

## Suricata


filter.bpf = ipv4_drop map
- uses an ipv4_drop map that contains set of ipv4 address to drop

- pinned-maps, map pinned under /sys/fs/bpf/suricata-eth3-ipv4_drop

bpfctrl
https://github.com/StamusNetworks/bpfctrl

sudo bpfctrl -m /sys/fs/bpf/suricata-wlp4s0-ipv4_drop ipv4 --add 1.2.3.4=1

cp ebpf/xdp_filter.bpf /usr/libexec/suricata/ebpf/

How to actually do this?


# https://docs.suricata.io/en/latest/capture-hardware/ebpf-xdp.html#setup-xdp-bypass
cd /home/otso/suricata/

### Compile with certain clang
```sh
# Without optimizations
LLC=/home/otso/custom_llvm/bin/llc  CC=/home/otso/custom_llvm/bin/clang ./configure --prefix=/usr/ --sysconfdir=/etc/ --localstatedir=/var/ \
--enable-ebpf --enable-ebpf-build

make clean && make


LLC=/home/otso/custom_llvm/bin/llc  CC=/home/otso/llvm-project/clang_opt ./configure --prefix=/usr/ --sysconfdir=/etc/ --localstatedir=/var/ \
--enable-ebpf --enable-ebpf-build

make clean && make

# Compile just the ebpf filter:

/home/otso/llvm-project/clang_opt -Wall -Iinclude -O2 -g -I/usr/include/x86_64-linux-gnu/ -D__KERNEL__ -D__ASM_SYSREG_H -target bpf -S -emit-llvm xdp_filter.c -o xdp_filter.ll

/home/otso/custom_llvm/bin/llc -march=bpf -filetype=obj xdp_filter.ll -o xdp_filter.bpf 

/home/otso/llvm-project/build/bin/llvm-objdump -S xdp_filter.bpf
```

# Outputs filter to:
/home/otso/suricata/ebpf/xdp_filter.bpf 

# I copied them to

/home/otso/llvm-project/compiled_benchmarks/opt/xdp_filter.bpf
/home/otso/llvm-project/compiled_benchmarks/no_opt/xdp_filter.bpf

ConstantPropogation + Dead code elimination gets rid of three instructions
- Gets rid of three instructions

- Not enough to be visible in benchmarks

##
prog.c

##
drop.o
