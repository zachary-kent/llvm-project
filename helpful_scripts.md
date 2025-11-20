# Location of custom llvm install: /home/otso/llvm_better

# Things to compile
## Katran

```sh
TODO: figure out how to compile it with a path to our compiler:
./build_katran.sh
```

Will outputs:
- /home/otso/katran/_build/deps/bpfprog/bpf/balancer.bpf.o

## Suricata
# https://docs.suricata.io/en/latest/capture-hardware/ebpf-xdp.html#setup-xdp-bypass
cd /home/otso/suricata/

### Compile with certain clang
```sh
# Without optimizations
LLC=/home/otso/llvm_better/bin/llc  CC=/home/otso/llvm_better/bin/clang ./configure --prefix=/usr/ --sysconfdir=/etc/ --localstatedir=/var/ \

make clean && make


# With optimizations
BPF_CFLAGS="-mllvm=-bpf-enable-const-prop -mllvm=-bpf-enable-dce" LLC=/home/otso/llvm_better/bin/llc  CC=/home/otso/llvm-project/clang_opt ./configure --prefix=/usr/ --sysconfdir=/etc/ --localstatedir=/var/ \

make clean && make
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
