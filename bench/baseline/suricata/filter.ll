; ModuleID = 'filter.c'
source_filename = "filter.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }

@__license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@__version = dso_local global i32 263682, section "version", align 4, !dbg !59
@ipv4_drop = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !61
@llvm.compiler.used = appending global [4 x ptr] [ptr @__license, ptr @__version, ptr @hashfilter, ptr @ipv4_drop], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local range(i32 -1, 1) i32 @hashfilter(ptr noundef %skb) #0 section "filter" !dbg !103 {
entry:
  %ip.i = alloca i32, align 4, !DIAssignID !176
    #dbg_value(ptr %skb, !173, !DIExpression(), !177)
    #dbg_value(i32 14, !174, !DIExpression(), !177)
  %call = tail call i64 @llvm.bpf.load.half(ptr noundef %skb, i64 noundef 12), !dbg !178
    #dbg_value(i64 %call, !175, !DIExpression(DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value), !177)
  %0 = trunc i64 %call to i32, !dbg !179
  %conv1 = and i32 %0, 65535, !dbg !179
  %cmp = icmp eq i32 %conv1, 34984, !dbg !181
  %cmp4 = icmp eq i32 %conv1, 33024
  %1 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %cmp)
  %or.cond = select i1 %1, i1 true, i1 %cmp4, !dbg !182
  br i1 %or.cond, label %if.then, label %if.end, !dbg !182

if.then:                                          ; preds = %entry
  %call7 = tail call i64 @llvm.bpf.load.half(ptr noundef %skb, i64 noundef 16), !dbg !183
    #dbg_value(i64 %call7, !175, !DIExpression(DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value), !177)
    #dbg_value(i32 18, !174, !DIExpression(), !177)
  br label %if.end, !dbg !185

if.end:                                           ; preds = %entry, %if.then
  %nhoff.0 = phi i32 [ 18, %if.then ], [ 14, %entry ], !dbg !177
  %proto.0.in = phi i64 [ %call7, %if.then ], [ %call, %entry ]
    #dbg_value(i64 %proto.0.in, !175, !DIExpression(DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value), !177)
    #dbg_value(i32 %nhoff.0, !174, !DIExpression(), !177)
  %cb = getelementptr inbounds nuw i8, ptr %skb, i64 48, !dbg !186
  store i32 %nhoff.0, ptr %cb, align 8, !dbg !187, !tbaa !99
  %2 = and i64 %proto.0.in, 65535, !dbg !188
  %cond = icmp eq i64 %2, 2048, !dbg !188
  br i1 %cond, label %sw.bb, label %cleanup, !dbg !188

sw.bb:                                            ; preds = %if.end
    #dbg_assign(i1 poison, !189, !DIExpression(), !176, ptr %ip.i, !DIExpression(), !195)
    #dbg_value(ptr %skb, !192, !DIExpression(), !195)
  call void @llvm.lifetime.start.p0(ptr nonnull %ip.i) #4, !dbg !198
    #dbg_assign(i32 0, !189, !DIExpression(), !199, ptr %ip.i, !DIExpression(), !195)
    #dbg_value(i32 %nhoff.0, !193, !DIExpression(), !195)
  %conv.i = zext nneg i32 %nhoff.0 to i64, !dbg !200
  %add.i = add nuw nsw i64 %conv.i, 12, !dbg !201
  %call.i = tail call i64 @llvm.bpf.load.word(ptr noundef nonnull %skb, i64 noundef %add.i), !dbg !202
  %conv1.i = trunc i64 %call.i to i32, !dbg !203
  store i32 %conv1.i, ptr %ip.i, align 4, !dbg !204, !tbaa !99, !DIAssignID !205
    #dbg_assign(i32 %conv1.i, !189, !DIExpression(), !205, ptr %ip.i, !DIExpression(), !195)
  %call2.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @ipv4_drop, ptr noundef nonnull %ip.i) #4, !dbg !206
    #dbg_value(ptr %call2.i, !194, !DIExpression(), !195)
  %tobool.not.i = icmp eq ptr %call2.i, null, !dbg !207
  br i1 %tobool.not.i, label %if.end.i, label %ipv4_filter.exit.sink.split, !dbg !209

if.end.i:                                         ; preds = %sw.bb
  %add5.i = add nuw nsw i64 %conv.i, 16, !dbg !210
  %call6.i = call i64 @llvm.bpf.load.word(ptr noundef nonnull %skb, i64 noundef %add5.i), !dbg !211
  %conv7.i = trunc i64 %call6.i to i32, !dbg !212
  store i32 %conv7.i, ptr %ip.i, align 4, !dbg !213, !tbaa !99, !DIAssignID !214
    #dbg_assign(i32 %conv7.i, !189, !DIExpression(), !214, ptr %ip.i, !DIExpression(), !195)
  %call8.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @ipv4_drop, ptr noundef nonnull %ip.i) #4, !dbg !215
    #dbg_value(ptr %call8.i, !194, !DIExpression(), !195)
  %tobool9.not.i = icmp eq ptr %call8.i, null, !dbg !216
  br i1 %tobool9.not.i, label %ipv4_filter.exit, label %ipv4_filter.exit.sink.split, !dbg !218

ipv4_filter.exit.sink.split:                      ; preds = %if.end.i, %sw.bb
  %call2.i.sink25 = phi ptr [ %call2.i, %sw.bb ], [ %call8.i, %if.end.i ]
  %3 = load i32, ptr %call2.i.sink25, align 4, !dbg !195, !tbaa !99
  %add3.i = add i32 %3, 1, !dbg !195
  store i32 %add3.i, ptr %call2.i.sink25, align 4, !dbg !195, !tbaa !99
  br label %ipv4_filter.exit, !dbg !219

ipv4_filter.exit:                                 ; preds = %ipv4_filter.exit.sink.split, %if.end.i
  %retval.0.i = phi i32 [ -1, %if.end.i ], [ 0, %ipv4_filter.exit.sink.split ], !dbg !195
  call void @llvm.lifetime.end.p0(ptr nonnull %ip.i) #4, !dbg !219
  br label %cleanup, !dbg !220

cleanup:                                          ; preds = %if.end, %ipv4_filter.exit
  %retval.0 = phi i32 [ %retval.0.i, %ipv4_filter.exit ], [ -1, %if.end ], !dbg !177
  ret i32 %retval.0, !dbg !221
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(read)
declare !dbg !222 i64 @llvm.bpf.load.half(ptr, i64) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(read)
declare !dbg !229 i64 @llvm.bpf.load.word(ptr, i64) #2

; Function Attrs: nounwind memory(none)
declare i1 @llvm.bpf.passthrough.i1.i1(i32, i1) #3

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind willreturn memory(read) }
attributes #3 = { nounwind memory(none) }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!93, !94, !95, !96, !97}
!llvm.ident = !{!98}
!llvm.errno.tbaa = !{!99}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "__license", scope: !2, file: !3, line: 113, type: !89, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 22.0.0git (https://github.com/zachary-kent/llvm-project/ 17a443e799e99026e9430fea2d6fc19b39cb5b8b)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !58, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "filter.c", directory: "/home/otso/suricata/ebpf", checksumkind: CSK_MD5, checksum: "c4fd07ad1f8dde9b9cde599049b4a076")
!4 = !{!5, !6, !22, !27}
!5 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !8, line: 173, size: 112, elements: !9)
!8 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!9 = !{!10, !15, !16}
!10 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !7, file: !8, line: 174, baseType: !11, size: 48)
!11 = !DICompositeType(tag: DW_TAG_array_type, baseType: !12, size: 48, elements: !13)
!12 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!13 = !{!14}
!14 = !DISubrange(count: 6)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !7, file: !8, line: 175, baseType: !11, size: 48, offset: 48)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !7, file: !8, line: 176, baseType: !17, size: 16, offset: 96)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !18, line: 32, baseType: !19)
!18 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "c0ade1a1a309d6896ce6080a51a2d105")
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !20, line: 24, baseType: !21)
!20 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!21 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!23 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !3, line: 42, size: 32, elements: !24)
!24 = !{!25, !26}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !23, file: !3, line: 43, baseType: !19, size: 16)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !23, file: !3, line: 44, baseType: !19, size: 16, offset: 16)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !29, line: 87, size: 160, elements: !30)
!29 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "5c58d077e910b6c258855dca54d0ec22")
!30 = !{!31, !33, !34, !35, !36, !37, !38, !39, !40, !42}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !28, file: !29, line: 89, baseType: !32, size: 4, flags: DIFlagBitField, extraData: i64 0)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !20, line: 21, baseType: !12)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !28, file: !29, line: 90, baseType: !32, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !28, file: !29, line: 97, baseType: !32, size: 8, offset: 8)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !28, file: !29, line: 98, baseType: !17, size: 16, offset: 16)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !28, file: !29, line: 99, baseType: !17, size: 16, offset: 32)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !28, file: !29, line: 100, baseType: !17, size: 16, offset: 48)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !28, file: !29, line: 101, baseType: !32, size: 8, offset: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !28, file: !29, line: 102, baseType: !32, size: 8, offset: 72)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !28, file: !29, line: 103, baseType: !41, size: 16, offset: 80)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !18, line: 38, baseType: !19)
!42 = !DIDerivedType(tag: DW_TAG_member, scope: !28, file: !29, line: 104, baseType: !43, size: 64, offset: 96)
!43 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !28, file: !29, line: 104, size: 64, elements: !44)
!44 = !{!45, !53}
!45 = !DIDerivedType(tag: DW_TAG_member, scope: !43, file: !29, line: 104, baseType: !46, size: 64)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !43, file: !29, line: 104, size: 64, elements: !47)
!47 = !{!48, !52}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !46, file: !29, line: 105, baseType: !49, size: 32)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !18, line: 34, baseType: !50)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !20, line: 27, baseType: !51)
!51 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !46, file: !29, line: 106, baseType: !49, size: 32, offset: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !43, file: !29, line: 104, baseType: !54, size: 64)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !43, file: !29, line: 104, size: 64, elements: !55)
!55 = !{!56, !57}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !54, file: !29, line: 105, baseType: !49, size: 32)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !54, file: !29, line: 106, baseType: !49, size: 32, offset: 32)
!58 = !{!0, !59, !61, !79}
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "__version", scope: !2, file: !3, line: 115, type: !50, isLocal: false, isDefinition: true)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "ipv4_drop", scope: !2, file: !3, line: 40, type: !63, isLocal: false, isDefinition: true)
!63 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 35, size: 256, elements: !64)
!64 = !{!65, !71, !73, !74}
!65 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !63, file: !3, line: 36, baseType: !66, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !68, size: 160, elements: !69)
!68 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!69 = !{!70}
!70 = !DISubrange(count: 5)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !63, file: !3, line: 37, baseType: !72, size: 64, offset: 64)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !63, file: !3, line: 38, baseType: !72, size: 64, offset: 128)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !63, file: !3, line: 39, baseType: !75, size: 64, offset: 192)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DICompositeType(tag: DW_TAG_array_type, baseType: !68, size: 1048576, elements: !77)
!77 = !{!78}
!78 = !DISubrange(count: 32768)
!79 = !DIGlobalVariableExpression(var: !80, expr: !DIExpression())
!80 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !81, line: 64, type: !82, isLocal: true, isDefinition: true)
!81 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "11f09623d7230081247afacdc7c1a641")
!82 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !83)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = !DISubroutineType(types: !85)
!85 = !{!86, !86, !87}
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !90, size: 32, elements: !91)
!90 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!91 = !{!92}
!92 = !DISubrange(count: 4)
!93 = !{i32 7, !"Dwarf Version", i32 5}
!94 = !{i32 2, !"Debug Info Version", i32 3}
!95 = !{i32 1, !"wchar_size", i32 4}
!96 = !{i32 7, !"frame-pointer", i32 2}
!97 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!98 = !{!"clang version 22.0.0git (https://github.com/zachary-kent/llvm-project/ 17a443e799e99026e9430fea2d6fc19b39cb5b8b)"}
!99 = !{!100, !100, i64 0}
!100 = !{!"int", !101, i64 0}
!101 = !{!"omnipotent char", !102, i64 0}
!102 = !{!"Simple C/C++ TBAA"}
!103 = distinct !DISubprogram(name: "hashfilter", scope: !3, file: !3, line: 89, type: !104, scopeLine: 90, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !172, keyInstructions: true)
!104 = !DISubroutineType(types: !105)
!105 = !{!68, !106}
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sk_buff", file: !108, line: 2489, size: 1344, elements: !109)
!108 = !DIFile(filename: "include/linux/bpf.h", directory: "/home/otso/suricata/ebpf", checksumkind: CSK_MD5, checksum: "783c30496bbc98655006468758d90a0e")
!109 = !{!110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !124, !125, !126, !127, !128, !129, !130, !131, !132, !134, !135, !136, !137, !138, !168, !171}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !107, file: !108, line: 2490, baseType: !50, size: 32)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_type", scope: !107, file: !108, line: 2491, baseType: !50, size: 32, offset: 32)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !107, file: !108, line: 2492, baseType: !50, size: 32, offset: 64)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "queue_mapping", scope: !107, file: !108, line: 2493, baseType: !50, size: 32, offset: 96)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !107, file: !108, line: 2494, baseType: !50, size: 32, offset: 128)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_present", scope: !107, file: !108, line: 2495, baseType: !50, size: 32, offset: 160)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_tci", scope: !107, file: !108, line: 2496, baseType: !50, size: 32, offset: 192)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_proto", scope: !107, file: !108, line: 2497, baseType: !50, size: 32, offset: 224)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !107, file: !108, line: 2498, baseType: !50, size: 32, offset: 256)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !107, file: !108, line: 2499, baseType: !50, size: 32, offset: 288)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !107, file: !108, line: 2500, baseType: !50, size: 32, offset: 320)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "tc_index", scope: !107, file: !108, line: 2501, baseType: !50, size: 32, offset: 352)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "cb", scope: !107, file: !108, line: 2502, baseType: !123, size: 160, offset: 384)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 160, elements: !69)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "hash", scope: !107, file: !108, line: 2503, baseType: !50, size: 32, offset: 544)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "tc_classid", scope: !107, file: !108, line: 2504, baseType: !50, size: 32, offset: 576)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !107, file: !108, line: 2505, baseType: !50, size: 32, offset: 608)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !107, file: !108, line: 2506, baseType: !50, size: 32, offset: 640)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "napi_id", scope: !107, file: !108, line: 2507, baseType: !50, size: 32, offset: 672)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !107, file: !108, line: 2510, baseType: !50, size: 32, offset: 704)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !107, file: !108, line: 2511, baseType: !50, size: 32, offset: 736)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !107, file: !108, line: 2512, baseType: !50, size: 32, offset: 768)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !107, file: !108, line: 2513, baseType: !133, size: 128, offset: 800)
!133 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 128, elements: !91)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !107, file: !108, line: 2514, baseType: !133, size: 128, offset: 928)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !107, file: !108, line: 2515, baseType: !50, size: 32, offset: 1056)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !107, file: !108, line: 2516, baseType: !50, size: 32, offset: 1088)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !107, file: !108, line: 2519, baseType: !50, size: 32, offset: 1120)
!138 = !DIDerivedType(tag: DW_TAG_member, scope: !107, file: !108, line: 2520, baseType: !139, size: 64, align: 64, offset: 1152)
!139 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !107, file: !108, line: 2520, size: 64, align: 64, elements: !140)
!140 = !{!141}
!141 = !DIDerivedType(tag: DW_TAG_member, name: "flow_keys", scope: !139, file: !108, line: 2520, baseType: !142, size: 64)
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!143 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_flow_keys", file: !108, line: 2999, size: 384, elements: !144)
!144 = !{!145, !146, !147, !148, !149, !150, !151, !152, !153, !154, !155}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "nhoff", scope: !143, file: !108, line: 3000, baseType: !19, size: 16)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "thoff", scope: !143, file: !108, line: 3001, baseType: !19, size: 16, offset: 16)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "addr_proto", scope: !143, file: !108, line: 3002, baseType: !19, size: 16, offset: 32)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "is_frag", scope: !143, file: !108, line: 3003, baseType: !32, size: 8, offset: 48)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "is_first_frag", scope: !143, file: !108, line: 3004, baseType: !32, size: 8, offset: 56)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "is_encap", scope: !143, file: !108, line: 3005, baseType: !32, size: 8, offset: 64)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !143, file: !108, line: 3006, baseType: !32, size: 8, offset: 72)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "n_proto", scope: !143, file: !108, line: 3007, baseType: !17, size: 16, offset: 80)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !143, file: !108, line: 3008, baseType: !17, size: 16, offset: 96)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !143, file: !108, line: 3009, baseType: !17, size: 16, offset: 112)
!155 = !DIDerivedType(tag: DW_TAG_member, scope: !143, file: !108, line: 3010, baseType: !156, size: 256, offset: 128)
!156 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !143, file: !108, line: 3010, size: 256, elements: !157)
!157 = !{!158, !163}
!158 = !DIDerivedType(tag: DW_TAG_member, scope: !156, file: !108, line: 3011, baseType: !159, size: 64)
!159 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !156, file: !108, line: 3011, size: 64, elements: !160)
!160 = !{!161, !162}
!161 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !159, file: !108, line: 3012, baseType: !49, size: 32)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !159, file: !108, line: 3013, baseType: !49, size: 32, offset: 32)
!163 = !DIDerivedType(tag: DW_TAG_member, scope: !156, file: !108, line: 3015, baseType: !164, size: 256)
!164 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !156, file: !108, line: 3015, size: 256, elements: !165)
!165 = !{!166, !167}
!166 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !164, file: !108, line: 3016, baseType: !133, size: 128)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !164, file: !108, line: 3017, baseType: !133, size: 128, offset: 128)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp", scope: !107, file: !108, line: 2521, baseType: !169, size: 64, offset: 1216)
!169 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !20, line: 31, baseType: !170)
!170 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "wire_len", scope: !107, file: !108, line: 2522, baseType: !50, size: 32, offset: 1280)
!172 = !{!173, !174, !175}
!173 = !DILocalVariable(name: "skb", arg: 1, scope: !103, file: !3, line: 89, type: !106)
!174 = !DILocalVariable(name: "nhoff", scope: !103, file: !3, line: 91, type: !50)
!175 = !DILocalVariable(name: "proto", scope: !103, file: !3, line: 93, type: !19)
!176 = distinct !DIAssignID()
!177 = !DILocation(line: 0, scope: !103)
!178 = !DILocation(line: 93, column: 19, scope: !103, atomGroup: 2, atomRank: 3)
!179 = !DILocation(line: 95, column: 9, scope: !180)
!180 = distinct !DILexicalBlock(scope: !103, file: !3, line: 95, column: 9)
!181 = !DILocation(line: 95, column: 15, scope: !180, atomGroup: 3, atomRank: 2)
!182 = !DILocation(line: 95, column: 31, scope: !180, atomGroup: 3, atomRank: 1)
!183 = !DILocation(line: 96, column: 17, scope: !184, atomGroup: 5, atomRank: 3)
!184 = distinct !DILexicalBlock(scope: !180, file: !3, line: 95, column: 56)
!185 = !DILocation(line: 99, column: 5, scope: !184)
!186 = !DILocation(line: 101, column: 10, scope: !103)
!187 = !DILocation(line: 101, column: 16, scope: !103, atomGroup: 7, atomRank: 1)
!188 = !DILocation(line: 102, column: 5, scope: !103, atomGroup: 8, atomRank: 1)
!189 = !DILocalVariable(name: "ip", scope: !190, file: !3, line: 51, type: !50)
!190 = distinct !DISubprogram(name: "ipv4_filter", scope: !3, file: !3, line: 47, type: !104, scopeLine: 48, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !191, keyInstructions: true)
!191 = !{!192, !193, !194, !189}
!192 = !DILocalVariable(name: "skb", arg: 1, scope: !190, file: !3, line: 47, type: !106)
!193 = !DILocalVariable(name: "nhoff", scope: !190, file: !3, line: 49, type: !50)
!194 = !DILocalVariable(name: "value", scope: !190, file: !3, line: 50, type: !72)
!195 = !DILocation(line: 0, scope: !190, inlinedAt: !196)
!196 = distinct !DILocation(line: 104, column: 20, scope: !197)
!197 = distinct !DILexicalBlock(scope: !103, file: !3, line: 102, column: 20)
!198 = !DILocation(line: 51, column: 5, scope: !190, inlinedAt: !196)
!199 = distinct !DIAssignID()
!200 = !DILocation(line: 55, column: 25, scope: !190, inlinedAt: !196)
!201 = !DILocation(line: 55, column: 31, scope: !190, inlinedAt: !196)
!202 = !DILocation(line: 55, column: 10, scope: !190, inlinedAt: !196, atomGroup: 3, atomRank: 3)
!203 = !DILocation(line: 55, column: 10, scope: !190, inlinedAt: !196, atomGroup: 3, atomRank: 2)
!204 = !DILocation(line: 55, column: 8, scope: !190, inlinedAt: !196, atomGroup: 3, atomRank: 1)
!205 = distinct !DIAssignID()
!206 = !DILocation(line: 56, column: 13, scope: !190, inlinedAt: !196, atomGroup: 4, atomRank: 2)
!207 = !DILocation(line: 57, column: 9, scope: !208, inlinedAt: !196, atomGroup: 5, atomRank: 2)
!208 = distinct !DILexicalBlock(scope: !190, file: !3, line: 57, column: 9)
!209 = !DILocation(line: 57, column: 9, scope: !208, inlinedAt: !196, atomGroup: 5, atomRank: 1)
!210 = !DILocation(line: 66, column: 31, scope: !190, inlinedAt: !196)
!211 = !DILocation(line: 66, column: 10, scope: !190, inlinedAt: !196, atomGroup: 8, atomRank: 3)
!212 = !DILocation(line: 66, column: 10, scope: !190, inlinedAt: !196, atomGroup: 8, atomRank: 2)
!213 = !DILocation(line: 66, column: 8, scope: !190, inlinedAt: !196, atomGroup: 8, atomRank: 1)
!214 = distinct !DIAssignID()
!215 = !DILocation(line: 67, column: 13, scope: !190, inlinedAt: !196, atomGroup: 9, atomRank: 2)
!216 = !DILocation(line: 68, column: 9, scope: !217, inlinedAt: !196, atomGroup: 10, atomRank: 2)
!217 = distinct !DILexicalBlock(scope: !190, file: !3, line: 68, column: 9)
!218 = !DILocation(line: 68, column: 9, scope: !217, inlinedAt: !196, atomGroup: 10, atomRank: 1)
!219 = !DILocation(line: 82, column: 1, scope: !190, inlinedAt: !196)
!220 = !DILocation(line: 104, column: 13, scope: !197, atomGroup: 9, atomRank: 1)
!221 = !DILocation(line: 111, column: 1, scope: !103, atomGroup: 13, atomRank: 1)
!222 = !DISubprogram(name: "load_half", linkageName: "llvm.bpf.load.half", scope: !223, file: !223, line: 6, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !226)
!223 = !DIFile(filename: "./llvm_bpfload.h", directory: "/home/otso/suricata/ebpf", checksumkind: CSK_MD5, checksum: "966f507fb4e301e14b51edc0ab12b220")
!224 = !DISubroutineType(types: !225)
!225 = !{!170, !86, !170}
!226 = !{!227, !228}
!227 = !DILocalVariable(name: "skb", arg: 1, scope: !222, file: !223, line: 6, type: !86)
!228 = !DILocalVariable(name: "off", arg: 2, scope: !222, file: !223, line: 6, type: !170)
!229 = !DISubprogram(name: "load_word", linkageName: "llvm.bpf.load.word", scope: !223, file: !223, line: 7, type: !224, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !230)
!230 = !{!231, !232}
!231 = !DILocalVariable(name: "skb", arg: 1, scope: !229, file: !223, line: 7, type: !86)
!232 = !DILocalVariable(name: "off", arg: 2, scope: !229, file: !223, line: 7, type: !170)
