	.file	"prog.c"
	.section	xdp,"ax",@progbits
	.globl	toy_example                     # -- Begin function toy_example
	.p2align	3
	.type	toy_example,@function
toy_example:                            # @toy_example
.Ltoy_example$local:
	.type	.Ltoy_example$local,@function
# %bb.0:                                # %entry
	w0 = 1
	w2 = *(u32 *)(r1 + 4)
	w1 = *(u32 *)(r1 + 0)
	r3 = r1
	r3 += 14
	if r3 > r2 goto LBB0_5
# %bb.1:                                # %if.end
	*(u8 *)(r10 - 9) = 1
	w2 = 2
	*(u8 *)(r10 - 10) = 2
	w2 = 3
	*(u8 *)(r10 - 11) = 3
	w2 = 4
	*(u8 *)(r10 - 12) = 4
	w3 = *(u8 *)(r1 + 12)
	w2 = *(u8 *)(r1 + 13)
	w2 <<= 8
	w2 |= w3
	if w2 == 56710 goto LBB0_5
# %bb.2:                                # %if.end
	if w2 != 8 goto LBB0_4
# %bb.3:                                # %if.then11
	w2 = *(u8 *)(r1 + 11)
	w2 <<= 8
	w3 = *(u8 *)(r1 + 10)
	w2 |= w3
	*(u16 *)(r10 - 4) = w2
	w2 = *(u8 *)(r1 + 7)
	w2 <<= 8
	w3 = *(u8 *)(r1 + 6)
	w2 |= w3
	w3 = *(u8 *)(r1 + 8)
	w3 <<= 16
	w1 = *(u8 *)(r1 + 9)
	w1 <<= 24
	w1 |= w3
	w1 |= w2
	*(u32 *)(r10 - 8) = w1
	r2 = r10
	r2 += -8
	r1 = map ll
	call 1
	r1 = r0
	w0 = 1
	if r1 == 0 goto LBB0_5
LBB0_4:                                 # %if.else18
	w0 = 2
LBB0_5:                                 # %cleanup19
	exit
.Lfunc_end0:
	.size	toy_example, .Lfunc_end0-toy_example
	.size	.Ltoy_example$local, .Lfunc_end0-toy_example
                                        # -- End function
	.type	map,@object                     # @map
	.section	maps,"aw",@progbits
	.globl	map
	.p2align	2, 0x0
map:
.Lmap$local:
	.long	1                               # 0x1
	.long	6                               # 0x6
	.long	4                               # 0x4
	.long	256                             # 0x100
	.long	0                               # 0x0
	.size	map, 20

	.type	dyn_inst_cnt,@object            # @dyn_inst_cnt
	.section	.bss,"aw",@nobits
	.globl	dyn_inst_cnt
	.p2align	2, 0x0
dyn_inst_cnt:
.Ldyn_inst_cnt$local:
	.long	0                               # 0x0
	.size	dyn_inst_cnt, 4

	.type	_license,@object                # @_license
	.section	license,"aw",@progbits
	.globl	_license
_license:
.L_license$local:
	.asciz	"GPL"
	.size	_license, 4

