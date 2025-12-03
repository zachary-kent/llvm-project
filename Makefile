all: align.so fusion.so

LLVM_SRC = /home/otso/llvm-project/llvm
LLVM_BUILD = /home/otso/llvm-project/build
CXX = "clang++"
CXXFLAGS = $(shell /home/otso/llvm-project/build/bin/llvm-config --cxxflags) -std=c++20 -fPIC -g -I$(LLVM_SRC)/lib/Target/BPF -I$(LLVM_BUILD)/lib/Target/BPF
LDFLAGS  = $(shell /home/otso/llvm-project/build/bin/llvm-config) -shared

align.so: llvm/lib/Target/BPF/BPFDataAlignment.cpp
	cd /home/otso/llvm-project/llvm/lib/Target/BPF/ && $(CXX) $(CXXFLAGS) -shared  BPFDataAlignment.cpp -o /home/otso/llvm-project/align.so $(LDFLAGS)

fusion.so: llvm/lib/Target/BPF/BPFMacroOpFusion.cpp
	cd /home/otso/llvm-project/llvm/lib/Target/BPF/ && $(CXX) $(CXXFLAGS) -shared  BPFMacroOpFusion.cpp -o /home/otso/llvm-project/fusion.so $(LDFLAGS)

clean:
	rm align.so