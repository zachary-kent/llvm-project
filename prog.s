	.file	"prog.c"
	.file	0 "/home/zkent/llvm-project" "prog.c" md5 0xf08cc947a023394b60f51f60631d8d43
	.file	1 "/usr/include/bpf" "bpf_helpers.h" md5 0xffd0067f7d01e4b6afe7c857435f8c2e
	.file	2 "/usr/include/bpf" "bpf_helper_defs.h" md5 0xeadf4a8bcf7ac4e7bd6d2cb666452242
	.file	3 "/usr/include/linux" "bpf.h" md5 0xe2b0965e216ca45603736701a8c61ffa
	.section	xdp,"ax",@progbits
	.globl	toy_example                     # -- Begin function toy_example
	.p2align	3
	.type	toy_example,@function
toy_example:                            # @toy_example
.Ltoy_example$local:
	.type	.Ltoy_example$local,@function
.Lfunc_begin0:
	.loc	0 24 0                          # prog.c:24:0
	.cfi_sections .debug_frame
	.cfi_startproc
# %bb.0:                                # %entry
	w2 = 9
	r3 = dyn_inst_cnt ll
	lock *(u32 *)(r3 + 0) += w2
.Ltmp0:
.Ltmp1:
	#DEBUG_VALUE: toy_example:ctx <- $r1
	#DEBUG_VALUE: toy_example:key <- [DW_OP_deref] $r10
	w0 = 1
.Ltmp2:
	.loc	0 25 41 prologue_end            # prog.c:25:41
.Ltmp3:
.Ltmp4:
	w2 = *(u32 *)(r1 + 4)
.Ltmp5:
.Ltmp6:
	#DEBUG_VALUE: toy_example:data_end <- $r2
	.loc	0 26 37                         # prog.c:26:37
.Ltmp7:
	w1 = *(u32 *)(r1 + 0)
.Ltmp8:
.Ltmp9:
	#DEBUG_VALUE: toy_example:key <- 0
	#DEBUG_VALUE: toy_example:data <- $r1
	#DEBUG_VALUE: toy_example:eth <- $r1
	#DEBUG_VALUE: toy_example:lookup_res <- 0
	#DEBUG_VALUE: toy_example:nh_off <- 14
	.loc	0 33 14                         # prog.c:33:14
.Ltmp10:
	r3 = r1
	r3 += 14
	.loc	0 33 23 is_stmt 0               # prog.c:33:23
.Ltmp11:
	if r3 > r2 goto LBB0_7
.Ltmp12:
.Ltmp13:
# %bb.1:                                # %if.end
	#DEBUG_VALUE: toy_example:nh_off <- 14
	#DEBUG_VALUE: toy_example:lookup_res <- 0
	#DEBUG_VALUE: toy_example:eth <- $r1
	#DEBUG_VALUE: toy_example:data <- $r1
	#DEBUG_VALUE: toy_example:key <- 0
	#DEBUG_VALUE: toy_example:data_end <- $r2
	.loc	0 0 23                          # prog.c:0:23
	w2 = 8
.Ltmp14:
.Ltmp15:
	r3 = dyn_inst_cnt ll
	lock *(u32 *)(r3 + 0) += w2
	.loc	0 37 18 is_stmt 1               # prog.c:37:18
.Ltmp16:
	w3 = *(u8 *)(r1 + 12)
	w2 = *(u8 *)(r1 + 13)
	w2 <<= 8
	w2 |= w3
.Ltmp17:
.Ltmp18:
	#DEBUG_VALUE: toy_example:proto <- [DW_OP_LLVM_convert 16 7, DW_OP_LLVM_convert 32 7, DW_OP_stack_value] $w2
	.loc	0 38 15                         # prog.c:38:15
.Ltmp19:
	if w2 == 56710 goto LBB0_7
.Ltmp20:
.Ltmp21:
# %bb.2:                                # %if.end
	#DEBUG_VALUE: toy_example:proto <- [DW_OP_LLVM_convert 16 7, DW_OP_LLVM_convert 32 7, DW_OP_stack_value] $w2
	#DEBUG_VALUE: toy_example:nh_off <- 14
	#DEBUG_VALUE: toy_example:lookup_res <- 0
	#DEBUG_VALUE: toy_example:eth <- $r1
	#DEBUG_VALUE: toy_example:data <- $r1
	#DEBUG_VALUE: toy_example:key <- 0
	.loc	0 0 15 is_stmt 0                # prog.c:0:15
	w3 = 4
	r4 = dyn_inst_cnt ll
	lock *(u32 *)(r4 + 0) += w3
	.loc	0 38 15 is_stmt 1               # prog.c:38:15
	if w2 != 8 goto LBB0_6
.Ltmp22:
.Ltmp23:
# %bb.3:                                # %if.then8
	#DEBUG_VALUE: toy_example:proto <- [DW_OP_LLVM_convert 16 7, DW_OP_LLVM_convert 32 7, DW_OP_stack_value] $w2
	#DEBUG_VALUE: toy_example:nh_off <- 14
	#DEBUG_VALUE: toy_example:lookup_res <- 0
	#DEBUG_VALUE: toy_example:eth <- $r1
	#DEBUG_VALUE: toy_example:data <- $r1
	#DEBUG_VALUE: toy_example:key <- 0
	.loc	0 0 15 is_stmt 0                # prog.c:0:15
	w2 = 26
.Ltmp24:
.Ltmp25:
	r3 = dyn_inst_cnt ll
	lock *(u32 *)(r3 + 0) += w2
.Ltmp26:
	.loc	0 39 9 is_stmt 1                # prog.c:39:9
.Ltmp27:
.Ltmp28:
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
.Ltmp29:
.Ltmp30:
	w1 <<= 24
	w1 |= w3
	w1 |= w2
	*(u32 *)(r10 - 8) = w1
.Ltmp31:
.Ltmp32:
	#DEBUG_VALUE: toy_example:key <- [DW_OP_deref] $r10
	.loc	0 0 9 is_stmt 0                 # prog.c:0:9
	r2 = r10
	r2 += -8
	.loc	0 40 22 is_stmt 1               # prog.c:40:22
.Ltmp33:
	r1 = map ll
	call 1
.Ltmp34:
	.loc	0 40 22                         # prog.c:40:22
	r1 = r0
.Ltmp35:
.Ltmp36:
	#DEBUG_VALUE: toy_example:lookup_res <- $r1
	.loc	0 0 22 is_stmt 0                # prog.c:0:22
	w0 = 1
.Ltmp37:
.Ltmp38:
	if r1 == 0 goto LBB0_5
.Ltmp39:
.Ltmp40:
# %bb.4:                                # %if.then8
	#DEBUG_VALUE: toy_example:lookup_res <- $r1
	#DEBUG_VALUE: toy_example:nh_off <- 14
	#DEBUG_VALUE: toy_example:key <- [DW_OP_deref] $r10
	w1 = 4
.Ltmp41:
.Ltmp42:
	r2 = dyn_inst_cnt ll
	lock *(u32 *)(r2 + 0) += w1
	w0 = 2
.Ltmp43:
.Ltmp44:
LBB0_5:                                 # %if.then8
	#DEBUG_VALUE: toy_example:nh_off <- 14
	#DEBUG_VALUE: toy_example:key <- [DW_OP_deref] $r10
	w1 = 4
	r2 = dyn_inst_cnt ll
	lock *(u32 *)(r2 + 0) += w1
	goto LBB0_7
.Ltmp45:
.Ltmp46:
LBB0_6:                                 # %if.else15
	#DEBUG_VALUE: toy_example:proto <- [DW_OP_LLVM_convert 16 7, DW_OP_LLVM_convert 32 7, DW_OP_stack_value] $w2
	#DEBUG_VALUE: toy_example:nh_off <- 14
	#DEBUG_VALUE: toy_example:lookup_res <- 0
	#DEBUG_VALUE: toy_example:eth <- $r1
	#DEBUG_VALUE: toy_example:data <- $r1
	#DEBUG_VALUE: toy_example:key <- 0
	w1 = 4
.Ltmp47:
.Ltmp48:
	r2 = dyn_inst_cnt ll
.Ltmp49:
.Ltmp50:
	lock *(u32 *)(r2 + 0) += w1
	w0 = 2
.Ltmp51:
.Ltmp52:
LBB0_7:                                 # %cleanup
	#DEBUG_VALUE: toy_example:nh_off <- 14
	w1 = 4
	r2 = dyn_inst_cnt ll
	lock *(u32 *)(r2 + 0) += w1
	.loc	0 53 1 is_stmt 1                # prog.c:53:1
.Ltmp53:
	exit
.Ltmp54:
.Ltmp55:
.Lfunc_end0:
	.size	toy_example, .Lfunc_end0-toy_example
	.size	.Ltoy_example$local, .Lfunc_end0-toy_example
	.cfi_endproc
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

	.type	_license,@object                # @_license
	.section	license,"aw",@progbits
	.globl	_license
_license:
.L_license$local:
	.asciz	"GPL"
	.size	_license, 4

	.type	dyn_inst_cnt,@object            # @dyn_inst_cnt
	.section	.bss,"aw",@nobits
	.globl	dyn_inst_cnt
	.p2align	3, 0x0
dyn_inst_cnt:
	.quad	0                               # 0x0
	.size	dyn_inst_cnt, 8

	.file	4 "/usr/include/asm-generic" "int-ll64.h" md5 0xb810f270733e106319b67ef512c6246e
	.file	5 "/usr/include/linux" "if_ether.h" md5 0x547e20406bda1c07ecd60513a638463c
	.file	6 "/usr/include/linux" "types.h" md5 0x52ec79a38e49ac7d1dc9e146ba88a7b1
	.section	.debug_loclists,"",@progbits
	.long	.Ldebug_list_header_end0-.Ldebug_list_header_start0 # Length
.Ldebug_list_header_start0:
	.short	5                               # Version
	.byte	8                               # Address size
	.byte	0                               # Segment selector size
	.long	8                               # Offset entry count
.Lloclists_table_base0:
	.long	.Ldebug_loc0-.Lloclists_table_base0
	.long	.Ldebug_loc1-.Lloclists_table_base0
	.long	.Ldebug_loc2-.Lloclists_table_base0
	.long	.Ldebug_loc3-.Lloclists_table_base0
	.long	.Ldebug_loc4-.Lloclists_table_base0
	.long	.Ldebug_loc5-.Lloclists_table_base0
	.long	.Ldebug_loc6-.Lloclists_table_base0
	.long	.Ldebug_loc7-.Lloclists_table_base0
.Ldebug_loc0:
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp0-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp8-.Lfunc_begin0           #   ending offset
	.byte	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc1:
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp0-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp8-.Lfunc_begin0           #   ending offset
	.byte	2                               # Loc expr size
	.byte	122                             # DW_OP_breg10
	.byte	0                               # 0
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp8-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp31-.Lfunc_begin0          #   ending offset
	.byte	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp31-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp45-.Lfunc_begin0          #   ending offset
	.byte	2                               # Loc expr size
	.byte	122                             # DW_OP_breg10
	.byte	0                               # 0
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp45-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp51-.Lfunc_begin0          #   ending offset
	.byte	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc2:
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp5-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp14-.Lfunc_begin0          #   ending offset
	.byte	1                               # Loc expr size
	.byte	82                              # DW_OP_reg2
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc3:
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp8-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp29-.Lfunc_begin0          #   ending offset
	.byte	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp45-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp47-.Lfunc_begin0          #   ending offset
	.byte	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc4:
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp8-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp29-.Lfunc_begin0          #   ending offset
	.byte	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp45-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp47-.Lfunc_begin0          #   ending offset
	.byte	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc5:
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp8-.Lfunc_begin0           #   starting offset
	.uleb128 .Ltmp35-.Lfunc_begin0          #   ending offset
	.byte	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp35-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp41-.Lfunc_begin0          #   ending offset
	.byte	1                               # Loc expr size
	.byte	81                              # DW_OP_reg1
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp45-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp51-.Lfunc_begin0          #   ending offset
	.byte	2                               # Loc expr size
	.byte	48                              # DW_OP_lit0
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc6:
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp8-.Lfunc_begin0           #   starting offset
	.uleb128 .Lfunc_end0-.Lfunc_begin0      #   ending offset
	.byte	2                               # Loc expr size
	.byte	62                              # DW_OP_lit14
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_loc7:
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp17-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp24-.Lfunc_begin0          #   ending offset
	.byte	13                              # Loc expr size
	.byte	114                             # DW_OP_breg2
	.byte	0                               # 0
	.byte	168                             # DW_OP_convert
	.asciz	"\247\200\200"                  # 
	.byte	168                             # DW_OP_convert
	.asciz	"\253\200\200"                  # 
	.byte	159                             # DW_OP_stack_value
	.byte	4                               # DW_LLE_offset_pair
	.uleb128 .Ltmp45-.Lfunc_begin0          #   starting offset
	.uleb128 .Ltmp49-.Lfunc_begin0          #   ending offset
	.byte	13                              # Loc expr size
	.byte	114                             # DW_OP_breg2
	.byte	0                               # 0
	.byte	168                             # DW_OP_convert
	.asciz	"\247\200\200"                  # 
	.byte	168                             # DW_OP_convert
	.asciz	"\253\200\200"                  # 
	.byte	159                             # DW_OP_stack_value
	.byte	0                               # DW_LLE_end_of_list
.Ldebug_list_header_end0:
	.section	.debug_abbrev,"",@progbits
	.byte	1                               # Abbreviation Code
	.byte	17                              # DW_TAG_compile_unit
	.byte	1                               # DW_CHILDREN_yes
	.byte	37                              # DW_AT_producer
	.byte	37                              # DW_FORM_strx1
	.byte	19                              # DW_AT_language
	.byte	5                               # DW_FORM_data2
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	114                             # DW_AT_str_offsets_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	16                              # DW_AT_stmt_list
	.byte	23                              # DW_FORM_sec_offset
	.byte	27                              # DW_AT_comp_dir
	.byte	37                              # DW_FORM_strx1
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	115                             # DW_AT_addr_base
	.byte	23                              # DW_FORM_sec_offset
	.ascii	"\214\001"                      # DW_AT_loclists_base
	.byte	23                              # DW_FORM_sec_offset
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	2                               # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	3                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	2                               # DW_AT_location
	.byte	24                              # DW_FORM_exprloc
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	4                               # Abbreviation Code
	.byte	19                              # DW_TAG_structure_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	5                               # Abbreviation Code
	.byte	13                              # DW_TAG_member
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	56                              # DW_AT_data_member_location
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	6                               # Abbreviation Code
	.byte	1                               # DW_TAG_array_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	7                               # Abbreviation Code
	.byte	33                              # DW_TAG_subrange_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	55                              # DW_AT_count
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	8                               # Abbreviation Code
	.byte	36                              # DW_TAG_base_type
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	62                              # DW_AT_encoding
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	9                               # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	28                              # DW_AT_const_value
	.byte	15                              # DW_FORM_udata
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	10                              # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	11                              # Abbreviation Code
	.byte	21                              # DW_TAG_subroutine_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	12                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	13                              # Abbreviation Code
	.byte	15                              # DW_TAG_pointer_type
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	14                              # Abbreviation Code
	.byte	38                              # DW_TAG_const_type
	.byte	0                               # DW_CHILDREN_no
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	15                              # Abbreviation Code
	.byte	4                               # DW_TAG_enumeration_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	5                               # DW_FORM_data2
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	16                              # Abbreviation Code
	.byte	40                              # DW_TAG_enumerator
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	28                              # DW_AT_const_value
	.byte	15                              # DW_FORM_udata
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	17                              # Abbreviation Code
	.byte	46                              # DW_TAG_subprogram
	.byte	1                               # DW_CHILDREN_yes
	.byte	17                              # DW_AT_low_pc
	.byte	27                              # DW_FORM_addrx
	.byte	18                              # DW_AT_high_pc
	.byte	6                               # DW_FORM_data4
	.byte	64                              # DW_AT_frame_base
	.byte	24                              # DW_FORM_exprloc
	.byte	122                             # DW_AT_call_all_calls
	.byte	25                              # DW_FORM_flag_present
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	39                              # DW_AT_prototyped
	.byte	25                              # DW_FORM_flag_present
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	63                              # DW_AT_external
	.byte	25                              # DW_FORM_flag_present
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	18                              # Abbreviation Code
	.byte	5                               # DW_TAG_formal_parameter
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	34                              # DW_FORM_loclistx
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	19                              # Abbreviation Code
	.byte	52                              # DW_TAG_variable
	.byte	0                               # DW_CHILDREN_no
	.byte	2                               # DW_AT_location
	.byte	34                              # DW_FORM_loclistx
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	20                              # Abbreviation Code
	.byte	19                              # DW_TAG_structure_type
	.byte	1                               # DW_CHILDREN_yes
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	11                              # DW_AT_byte_size
	.byte	11                              # DW_FORM_data1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	5                               # DW_FORM_data2
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	21                              # Abbreviation Code
	.byte	13                              # DW_TAG_member
	.byte	0                               # DW_CHILDREN_no
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	5                               # DW_FORM_data2
	.byte	56                              # DW_AT_data_member_location
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	22                              # Abbreviation Code
	.byte	22                              # DW_TAG_typedef
	.byte	0                               # DW_CHILDREN_no
	.byte	73                              # DW_AT_type
	.byte	19                              # DW_FORM_ref4
	.byte	3                               # DW_AT_name
	.byte	37                              # DW_FORM_strx1
	.byte	58                              # DW_AT_decl_file
	.byte	11                              # DW_FORM_data1
	.byte	59                              # DW_AT_decl_line
	.byte	11                              # DW_FORM_data1
	.byte	0                               # EOM(1)
	.byte	0                               # EOM(2)
	.byte	0                               # EOM(3)
	.section	.debug_info,"",@progbits
.Lcu_begin0:
	.long	.Ldebug_info_end0-.Ldebug_info_start0 # Length of Unit
.Ldebug_info_start0:
	.short	5                               # DWARF version number
	.byte	1                               # DWARF Unit Type
	.byte	8                               # Address Size (in bytes)
	.long	.debug_abbrev                   # Offset Into Abbrev. Section
	.byte	1                               # Abbrev [1] 0xc:0x1c8 DW_TAG_compile_unit
	.byte	0                               # DW_AT_producer
	.short	29                              # DW_AT_language
	.byte	1                               # DW_AT_name
	.long	.Lstr_offsets_base0             # DW_AT_str_offsets_base
	.long	.Lline_table_start0             # DW_AT_stmt_list
	.byte	2                               # DW_AT_comp_dir
	.byte	2                               # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.long	.Laddr_table_base0              # DW_AT_addr_base
	.long	.Lloclists_table_base0          # DW_AT_loclists_base
	.byte	2                               # Abbrev [2] 0x27:0x4 DW_TAG_base_type
	.byte	23                              # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	2                               # DW_AT_byte_size
	.byte	2                               # Abbrev [2] 0x2b:0x4 DW_TAG_base_type
	.byte	22                              # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	3                               # Abbrev [3] 0x2f:0xb DW_TAG_variable
	.byte	3                               # DW_AT_name
	.long	58                              # DW_AT_type
                                        # DW_AT_external
	.byte	0                               # DW_AT_decl_file
	.byte	8                               # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	0
	.byte	4                               # Abbrev [4] 0x3a:0x33 DW_TAG_structure_type
	.byte	10                              # DW_AT_name
	.byte	20                              # DW_AT_byte_size
	.byte	1                               # DW_AT_decl_file
	.byte	138                             # DW_AT_decl_line
	.byte	5                               # Abbrev [5] 0x3f:0x9 DW_TAG_member
	.byte	4                               # DW_AT_name
	.long	109                             # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	139                             # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	5                               # Abbrev [5] 0x48:0x9 DW_TAG_member
	.byte	6                               # DW_AT_name
	.long	109                             # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	140                             # DW_AT_decl_line
	.byte	4                               # DW_AT_data_member_location
	.byte	5                               # Abbrev [5] 0x51:0x9 DW_TAG_member
	.byte	7                               # DW_AT_name
	.long	109                             # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	141                             # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	5                               # Abbrev [5] 0x5a:0x9 DW_TAG_member
	.byte	8                               # DW_AT_name
	.long	109                             # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	142                             # DW_AT_decl_line
	.byte	12                              # DW_AT_data_member_location
	.byte	5                               # Abbrev [5] 0x63:0x9 DW_TAG_member
	.byte	9                               # DW_AT_name
	.long	109                             # DW_AT_type
	.byte	1                               # DW_AT_decl_file
	.byte	143                             # DW_AT_decl_line
	.byte	16                              # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	2                               # Abbrev [2] 0x6d:0x4 DW_TAG_base_type
	.byte	5                               # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	3                               # Abbrev [3] 0x71:0xb DW_TAG_variable
	.byte	11                              # DW_AT_name
	.long	124                             # DW_AT_type
                                        # DW_AT_external
	.byte	0                               # DW_AT_decl_file
	.byte	55                              # DW_AT_decl_line
	.byte	2                               # DW_AT_location
	.byte	161
	.byte	1
	.byte	6                               # Abbrev [6] 0x7c:0xc DW_TAG_array_type
	.long	136                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0x81:0x6 DW_TAG_subrange_type
	.long	140                             # DW_AT_type
	.byte	4                               # DW_AT_count
	.byte	0                               # End Of Children Mark
	.byte	2                               # Abbrev [2] 0x88:0x4 DW_TAG_base_type
	.byte	12                              # DW_AT_name
	.byte	6                               # DW_AT_encoding
	.byte	1                               # DW_AT_byte_size
	.byte	8                               # Abbrev [8] 0x8c:0x4 DW_TAG_base_type
	.byte	13                              # DW_AT_name
	.byte	8                               # DW_AT_byte_size
	.byte	7                               # DW_AT_encoding
	.byte	9                               # Abbrev [9] 0x90:0x9 DW_TAG_variable
	.byte	14                              # DW_AT_name
	.long	153                             # DW_AT_type
	.byte	2                               # DW_AT_decl_file
	.byte	50                              # DW_AT_decl_line
	.byte	1                               # DW_AT_const_value
	.byte	10                              # Abbrev [10] 0x99:0x5 DW_TAG_pointer_type
	.long	158                             # DW_AT_type
	.byte	11                              # Abbrev [11] 0x9e:0x10 DW_TAG_subroutine_type
	.long	174                             # DW_AT_type
                                        # DW_AT_prototyped
	.byte	12                              # Abbrev [12] 0xa3:0x5 DW_TAG_formal_parameter
	.long	174                             # DW_AT_type
	.byte	12                              # Abbrev [12] 0xa8:0x5 DW_TAG_formal_parameter
	.long	175                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	13                              # Abbrev [13] 0xae:0x1 DW_TAG_pointer_type
	.byte	10                              # Abbrev [10] 0xaf:0x5 DW_TAG_pointer_type
	.long	180                             # DW_AT_type
	.byte	14                              # Abbrev [14] 0xb4:0x1 DW_TAG_const_type
	.byte	15                              # Abbrev [15] 0xb5:0x1a DW_TAG_enumeration_type
	.long	109                             # DW_AT_type
	.byte	20                              # DW_AT_name
	.byte	4                               # DW_AT_byte_size
	.byte	3                               # DW_AT_decl_file
	.short	3153                            # DW_AT_decl_line
	.byte	16                              # Abbrev [16] 0xbf:0x3 DW_TAG_enumerator
	.byte	15                              # DW_AT_name
	.byte	0                               # DW_AT_const_value
	.byte	16                              # Abbrev [16] 0xc2:0x3 DW_TAG_enumerator
	.byte	16                              # DW_AT_name
	.byte	1                               # DW_AT_const_value
	.byte	16                              # Abbrev [16] 0xc5:0x3 DW_TAG_enumerator
	.byte	17                              # DW_AT_name
	.byte	2                               # DW_AT_const_value
	.byte	16                              # Abbrev [16] 0xc8:0x3 DW_TAG_enumerator
	.byte	18                              # DW_AT_name
	.byte	3                               # DW_AT_const_value
	.byte	16                              # Abbrev [16] 0xcb:0x3 DW_TAG_enumerator
	.byte	19                              # DW_AT_name
	.byte	4                               # DW_AT_const_value
	.byte	0                               # End Of Children Mark
	.byte	2                               # Abbrev [2] 0xcf:0x4 DW_TAG_base_type
	.byte	21                              # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	8                               # DW_AT_byte_size
	.byte	17                              # Abbrev [17] 0xd3:0x58 DW_TAG_subprogram
	.byte	2                               # DW_AT_low_pc
	.long	.Lfunc_end0-.Lfunc_begin0       # DW_AT_high_pc
	.byte	1                               # DW_AT_frame_base
	.byte	90
                                        # DW_AT_call_all_calls
	.byte	24                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	23                              # DW_AT_decl_line
                                        # DW_AT_prototyped
	.long	299                             # DW_AT_type
                                        # DW_AT_external
	.byte	18                              # Abbrev [18] 0xe2:0x9 DW_TAG_formal_parameter
	.byte	0                               # DW_AT_location
	.byte	26                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	23                              # DW_AT_decl_line
	.long	303                             # DW_AT_type
	.byte	19                              # Abbrev [19] 0xeb:0x9 DW_TAG_variable
	.byte	1                               # DW_AT_location
	.byte	34                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	30                              # DW_AT_decl_line
	.long	373                             # DW_AT_type
	.byte	19                              # Abbrev [19] 0xf4:0x9 DW_TAG_variable
	.byte	2                               # DW_AT_location
	.byte	29                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	25                              # DW_AT_decl_line
	.long	174                             # DW_AT_type
	.byte	19                              # Abbrev [19] 0xfd:0x9 DW_TAG_variable
	.byte	3                               # DW_AT_location
	.byte	27                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	26                              # DW_AT_decl_line
	.long	174                             # DW_AT_type
	.byte	19                              # Abbrev [19] 0x106:0x9 DW_TAG_variable
	.byte	4                               # DW_AT_location
	.byte	37                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	29                              # DW_AT_decl_line
	.long	397                             # DW_AT_type
	.byte	19                              # Abbrev [19] 0x10f:0x9 DW_TAG_variable
	.byte	5                               # DW_AT_location
	.byte	45                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.long	174                             # DW_AT_type
	.byte	19                              # Abbrev [19] 0x118:0x9 DW_TAG_variable
	.byte	6                               # DW_AT_location
	.byte	46                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	28                              # DW_AT_decl_line
	.long	365                             # DW_AT_type
	.byte	19                              # Abbrev [19] 0x121:0x9 DW_TAG_variable
	.byte	7                               # DW_AT_location
	.byte	47                              # DW_AT_name
	.byte	0                               # DW_AT_decl_file
	.byte	28                              # DW_AT_decl_line
	.long	365                             # DW_AT_type
	.byte	0                               # End Of Children Mark
	.byte	2                               # Abbrev [2] 0x12b:0x4 DW_TAG_base_type
	.byte	25                              # DW_AT_name
	.byte	5                               # DW_AT_encoding
	.byte	4                               # DW_AT_byte_size
	.byte	10                              # Abbrev [10] 0x12f:0x5 DW_TAG_pointer_type
	.long	308                             # DW_AT_type
	.byte	20                              # Abbrev [20] 0x134:0x39 DW_TAG_structure_type
	.byte	33                              # DW_AT_name
	.byte	20                              # DW_AT_byte_size
	.byte	3                               # DW_AT_decl_file
	.short	3164                            # DW_AT_decl_line
	.byte	21                              # Abbrev [21] 0x13a:0xa DW_TAG_member
	.byte	27                              # DW_AT_name
	.long	365                             # DW_AT_type
	.byte	3                               # DW_AT_decl_file
	.short	3165                            # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	21                              # Abbrev [21] 0x144:0xa DW_TAG_member
	.byte	29                              # DW_AT_name
	.long	365                             # DW_AT_type
	.byte	3                               # DW_AT_decl_file
	.short	3166                            # DW_AT_decl_line
	.byte	4                               # DW_AT_data_member_location
	.byte	21                              # Abbrev [21] 0x14e:0xa DW_TAG_member
	.byte	30                              # DW_AT_name
	.long	365                             # DW_AT_type
	.byte	3                               # DW_AT_decl_file
	.short	3167                            # DW_AT_decl_line
	.byte	8                               # DW_AT_data_member_location
	.byte	21                              # Abbrev [21] 0x158:0xa DW_TAG_member
	.byte	31                              # DW_AT_name
	.long	365                             # DW_AT_type
	.byte	3                               # DW_AT_decl_file
	.short	3169                            # DW_AT_decl_line
	.byte	12                              # DW_AT_data_member_location
	.byte	21                              # Abbrev [21] 0x162:0xa DW_TAG_member
	.byte	32                              # DW_AT_name
	.long	365                             # DW_AT_type
	.byte	3                               # DW_AT_decl_file
	.short	3170                            # DW_AT_decl_line
	.byte	16                              # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	22                              # Abbrev [22] 0x16d:0x8 DW_TAG_typedef
	.long	109                             # DW_AT_type
	.byte	28                              # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	27                              # DW_AT_decl_line
	.byte	6                               # Abbrev [6] 0x175:0xc DW_TAG_array_type
	.long	385                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0x17a:0x6 DW_TAG_subrange_type
	.long	140                             # DW_AT_type
	.byte	6                               # DW_AT_count
	.byte	0                               # End Of Children Mark
	.byte	22                              # Abbrev [22] 0x181:0x8 DW_TAG_typedef
	.long	393                             # DW_AT_type
	.byte	36                              # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	21                              # DW_AT_decl_line
	.byte	2                               # Abbrev [2] 0x189:0x4 DW_TAG_base_type
	.byte	35                              # DW_AT_name
	.byte	8                               # DW_AT_encoding
	.byte	1                               # DW_AT_byte_size
	.byte	10                              # Abbrev [10] 0x18d:0x5 DW_TAG_pointer_type
	.long	402                             # DW_AT_type
	.byte	4                               # Abbrev [4] 0x192:0x21 DW_TAG_structure_type
	.byte	44                              # DW_AT_name
	.byte	14                              # DW_AT_byte_size
	.byte	5                               # DW_AT_decl_file
	.byte	163                             # DW_AT_decl_line
	.byte	5                               # Abbrev [5] 0x197:0x9 DW_TAG_member
	.byte	38                              # DW_AT_name
	.long	435                             # DW_AT_type
	.byte	5                               # DW_AT_decl_file
	.byte	164                             # DW_AT_decl_line
	.byte	0                               # DW_AT_data_member_location
	.byte	5                               # Abbrev [5] 0x1a0:0x9 DW_TAG_member
	.byte	39                              # DW_AT_name
	.long	435                             # DW_AT_type
	.byte	5                               # DW_AT_decl_file
	.byte	165                             # DW_AT_decl_line
	.byte	6                               # DW_AT_data_member_location
	.byte	5                               # Abbrev [5] 0x1a9:0x9 DW_TAG_member
	.byte	40                              # DW_AT_name
	.long	447                             # DW_AT_type
	.byte	5                               # DW_AT_decl_file
	.byte	166                             # DW_AT_decl_line
	.byte	12                              # DW_AT_data_member_location
	.byte	0                               # End Of Children Mark
	.byte	6                               # Abbrev [6] 0x1b3:0xc DW_TAG_array_type
	.long	393                             # DW_AT_type
	.byte	7                               # Abbrev [7] 0x1b8:0x6 DW_TAG_subrange_type
	.long	140                             # DW_AT_type
	.byte	6                               # DW_AT_count
	.byte	0                               # End Of Children Mark
	.byte	22                              # Abbrev [22] 0x1bf:0x8 DW_TAG_typedef
	.long	455                             # DW_AT_type
	.byte	43                              # DW_AT_name
	.byte	6                               # DW_AT_decl_file
	.byte	25                              # DW_AT_decl_line
	.byte	22                              # Abbrev [22] 0x1c7:0x8 DW_TAG_typedef
	.long	463                             # DW_AT_type
	.byte	42                              # DW_AT_name
	.byte	4                               # DW_AT_decl_file
	.byte	24                              # DW_AT_decl_line
	.byte	2                               # Abbrev [2] 0x1cf:0x4 DW_TAG_base_type
	.byte	41                              # DW_AT_name
	.byte	7                               # DW_AT_encoding
	.byte	2                               # DW_AT_byte_size
	.byte	0                               # End Of Children Mark
.Ldebug_info_end0:
	.section	.debug_str_offsets,"",@progbits
	.long	196                             # Length of String Offsets Set
	.short	5
	.short	0
.Lstr_offsets_base0:
	.section	.debug_str,"MS",@progbits,1
.Linfo_string0:
	.asciz	"clang version 22.0.0git (git@github.com:zachary-kent/llvm-project.git afda1fb89c55bf8290b45e88f62e2246fa4e5112)" # string offset=0
.Linfo_string1:
	.asciz	"prog.c"                        # string offset=112
.Linfo_string2:
	.asciz	"/home/zkent/llvm-project"      # string offset=119
.Linfo_string3:
	.asciz	"map"                           # string offset=144
.Linfo_string4:
	.asciz	"type"                          # string offset=148
.Linfo_string5:
	.asciz	"unsigned int"                  # string offset=153
.Linfo_string6:
	.asciz	"key_size"                      # string offset=166
.Linfo_string7:
	.asciz	"value_size"                    # string offset=175
.Linfo_string8:
	.asciz	"max_entries"                   # string offset=186
.Linfo_string9:
	.asciz	"map_flags"                     # string offset=198
.Linfo_string10:
	.asciz	"bpf_map_def"                   # string offset=208
.Linfo_string11:
	.asciz	"_license"                      # string offset=220
.Linfo_string12:
	.asciz	"char"                          # string offset=229
.Linfo_string13:
	.asciz	"__ARRAY_SIZE_TYPE__"           # string offset=234
.Linfo_string14:
	.asciz	"bpf_map_lookup_elem"           # string offset=254
.Linfo_string15:
	.asciz	"XDP_ABORTED"                   # string offset=274
.Linfo_string16:
	.asciz	"XDP_DROP"                      # string offset=286
.Linfo_string17:
	.asciz	"XDP_PASS"                      # string offset=295
.Linfo_string18:
	.asciz	"XDP_TX"                        # string offset=304
.Linfo_string19:
	.asciz	"XDP_REDIRECT"                  # string offset=311
.Linfo_string20:
	.asciz	"xdp_action"                    # string offset=324
.Linfo_string21:
	.asciz	"long"                          # string offset=335
.Linfo_string22:
	.asciz	"DW_ATE_unsigned_32"            # string offset=340
.Linfo_string23:
	.asciz	"DW_ATE_unsigned_16"            # string offset=359
.Linfo_string24:
	.asciz	"toy_example"                   # string offset=378
.Linfo_string25:
	.asciz	"int"                           # string offset=390
.Linfo_string26:
	.asciz	"ctx"                           # string offset=394
.Linfo_string27:
	.asciz	"data"                          # string offset=398
.Linfo_string28:
	.asciz	"__u32"                         # string offset=403
.Linfo_string29:
	.asciz	"data_end"                      # string offset=409
.Linfo_string30:
	.asciz	"data_meta"                     # string offset=418
.Linfo_string31:
	.asciz	"ingress_ifindex"               # string offset=428
.Linfo_string32:
	.asciz	"rx_queue_index"                # string offset=444
.Linfo_string33:
	.asciz	"xdp_md"                        # string offset=459
.Linfo_string34:
	.asciz	"key"                           # string offset=466
.Linfo_string35:
	.asciz	"unsigned char"                 # string offset=470
.Linfo_string36:
	.asciz	"__u8"                          # string offset=484
.Linfo_string37:
	.asciz	"eth"                           # string offset=489
.Linfo_string38:
	.asciz	"h_dest"                        # string offset=493
.Linfo_string39:
	.asciz	"h_source"                      # string offset=500
.Linfo_string40:
	.asciz	"h_proto"                       # string offset=509
.Linfo_string41:
	.asciz	"unsigned short"                # string offset=517
.Linfo_string42:
	.asciz	"__u16"                         # string offset=532
.Linfo_string43:
	.asciz	"__be16"                        # string offset=538
.Linfo_string44:
	.asciz	"ethhdr"                        # string offset=545
.Linfo_string45:
	.asciz	"lookup_res"                    # string offset=552
.Linfo_string46:
	.asciz	"nh_off"                        # string offset=563
.Linfo_string47:
	.asciz	"proto"                         # string offset=570
	.section	.debug_str_offsets,"",@progbits
	.long	.Linfo_string0
	.long	.Linfo_string1
	.long	.Linfo_string2
	.long	.Linfo_string3
	.long	.Linfo_string4
	.long	.Linfo_string5
	.long	.Linfo_string6
	.long	.Linfo_string7
	.long	.Linfo_string8
	.long	.Linfo_string9
	.long	.Linfo_string10
	.long	.Linfo_string11
	.long	.Linfo_string12
	.long	.Linfo_string13
	.long	.Linfo_string14
	.long	.Linfo_string15
	.long	.Linfo_string16
	.long	.Linfo_string17
	.long	.Linfo_string18
	.long	.Linfo_string19
	.long	.Linfo_string20
	.long	.Linfo_string21
	.long	.Linfo_string22
	.long	.Linfo_string23
	.long	.Linfo_string24
	.long	.Linfo_string25
	.long	.Linfo_string26
	.long	.Linfo_string27
	.long	.Linfo_string28
	.long	.Linfo_string29
	.long	.Linfo_string30
	.long	.Linfo_string31
	.long	.Linfo_string32
	.long	.Linfo_string33
	.long	.Linfo_string34
	.long	.Linfo_string35
	.long	.Linfo_string36
	.long	.Linfo_string37
	.long	.Linfo_string38
	.long	.Linfo_string39
	.long	.Linfo_string40
	.long	.Linfo_string41
	.long	.Linfo_string42
	.long	.Linfo_string43
	.long	.Linfo_string44
	.long	.Linfo_string45
	.long	.Linfo_string46
	.long	.Linfo_string47
	.section	.debug_addr,"",@progbits
	.long	.Ldebug_addr_end0-.Ldebug_addr_start0 # Length of contribution
.Ldebug_addr_start0:
	.short	5                               # DWARF version number
	.byte	8                               # Address size
	.byte	0                               # Segment selector size
.Laddr_table_base0:
	.quad	map
	.quad	_license
	.quad	.Lfunc_begin0
.Ldebug_addr_end0:
	.section	.BTF,"",@progbits
	.short	60319                           # 0xeb9f
	.byte	1
	.byte	0
	.long	24
	.long	0
	.long	368
	.long	368
	.long	248
	.long	0                               # BTF_KIND_PTR(id = 1)
	.long	33554432                        # 0x2000000
	.long	2
	.long	1                               # BTF_KIND_STRUCT(id = 2)
	.long	67108869                        # 0x4000005
	.long	20
	.long	8
	.long	3
	.long	0                               # 0x0
	.long	13
	.long	3
	.long	32                              # 0x20
	.long	22
	.long	3
	.long	64                              # 0x40
	.long	32
	.long	3
	.long	96                              # 0x60
	.long	48
	.long	3
	.long	128                             # 0x80
	.long	63                              # BTF_KIND_TYPEDEF(id = 3)
	.long	134217728                       # 0x8000000
	.long	4
	.long	69                              # BTF_KIND_INT(id = 4)
	.long	16777216                        # 0x1000000
	.long	4
	.long	32                              # 0x20
	.long	0                               # BTF_KIND_FUNC_PROTO(id = 5)
	.long	218103809                       # 0xd000001
	.long	6
	.long	82
	.long	1
	.long	86                              # BTF_KIND_INT(id = 6)
	.long	16777216                        # 0x1000000
	.long	4
	.long	16777248                        # 0x1000020
	.long	90                              # BTF_KIND_FUNC(id = 7)
	.long	201326593                       # 0xc000001
	.long	5
	.long	138                             # BTF_KIND_STRUCT(id = 8)
	.long	67108869                        # 0x4000005
	.long	20
	.long	150
	.long	4
	.long	0                               # 0x0
	.long	155
	.long	4
	.long	32                              # 0x20
	.long	164
	.long	4
	.long	64                              # 0x40
	.long	175
	.long	4
	.long	96                              # 0x60
	.long	187
	.long	4
	.long	128                             # 0x80
	.long	197                             # BTF_KIND_VAR(id = 9)
	.long	234881024                       # 0xe000000
	.long	8
	.long	1
	.long	201                             # BTF_KIND_INT(id = 10)
	.long	16777216                        # 0x1000000
	.long	1
	.long	16777224                        # 0x1000008
	.long	0                               # BTF_KIND_ARRAY(id = 11)
	.long	50331648                        # 0x3000000
	.long	0
	.long	10
	.long	12
	.long	4
	.long	206                             # BTF_KIND_INT(id = 12)
	.long	16777216                        # 0x1000000
	.long	4
	.long	32                              # 0x20
	.long	226                             # BTF_KIND_VAR(id = 13)
	.long	234881024                       # 0xe000000
	.long	11
	.long	1
	.long	235                             # BTF_KIND_DATASEC(id = 14)
	.long	251658241                       # 0xf000001
	.long	0
	.long	13
	.long	_license
	.long	4
	.long	243                             # BTF_KIND_DATASEC(id = 15)
	.long	251658241                       # 0xf000001
	.long	0
	.long	9
	.long	map
	.long	20
	.byte	0                               # string offset=0
	.ascii	"xdp_md"                        # string offset=1
	.byte	0
	.ascii	"data"                          # string offset=8
	.byte	0
	.ascii	"data_end"                      # string offset=13
	.byte	0
	.ascii	"data_meta"                     # string offset=22
	.byte	0
	.ascii	"ingress_ifindex"               # string offset=32
	.byte	0
	.ascii	"rx_queue_index"                # string offset=48
	.byte	0
	.ascii	"__u32"                         # string offset=63
	.byte	0
	.ascii	"unsigned int"                  # string offset=69
	.byte	0
	.ascii	"ctx"                           # string offset=82
	.byte	0
	.ascii	"int"                           # string offset=86
	.byte	0
	.ascii	"toy_example"                   # string offset=90
	.byte	0
	.ascii	"xdp"                           # string offset=102
	.byte	0
	.ascii	"/home/zkent/llvm-project/prog.c" # string offset=106
	.byte	0
	.ascii	"bpf_map_def"                   # string offset=138
	.byte	0
	.ascii	"type"                          # string offset=150
	.byte	0
	.ascii	"key_size"                      # string offset=155
	.byte	0
	.ascii	"value_size"                    # string offset=164
	.byte	0
	.ascii	"max_entries"                   # string offset=175
	.byte	0
	.ascii	"map_flags"                     # string offset=187
	.byte	0
	.ascii	"map"                           # string offset=197
	.byte	0
	.ascii	"char"                          # string offset=201
	.byte	0
	.ascii	"__ARRAY_SIZE_TYPE__"           # string offset=206
	.byte	0
	.ascii	"_license"                      # string offset=226
	.byte	0
	.ascii	"license"                       # string offset=235
	.byte	0
	.ascii	"maps"                          # string offset=243
	.byte	0
	.section	.BTF.ext,"",@progbits
	.short	60319                           # 0xeb9f
	.byte	1
	.byte	0
	.long	32
	.long	0
	.long	20
	.long	20
	.long	172
	.long	192
	.long	0
	.long	8                               # FuncInfo
	.long	102                             # FuncInfo section string offset=102
	.long	1
	.long	.Lfunc_begin0
	.long	7
	.long	16                              # LineInfo
	.long	102                             # LineInfo section string offset=102
	.long	10
	.long	.Lfunc_begin0
	.long	106
	.long	0
	.long	23552                           # Line 23 Col 0
	.long	.Ltmp4
	.long	106
	.long	0
	.long	25641                           # Line 25 Col 41
	.long	.Ltmp7
	.long	106
	.long	0
	.long	26661                           # Line 26 Col 37
	.long	.Ltmp10
	.long	106
	.long	0
	.long	33806                           # Line 33 Col 14
	.long	.Ltmp11
	.long	106
	.long	0
	.long	33815                           # Line 33 Col 23
	.long	.Ltmp16
	.long	106
	.long	0
	.long	37906                           # Line 37 Col 18
	.long	.Ltmp19
	.long	106
	.long	0
	.long	38927                           # Line 38 Col 15
	.long	.Ltmp28
	.long	106
	.long	0
	.long	39945                           # Line 39 Col 9
	.long	.Ltmp33
	.long	106
	.long	0
	.long	40982                           # Line 40 Col 22
	.long	.Ltmp53
	.long	106
	.long	0
	.long	54273                           # Line 53 Col 1
	.section	.debug_line,"",@progbits
.Lline_table_start0:
