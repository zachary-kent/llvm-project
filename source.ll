; ModuleID = 'prog.c'
source_filename = "prog.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }

@map = dso_local global %struct.bpf_map_def { i32 1, i32 6, i32 4, i32 256, i32 0 }, section "maps", align 4, !dbg !0
@dyn_inst_cnt = dso_local local_unnamed_addr global i32 0, align 4, !dbg !18
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !21
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @map, ptr @toy_example], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local range(i32 1, 3) i32 @toy_example(ptr noundef readonly captures(none) %ctx) #0 section "xdp" !dbg !53 {
entry:
  %key = alloca [6 x i8], align 1, !DIAssignID !93
    #dbg_assign(i1 poison, !90, !DIExpression(), !93, ptr %key, !DIExpression(), !94)
    #dbg_value(ptr %ctx, !68, !DIExpression(), !94)
  %data_end1 = getelementptr inbounds nuw i8, ptr %ctx, i64 4, !dbg !95
  %0 = load i32, ptr %data_end1, align 4, !dbg !96, !tbaa !97
  %conv = zext i32 %0 to i64, !dbg !99
  %1 = inttoptr i64 %conv to ptr, !dbg !100
    #dbg_value(ptr %1, !69, !DIExpression(), !94)
  %2 = load i32, ptr %ctx, align 4, !dbg !101, !tbaa !102
  %conv3 = zext i32 %2 to i64, !dbg !103
  %3 = inttoptr i64 %conv3 to ptr, !dbg !104
    #dbg_value(ptr %3, !70, !DIExpression(), !94)
    #dbg_value(ptr null, !71, !DIExpression(), !94)
    #dbg_value(ptr %3, !74, !DIExpression(), !94)
  call void @llvm.lifetime.start.p0(ptr nonnull %key) #3, !dbg !105
    #dbg_assign(i8 0, !90, !DIExpression(), !106, ptr %key, !DIExpression(), !94)
    #dbg_value(i32 14, !73, !DIExpression(), !94)
  %add.ptr = getelementptr inbounds nuw i8, ptr %3, i64 14, !dbg !107
  %cmp = icmp samesign ugt ptr %add.ptr, %1, !dbg !109
  br i1 %cmp, label %cleanup, label %if.end, !dbg !110

if.end:                                           ; preds = %entry
  %h_proto = getelementptr inbounds nuw i8, ptr %3, i64 12, !dbg !111
  %4 = load i16, ptr %h_proto, align 1, !dbg !112, !tbaa !113
    #dbg_value(i16 %4, !72, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !94)
  switch i16 %4, label %if.else15 [
    i16 8, label %if.then8
    i16 -8826, label %cleanup
  ], !dbg !116

if.then8:                                         ; preds = %if.end
  %h_source = getelementptr inbounds nuw i8, ptr %3, i64 6, !dbg !118
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %key, ptr noundef nonnull align 1 dereferenceable(6) %h_source, i64 6, i1 false), !dbg !120, !DIAssignID !121
    #dbg_assign(i1 poison, !90, !DIExpression(), !121, ptr %key, !DIExpression(), !94)
  %call = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @map, ptr noundef nonnull %key) #3, !dbg !122
    #dbg_value(ptr %call, !71, !DIExpression(), !94)
  %tobool.not = icmp eq ptr %call, null, !dbg !123
  %. = select i1 %tobool.not, i32 1, i32 2, !dbg !125
  br label %cleanup, !dbg !125

if.else15:                                        ; preds = %if.end
  br label %cleanup, !dbg !126

cleanup:                                          ; preds = %if.end, %if.then8, %entry, %if.else15
  %retval.0 = phi i32 [ 2, %if.else15 ], [ 1, %entry ], [ %., %if.then8 ], [ 1, %if.end ], !dbg !94
  call void @llvm.lifetime.end.p0(ptr nonnull %key) #3, !dbg !129
  ret i32 %retval.0, !dbg !130
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!43, !44, !45, !46, !47}
!llvm.ident = !{!48}
!llvm.errno.tbaa = !{!49}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "map", scope: !2, file: !3, line: 8, type: !35, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 22.0.0git (git@github.com:zachary-kent/llvm-project.git 4d0d826c977a9ef30db88e530c27aef18ab31ed5)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !17, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "prog.c", directory: "/home/zkent/llvm-project", checksumkind: CSK_MD5, checksum: "06bbd5f7dccdc07004db1c6ddb3822af")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 3153, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "e2b0965e216ca45603736701a8c61ffa")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !{!15, !16}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!17 = !{!0, !18, !21, !27}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "dyn_inst_cnt", scope: !2, file: !3, line: 15, type: !20, isLocal: false, isDefinition: true)
!20 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !7)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 57, type: !23, isLocal: false, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DISubrange(count: 4)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!28 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !29, line: 50, type: !30, isLocal: true, isDefinition: true)
!29 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "eadf4a8bcf7ac4e7bd6d2cb666452242")
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DISubroutineType(types: !32)
!32 = !{!15, !15, !33}
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !36, line: 138, size: 160, elements: !37)
!36 = !DIFile(filename: "/usr/include/bpf/bpf_helpers.h", directory: "", checksumkind: CSK_MD5, checksum: "ffd0067f7d01e4b6afe7c857435f8c2e")
!37 = !{!38, !39, !40, !41, !42}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !35, file: !36, line: 139, baseType: !7, size: 32)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !35, file: !36, line: 140, baseType: !7, size: 32, offset: 32)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !35, file: !36, line: 141, baseType: !7, size: 32, offset: 64)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !35, file: !36, line: 142, baseType: !7, size: 32, offset: 96)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !35, file: !36, line: 143, baseType: !7, size: 32, offset: 128)
!43 = !{i32 7, !"Dwarf Version", i32 5}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{i32 7, !"frame-pointer", i32 2}
!47 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!48 = !{!"clang version 22.0.0git (git@github.com:zachary-kent/llvm-project.git 4d0d826c977a9ef30db88e530c27aef18ab31ed5)"}
!49 = !{!50, !50, i64 0}
!50 = !{!"int", !51, i64 0}
!51 = !{!"omnipotent char", !52, i64 0}
!52 = !{!"Simple C/C++ TBAA"}
!53 = distinct !DISubprogram(name: "toy_example", scope: !3, file: !3, line: 25, type: !54, scopeLine: 26, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !67, keyInstructions: true)
!54 = !DISubroutineType(types: !55)
!55 = !{!56, !57}
!56 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 3164, size: 160, elements: !59)
!59 = !{!60, !63, !64, !65, !66}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !58, file: !6, line: 3165, baseType: !61, size: 32)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !62, line: 27, baseType: !7)
!62 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!63 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !58, file: !6, line: 3166, baseType: !61, size: 32, offset: 32)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !58, file: !6, line: 3167, baseType: !61, size: 32, offset: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !58, file: !6, line: 3169, baseType: !61, size: 32, offset: 96)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !58, file: !6, line: 3170, baseType: !61, size: 32, offset: 128)
!67 = !{!68, !69, !70, !71, !72, !73, !74, !90}
!68 = !DILocalVariable(name: "ctx", arg: 1, scope: !53, file: !3, line: 25, type: !57)
!69 = !DILocalVariable(name: "data_end", scope: !53, file: !3, line: 27, type: !15)
!70 = !DILocalVariable(name: "data", scope: !53, file: !3, line: 28, type: !15)
!71 = !DILocalVariable(name: "lookup_res", scope: !53, file: !3, line: 29, type: !15)
!72 = !DILocalVariable(name: "proto", scope: !53, file: !3, line: 30, type: !61)
!73 = !DILocalVariable(name: "nh_off", scope: !53, file: !3, line: 30, type: !61)
!74 = !DILocalVariable(name: "eth", scope: !53, file: !3, line: 31, type: !75)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !77, line: 163, size: 112, elements: !78)
!77 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "547e20406bda1c07ecd60513a638463c")
!78 = !{!79, !84, !85}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !76, file: !77, line: 164, baseType: !80, size: 48)
!80 = !DICompositeType(tag: DW_TAG_array_type, baseType: !81, size: 48, elements: !82)
!81 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!82 = !{!83}
!83 = !DISubrange(count: 6)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !76, file: !77, line: 165, baseType: !80, size: 48, offset: 48)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !76, file: !77, line: 166, baseType: !86, size: 16, offset: 96)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !87, line: 25, baseType: !88)
!87 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "52ec79a38e49ac7d1dc9e146ba88a7b1")
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !62, line: 24, baseType: !89)
!89 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!90 = !DILocalVariable(name: "key", scope: !53, file: !3, line: 32, type: !91)
!91 = !DICompositeType(tag: DW_TAG_array_type, baseType: !92, size: 48, elements: !82)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !62, line: 21, baseType: !81)
!93 = distinct !DIAssignID()
!94 = !DILocation(line: 0, scope: !53)
!95 = !DILocation(line: 27, column: 41, scope: !53)
!96 = !DILocation(line: 27, column: 41, scope: !53, atomGroup: 1, atomRank: 4)
!97 = !{!98, !50, i64 4}
!98 = !{!"xdp_md", !50, i64 0, !50, i64 4, !50, i64 8, !50, i64 12, !50, i64 16}
!99 = !DILocation(line: 27, column: 30, scope: !53, atomGroup: 1, atomRank: 3)
!100 = !DILocation(line: 27, column: 22, scope: !53, atomGroup: 1, atomRank: 2)
!101 = !DILocation(line: 28, column: 37, scope: !53, atomGroup: 2, atomRank: 4)
!102 = !{!98, !50, i64 0}
!103 = !DILocation(line: 28, column: 26, scope: !53, atomGroup: 2, atomRank: 3)
!104 = !DILocation(line: 28, column: 18, scope: !53, atomGroup: 2, atomRank: 2)
!105 = !DILocation(line: 32, column: 5, scope: !53)
!106 = distinct !DIAssignID()
!107 = !DILocation(line: 35, column: 14, scope: !108)
!108 = distinct !DILexicalBlock(scope: !53, file: !3, line: 35, column: 9)
!109 = !DILocation(line: 35, column: 23, scope: !108, atomGroup: 7, atomRank: 2)
!110 = !DILocation(line: 35, column: 23, scope: !108, atomGroup: 7, atomRank: 1)
!111 = !DILocation(line: 39, column: 18, scope: !53)
!112 = !DILocation(line: 39, column: 18, scope: !53, atomGroup: 9, atomRank: 3)
!113 = !{!114, !115, i64 12}
!114 = !{!"ethhdr", !51, i64 0, !51, i64 6, !115, i64 12}
!115 = !{!"short", !51, i64 0}
!116 = !DILocation(line: 40, column: 15, scope: !117, atomGroup: 10, atomRank: 1)
!117 = distinct !DILexicalBlock(scope: !53, file: !3, line: 40, column: 9)
!118 = !DILocation(line: 41, column: 36, scope: !119)
!119 = distinct !DILexicalBlock(scope: !117, file: !3, line: 40, column: 31)
!120 = !DILocation(line: 41, column: 9, scope: !119, atomGroup: 11, atomRank: 1)
!121 = distinct !DIAssignID()
!122 = !DILocation(line: 42, column: 22, scope: !119, atomGroup: 12, atomRank: 2)
!123 = !DILocation(line: 44, column: 13, scope: !124, atomGroup: 13, atomRank: 2)
!124 = distinct !DILexicalBlock(scope: !119, file: !3, line: 44, column: 13)
!125 = !DILocation(line: 0, scope: !124)
!126 = !DILocation(line: 52, column: 9, scope: !127, atomGroup: 18, atomRank: 1)
!127 = distinct !DILexicalBlock(scope: !128, file: !3, line: 51, column: 12)
!128 = distinct !DILexicalBlock(scope: !117, file: !3, line: 49, column: 16)
!129 = !DILocation(line: 55, column: 1, scope: !53)
!130 = !DILocation(line: 55, column: 1, scope: !53, atomGroup: 19, atomRank: 1)
