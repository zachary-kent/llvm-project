# No optimizations:
# Location: /home/otso/llvm_original

# Clang: /home/otso/llvm_original/bin/clang


# With our optimizations
# Location: /home/otso/llvm_better

# Clang: /home/otso/llvm_better/bin/clang


# Things to compile
## Katran
/home/newt/katran/_build/deps/bpfprog/bpf/balancer.bpf.o

```sh
LLC=/home/otso/llvm_better/bin/llc  CC=/home/otso/llvm_better/bin/clang  ./build_katran.sh
```

- Saved to
## Suricata
# https://docs.suricata.io/en/latest/capture-hardware/ebpf-xdp.html#setup-xdp-bypass
cd /home/otso/suricata/

### Compile with certain clang
```
# Without optimizations
LLC=/home/otso/llvm_better/bin/llc  CC=/home/otso/llvm_better/bin/clang ./configure --prefix=/usr/ --sysconfdir=/etc/ --localstatedir=/var/ \
--enable-ebpf --enable-ebpf-build

SURICATA BPF BUILD SCRIPT BY DEFAULT DOES NOT SUPPORT USER PASSING IN MORE CLI FLAGS
# Search for BPF_CFLAGS
# TODO: edit that script

# With optimizations
BPF_CFLAGS="-mllvm=-bpf-enable-const-prop -mllvm=-bpf-enable-dce" LLC=/home/otso/llvm_better/bin/llc  CC=/home/otso/llvm_better/bin/clang ./configure --prefix=/usr/ --sysconfdir=/etc/ --localstatedir=/var/ \
--enable-ebpf --enable-ebpf-build

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
