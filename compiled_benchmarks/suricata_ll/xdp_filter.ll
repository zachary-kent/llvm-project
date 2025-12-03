; ModuleID = 'xdp_filter.c'
source_filename = "xdp_filter.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.anon.0 = type { ptr, ptr, ptr, ptr }
%struct.anon.2 = type { ptr, ptr, ptr, ptr }
%struct.anon.3 = type { ptr, ptr, ptr, ptr }
%struct.anon.4 = type { ptr, ptr, ptr, ptr }
%struct.anon.5 = type { ptr, ptr, ptr, ptr }
%struct.anon.6 = type { ptr, ptr, ptr, ptr }
%struct.flowv6_keys = type { [4 x i32], [4 x i32], %union.anon.1, i16, i16 }
%union.anon.1 = type { i32 }
%struct.flowv4_keys = type { i32, i32, %union.anon, i16, i16 }
%union.anon = type { i32 }

@__license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@__version = dso_local global i32 263682, section "version", align 4, !dbg !95
@flow_table_v4 = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !97
@flow_table_v6 = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !139
@cpu_map = dso_local global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !163
@cpus_available = dso_local global %struct.anon.3 zeroinitializer, section ".maps", align 8, !dbg !180
@cpus_count = dso_local global %struct.anon.4 zeroinitializer, section ".maps", align 8, !dbg !190
@tx_peer = dso_local global %struct.anon.5 zeroinitializer, section ".maps", align 8, !dbg !202
@tx_peer_int = dso_local global %struct.anon.6 zeroinitializer, section ".maps", align 8, !dbg !215
@llvm.compiler.used = appending global [10 x ptr] [ptr @__license, ptr @__version, ptr @cpu_map, ptr @cpus_available, ptr @cpus_count, ptr @flow_table_v4, ptr @flow_table_v6, ptr @tx_peer, ptr @tx_peer_int, ptr @xdp_hashfilter], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_hashfilter(ptr noundef readonly captures(none) %ctx) #0 section "xdp" !dbg !249 {
entry:
  %tuple.i100 = alloca %struct.flowv6_keys, align 4, !DIAssignID !290
    #dbg_assign(i1 poison, !291, !DIExpression(), !290, ptr %tuple.i100, !DIExpression(), !353)
  %key0.i101 = alloca i32, align 4, !DIAssignID !357
    #dbg_assign(i1 poison, !346, !DIExpression(), !357, ptr %key0.i101, !DIExpression(), !353)
  %cpu_dest.i102 = alloca i32, align 4, !DIAssignID !358
    #dbg_assign(i1 poison, !347, !DIExpression(), !358, ptr %cpu_dest.i102, !DIExpression(), !353)
    #dbg_value(ptr poison, !359, !DIExpression(DW_OP_LLVM_fragment, 0, 16), !372)
    #dbg_value(ptr poison, !359, !DIExpression(DW_OP_LLVM_fragment, 16, 16), !372)
  %tuple.i = alloca %struct.flowv4_keys, align 4, !DIAssignID !374
    #dbg_assign(i1 poison, !375, !DIExpression(), !374, ptr %tuple.i, !DIExpression(), !421)
  %key0.i = alloca i32, align 4, !DIAssignID !423
    #dbg_assign(i1 poison, !414, !DIExpression(), !423, ptr %key0.i, !DIExpression(), !421)
  %cpu_dest.i = alloca i32, align 4, !DIAssignID !424
    #dbg_assign(i1 poison, !415, !DIExpression(), !424, ptr %cpu_dest.i, !DIExpression(), !421)
    #dbg_value(ptr poison, !359, !DIExpression(DW_OP_LLVM_fragment, 0, 16), !425)
    #dbg_value(ptr poison, !359, !DIExpression(DW_OP_LLVM_fragment, 16, 16), !425)
    #dbg_value(ptr %ctx, !261, !DIExpression(), !427)
  %data_end1 = getelementptr inbounds nuw i8, ptr %ctx, i64 4, !dbg !428
  %0 = load i32, ptr %data_end1, align 4, !dbg !429, !tbaa !430
  %conv = zext i32 %0 to i64, !dbg !432
  %1 = inttoptr i64 %conv to ptr, !dbg !433
    #dbg_value(ptr %1, !262, !DIExpression(), !427)
  %2 = load i32, ptr %ctx, align 4, !dbg !434, !tbaa !435
  %conv3 = zext i32 %2 to i64, !dbg !436
  %3 = inttoptr i64 %conv3 to ptr, !dbg !437
    #dbg_value(ptr %3, !263, !DIExpression(), !427)
    #dbg_value(ptr %3, !264, !DIExpression(), !427)
    #dbg_value(i16 0, !277, !DIExpression(), !427)
    #dbg_value(i16 0, !278, !DIExpression(), !427)
    #dbg_value(i64 14, !276, !DIExpression(), !427)
  %add.ptr = getelementptr inbounds nuw i8, ptr %3, i64 14, !dbg !438
  %cmp = icmp samesign ugt ptr %add.ptr, %1, !dbg !440
  br i1 %cmp, label %cleanup58, label %if.end, !dbg !441

if.end:                                           ; preds = %entry
  %h_proto5 = getelementptr inbounds nuw i8, ptr %3, i64 12, !dbg !442
  %4 = load i16, ptr %h_proto5, align 1, !dbg !443, !tbaa !444
    #dbg_value(i16 %4, !275, !DIExpression(), !427)
  %cmp7 = icmp eq i16 %4, 129, !dbg !447
  %cmp10 = icmp eq i16 %4, -22392
  %5 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %cmp7)
  %or.cond = select i1 %5, i1 true, i1 %cmp10, !dbg !448
  br i1 %or.cond, label %if.then12, label %if.end21, !dbg !448

if.then12:                                        ; preds = %if.end
    #dbg_value(ptr %add.ptr, !279, !DIExpression(), !449)
    #dbg_value(i64 18, !276, !DIExpression(), !427)
  %add.ptr14 = getelementptr inbounds nuw i8, ptr %3, i64 18, !dbg !450
  %cmp15.not = icmp samesign ugt ptr %add.ptr14, %1, !dbg !452
  br i1 %cmp15.not, label %cleanup58, label %if.end18, !dbg !453

if.end18:                                         ; preds = %if.then12
  %h_vlan_encapsulated_proto = getelementptr inbounds nuw i8, ptr %3, i64 16, !dbg !454
  %6 = load i16, ptr %h_vlan_encapsulated_proto, align 2, !dbg !455, !tbaa !456
    #dbg_value(i16 %6, !275, !DIExpression(), !427)
  %7 = load i16, ptr %add.ptr, align 2, !dbg !458, !tbaa !459
    #dbg_value(i16 %7, !277, !DIExpression(DW_OP_constu, 4095, DW_OP_and, DW_OP_stack_value), !427)
  %8 = shl i16 %7, 1, !dbg !460
  %9 = and i16 %8, 8190, !dbg !460
  br label %if.end21

if.end21:                                         ; preds = %if.end18, %if.end
  %nh_off.0 = phi i64 [ 18, %if.end18 ], [ 14, %if.end ], !dbg !427
  %vlan0.1 = phi i16 [ %9, %if.end18 ], [ 0, %if.end ], !dbg !461
  %h_proto.1 = phi i16 [ %6, %if.end18 ], [ %4, %if.end ], !dbg !462
    #dbg_value(i16 %h_proto.1, !275, !DIExpression(), !427)
    #dbg_value(i16 %vlan0.1, !277, !DIExpression(), !427)
    #dbg_value(i64 %nh_off.0, !276, !DIExpression(), !427)
  %cmp23 = icmp eq i16 %h_proto.1, 129, !dbg !463
  %cmp27 = icmp eq i16 %h_proto.1, -22392
  %10 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 1, i1 %cmp23)
  %or.cond66 = select i1 %10, i1 true, i1 %cmp27, !dbg !464
  br i1 %or.cond66, label %if.then29, label %if.end46, !dbg !464

if.then29:                                        ; preds = %if.end21
    #dbg_value(!DIArgList(ptr %3, i64 %nh_off.0), !287, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !465)
  %add32 = add nuw nsw i64 %nh_off.0, 4, !dbg !466
    #dbg_value(i64 %add32, !276, !DIExpression(), !427)
  %add.ptr33 = getelementptr inbounds nuw i8, ptr %3, i64 %add32, !dbg !467
  %cmp34.not = icmp samesign ugt ptr %add.ptr33, %1, !dbg !469
  br i1 %cmp34.not, label %cleanup58, label %if.end37, !dbg !470

if.end37:                                         ; preds = %if.then29
  %add.ptr31 = getelementptr inbounds nuw i8, ptr %3, i64 %nh_off.0, !dbg !471
    #dbg_value(ptr %add.ptr31, !287, !DIExpression(), !465)
  %h_vlan_encapsulated_proto38 = getelementptr inbounds nuw i8, ptr %add.ptr31, i64 2, !dbg !472
  %11 = load i16, ptr %h_vlan_encapsulated_proto38, align 2, !dbg !473, !tbaa !456
    #dbg_value(i16 %11, !275, !DIExpression(), !427)
  %12 = load i16, ptr %add.ptr31, align 2, !dbg !474, !tbaa !459
  %13 = and i16 %12, 4095, !dbg !475
    #dbg_value(i16 %13, !278, !DIExpression(), !427)
  br label %if.end46

if.end46:                                         ; preds = %if.end37, %if.end21
  %nh_off.1 = phi i64 [ %add32, %if.end37 ], [ %nh_off.0, %if.end21 ], !dbg !427
  %vlan1.1 = phi i16 [ %13, %if.end37 ], [ 0, %if.end21 ], !dbg !476
  %h_proto.3 = phi i16 [ %11, %if.end37 ], [ %h_proto.1, %if.end21 ], !dbg !462
    #dbg_value(i16 %h_proto.3, !275, !DIExpression(), !427)
    #dbg_value(i16 %vlan1.1, !278, !DIExpression(), !427)
    #dbg_value(i64 %nh_off.1, !276, !DIExpression(), !427)
  switch i16 %h_proto.3, label %cleanup58 [
    i16 8, label %if.then50
    i16 -8826, label %if.then54
  ], !dbg !477

if.then50:                                        ; preds = %if.end46
    #dbg_value(ptr %ctx, !378, !DIExpression(), !421)
    #dbg_value(ptr %3, !379, !DIExpression(), !421)
    #dbg_value(i64 %nh_off.1, !380, !DIExpression(), !421)
    #dbg_value(ptr %1, !381, !DIExpression(), !421)
    #dbg_value(i16 %vlan0.1, !382, !DIExpression(), !421)
    #dbg_value(i16 %vlan1.1, !383, !DIExpression(), !421)
  %add.ptr.i = getelementptr inbounds nuw i8, ptr %3, i64 %nh_off.1, !dbg !478
    #dbg_value(ptr %add.ptr.i, !384, !DIExpression(), !421)
  call void @llvm.lifetime.start.p0(ptr nonnull %tuple.i) #4, !dbg !479
  call void @llvm.lifetime.start.p0(ptr nonnull %key0.i) #4, !dbg !480
  store i32 0, ptr %key0.i, align 4, !dbg !481, !tbaa !245, !DIAssignID !482
    #dbg_assign(i32 0, !414, !DIExpression(), !482, ptr %key0.i, !DIExpression(), !421)
  call void @llvm.lifetime.start.p0(ptr nonnull %cpu_dest.i) #4, !dbg !483
  %call.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_count, ptr noundef nonnull %key0.i) #4, !dbg !484
    #dbg_value(ptr %call.i, !416, !DIExpression(), !421)
    #dbg_value(i32 0, !420, !DIExpression(), !421)
  %add.ptr1.i = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 20, !dbg !485
  %cmp.i = icmp ugt ptr %add.ptr1.i, %1, !dbg !487
  br i1 %cmp.i, label %filter_ipv4.exit, label %if.end.i, !dbg !488

if.end.i:                                         ; preds = %if.then50
  %protocol.i = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 9, !dbg !489
  %14 = load i8, ptr %protocol.i, align 1, !dbg !489, !tbaa !491
  %cmp2.i = icmp eq i8 %14, 6, !dbg !493
  %ip_proto.i = getelementptr inbounds nuw i8, ptr %tuple.i, i64 12, !dbg !494
  %masksel = zext i1 %cmp2.i to i16, !dbg !495
  %15 = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 12, !dbg !496
  %16 = load i32, ptr %15, align 4, !dbg !497, !tbaa !498
  store i32 %16, ptr %tuple.i, align 4, !dbg !499, !tbaa !500, !DIAssignID !502
    #dbg_assign(i32 %16, !375, !DIExpression(DW_OP_LLVM_fragment, 0, 32), !502, ptr %tuple.i, !DIExpression(), !421)
  %daddr.i = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 16, !dbg !503
  %17 = load i32, ptr %daddr.i, align 4, !dbg !504, !tbaa !498
  %dst.i = getelementptr inbounds nuw i8, ptr %tuple.i, i64 4, !dbg !505
  store i32 %17, ptr %dst.i, align 4, !dbg !506, !tbaa !507, !DIAssignID !508
    #dbg_assign(i32 %17, !375, !DIExpression(DW_OP_LLVM_fragment, 32, 32), !508, ptr %dst.i, !DIExpression(), !421)
    #dbg_value(ptr %add.ptr1.i, !509, !DIExpression(), !518)
    #dbg_value(ptr %1, !514, !DIExpression(), !518)
    #dbg_value(i8 %14, !515, !DIExpression(), !518)
  switch i8 %14, label %if.end23.i [
    i8 6, label %sw.bb.i145
    i8 17, label %sw.bb3.i138
  ], !dbg !520

sw.bb.i145:                                       ; preds = %if.end.i
    #dbg_value(ptr %add.ptr1.i, !516, !DIExpression(), !518)
  %add.ptr.i146 = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 40, !dbg !521
  %cmp.i147 = icmp ugt ptr %add.ptr.i146, %1, !dbg !524
    #dbg_value(i16 poison, !411, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !421)
    #dbg_value(ptr %add.ptr1.i, !525, !DIExpression(), !532)
    #dbg_value(ptr %1, !528, !DIExpression(), !532)
    #dbg_value(i8 %14, !529, !DIExpression(), !532)
    #dbg_value(ptr %add.ptr1.i, !530, !DIExpression(), !532)
  br i1 %cmp.i147, label %filter_ipv4.exit, label %if.end.i172, !dbg !534

sw.bb3.i138:                                      ; preds = %if.end.i
    #dbg_value(ptr %add.ptr1.i, !517, !DIExpression(), !518)
  %add.ptr4.i139 = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 28, !dbg !535
  %cmp5.i140 = icmp ugt ptr %add.ptr4.i139, %1, !dbg !537
    #dbg_value(i16 poison, !411, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !421)
    #dbg_value(ptr %add.ptr1.i, !525, !DIExpression(), !532)
    #dbg_value(ptr %1, !528, !DIExpression(), !532)
    #dbg_value(i8 %14, !529, !DIExpression(), !532)
    #dbg_value(ptr %add.ptr1.i, !531, !DIExpression(), !532)
  br i1 %cmp5.i140, label %filter_ipv4.exit, label %if.end8.i166, !dbg !538

if.end.i172:                                      ; preds = %sw.bb.i145
  %dest.i149 = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 22, !dbg !539
  %18 = load i16, ptr %dest.i149, align 2, !dbg !540, !tbaa !541
    #dbg_value(i16 %18, !411, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !421)
  %19 = load i16, ptr %add.ptr1.i, align 4, !dbg !543, !tbaa !545
  br label %if.end23.i, !dbg !546

if.end8.i166:                                     ; preds = %sw.bb3.i138
  %dest9.i142 = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 22, !dbg !547
  %20 = load i16, ptr %dest9.i142, align 2, !dbg !548, !tbaa !549
    #dbg_value(i16 %20, !411, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !421)
  %21 = load i16, ptr %add.ptr1.i, align 2, !dbg !551, !tbaa !552
  br label %if.end23.i, !dbg !553

if.end23.i:                                       ; preds = %if.end.i, %if.end.i172, %if.end8.i166
  %retval.0.i144.ph211.ph.shrunk = phi i16 [ %20, %if.end8.i166 ], [ %18, %if.end.i172 ], [ 0, %if.end.i ]
  %retval.0.i168.ph.shrunk = phi i16 [ %21, %if.end8.i166 ], [ %19, %if.end.i172 ], [ 0, %if.end.i ]
    #dbg_value(i16 %retval.0.i168.ph.shrunk, !412, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !421)
  %22 = getelementptr inbounds nuw i8, ptr %tuple.i, i64 8, !dbg !554
  store i16 %retval.0.i168.ph.shrunk, ptr %22, align 4, !dbg !555, !tbaa !498, !DIAssignID !556
    #dbg_assign(i16 %retval.0.i168.ph.shrunk, !375, !DIExpression(DW_OP_LLVM_fragment, 64, 16), !556, ptr %22, !DIExpression(), !421)
  %arrayidx26.i = getelementptr inbounds nuw i8, ptr %tuple.i, i64 10, !dbg !557
  store i16 %retval.0.i144.ph211.ph.shrunk, ptr %arrayidx26.i, align 2, !dbg !558, !tbaa !498, !DIAssignID !559
    #dbg_assign(i16 %retval.0.i144.ph211.ph.shrunk, !375, !DIExpression(DW_OP_LLVM_fragment, 80, 16), !559, ptr %arrayidx26.i, !DIExpression(), !421)
  %bf.set30.i = or disjoint i16 %vlan0.1, %masksel, !dbg !560
  store i16 %bf.set30.i, ptr %ip_proto.i, align 4, !dbg !561, !DIAssignID !562
    #dbg_assign(i16 %bf.set30.i, !375, !DIExpression(DW_OP_LLVM_fragment, 96, 16), !562, ptr %ip_proto.i, !DIExpression(), !421)
  %vlan131.i = getelementptr inbounds nuw i8, ptr %tuple.i, i64 14, !dbg !563
  store i16 %vlan1.1, ptr %vlan131.i, align 2, !dbg !564, !tbaa !565, !DIAssignID !566
    #dbg_assign(i16 %vlan1.1, !375, !DIExpression(DW_OP_LLVM_fragment, 112, 16), !566, ptr %vlan131.i, !DIExpression(), !421)
  %call32.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @flow_table_v4, ptr noundef nonnull %tuple.i) #4, !dbg !567
    #dbg_value(ptr %call32.i, !413, !DIExpression(), !421)
  %tobool.not.i = icmp eq ptr %call32.i, null, !dbg !568
  br i1 %tobool.not.i, label %if.end41.i, label %if.then33.i, !dbg !570

if.then33.i:                                      ; preds = %if.end23.i
  %23 = load i64, ptr %call32.i, align 8, !dbg !571, !tbaa !573
  %inc.i = add i64 %23, 1, !dbg !576
  store i64 %inc.i, ptr %call32.i, align 8, !dbg !577, !tbaa !573
  %sub.ptr.sub.i = sub nsw i64 %conv, %conv3, !dbg !578
  %bytes.i = getelementptr inbounds nuw i8, ptr %call32.i, i64 8, !dbg !579
  %24 = load i64, ptr %bytes.i, align 8, !dbg !580, !tbaa !581
  %add.i = add i64 %sub.ptr.sub.i, %24, !dbg !582
  store i64 %add.i, ptr %bytes.i, align 8, !dbg !583, !tbaa !581
  %call34.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tx_peer_int, ptr noundef nonnull %key0.i) #4, !dbg !584
    #dbg_value(ptr %call34.i, !419, !DIExpression(), !421)
  %tobool35.not.i = icmp eq ptr %call34.i, null, !dbg !585
  br i1 %tobool35.not.i, label %filter_ipv4.exit, label %if.else37.i, !dbg !587

if.else37.i:                                      ; preds = %if.then33.i
  %call39.i = call i64 inttoptr (i64 51 to ptr)(ptr noundef nonnull @tx_peer, i64 noundef 0, i64 noundef 0) #4, !dbg !588
  %conv40.i = trunc i64 %call39.i to i32, !dbg !590
  br label %filter_ipv4.exit, !dbg !591

if.end41.i:                                       ; preds = %if.end23.i
  %25 = load i32, ptr %tuple.i, align 4, !dbg !592, !tbaa !500
  %26 = load i32, ptr %dst.i, align 4, !dbg !593, !tbaa !507
  %add44.i = add i32 %26, %25, !dbg !594
    #dbg_value(i32 %add44.i, !418, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !421)
    #dbg_value(i32 %add44.i, !418, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !421)
  %27 = load i8, ptr %protocol.i, align 1, !dbg !595, !tbaa !491
  %conv46.i = zext i8 %27 to i32, !dbg !596
  %add47.i = add nuw nsw i32 %conv46.i, 15485863, !dbg !597
    #dbg_value(i32 %add47.i, !368, !DIExpression(), !425)
    #dbg_value(i32 0, !371, !DIExpression(), !425)
    #dbg_value(i32 poison, !367, !DIExpression(), !425)
    #dbg_value(ptr undef, !359, !DIExpression(), !425)
    #dbg_value(i32 %add47.i, !369, !DIExpression(), !425)
  %conv.i195 = and i32 %add44.i, 65535, !dbg !598
  %add.i196 = add nuw nsw i32 %add47.i, %conv.i195, !dbg !602
    #dbg_value(i32 %add.i196, !369, !DIExpression(), !425)
  %28 = lshr i32 %add44.i, 5, !dbg !603
  %shl.i199 = and i32 %28, 134215680, !dbg !603
    #dbg_value(!DIArgList(i32 %shl.i199, i32 %add.i196), !370, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_xor, DW_OP_stack_value), !425)
  %shl4.i200 = shl i32 %add.i196, 16, !dbg !604
  %29 = xor i32 %shl4.i200, %shl.i199, !dbg !605
  %xor5.i201 = xor i32 %29, %add.i196, !dbg !605
    #dbg_value(i32 %xor5.i201, !369, !DIExpression(), !425)
    #dbg_value(ptr undef, !359, !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value), !425)
  %shr7.i203 = lshr i32 %xor5.i201, 11, !dbg !606
  %add8.i204 = add i32 %shr7.i203, %xor5.i201, !dbg !607
    #dbg_value(!DIArgList(i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !425)
  %shl32.i182 = shl i32 %add8.i204, 3, !dbg !608
  %xor33.i183 = xor i32 %shl32.i182, %add8.i204, !dbg !609
  %shr34.i184 = lshr i32 %xor33.i183, 5, !dbg !610
  %add35.i185 = add i32 %shr34.i184, %xor33.i183, !dbg !611
    #dbg_value(!DIArgList(i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !425)
  %shl36.i186 = shl i32 %add35.i185, 4, !dbg !612
    #dbg_value(!DIArgList(i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %add35.i185, i32 %shl36.i186, i32 %shl36.i186, i32 %shl36.i186, i32 %shl36.i186, i32 %shl36.i186, i32 %shl36.i186, i32 %shl36.i186, i32 %shl36.i186), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !425)
  %xor37.i187 = xor i32 %shl36.i186, %add35.i185, !dbg !613
    #dbg_value(!DIArgList(i32 %xor37.i187, i32 %xor37.i187, i32 %xor37.i187, i32 %xor37.i187, i32 %xor37.i187, i32 %xor37.i187, i32 %xor37.i187, i32 %xor37.i187), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !425)
  %shr38.i188 = lshr i32 %xor37.i187, 17, !dbg !614
    #dbg_value(!DIArgList(i32 %xor37.i187, i32 %xor37.i187, i32 %xor37.i187, i32 %xor37.i187, i32 %shr38.i188, i32 %shr38.i188, i32 %shr38.i188, i32 %shr38.i188), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !425)
  %add39.i189 = add i32 %shr38.i188, %xor37.i187, !dbg !615
    #dbg_value(!DIArgList(i32 %add39.i189, i32 %add39.i189, i32 %add39.i189, i32 %add39.i189), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !425)
  %shl40.i190 = shl i32 %add39.i189, 25, !dbg !616
    #dbg_value(!DIArgList(i32 %add39.i189, i32 %add39.i189, i32 %shl40.i190, i32 %shl40.i190), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !425)
  %xor41.i191 = xor i32 %shl40.i190, %add39.i189, !dbg !617
    #dbg_value(!DIArgList(i32 %xor41.i191, i32 %xor41.i191), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !425)
  %shr42.i192 = lshr i32 %xor41.i191, 6, !dbg !618
    #dbg_value(!DIArgList(i32 %xor41.i191, i32 %shr42.i192), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !425)
  %add43.i193 = add i32 %shr42.i192, %xor41.i191, !dbg !619
    #dbg_value(i32 %add43.i193, !369, !DIExpression(), !425)
    #dbg_value(i32 %add43.i193, !418, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !421)
    #dbg_value(i32 %add43.i193, !418, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !421)
  %tobool49.not.i = icmp eq ptr %call.i, null, !dbg !620
  br i1 %tobool49.not.i, label %filter_ipv4.exit, label %land.lhs.true.i, !dbg !622

land.lhs.true.i:                                  ; preds = %if.end41.i
  %30 = load i32, ptr %call.i, align 4, !dbg !623, !tbaa !245
  %tobool50.not.i = icmp eq i32 %30, 0, !dbg !624
  br i1 %tobool50.not.i, label %filter_ipv4.exit, label %if.then51.i, !dbg !625

if.then51.i:                                      ; preds = %land.lhs.true.i
  %rem.i = urem i32 %add43.i193, %30, !dbg !626
  store i32 %rem.i, ptr %cpu_dest.i, align 4, !dbg !628, !tbaa !245, !DIAssignID !629
    #dbg_assign(i32 %rem.i, !415, !DIExpression(), !629, ptr %cpu_dest.i, !DIExpression(), !421)
  %call52.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_available, ptr noundef nonnull %cpu_dest.i) #4, !dbg !630
    #dbg_value(ptr %call52.i, !417, !DIExpression(), !421)
  %tobool53.not.i = icmp eq ptr %call52.i, null, !dbg !631
  br i1 %tobool53.not.i, label %filter_ipv4.exit, label %if.end55.i, !dbg !633

if.end55.i:                                       ; preds = %if.then51.i
  %31 = load i32, ptr %call52.i, align 4, !dbg !634, !tbaa !245
  store i32 %31, ptr %cpu_dest.i, align 4, !dbg !635, !tbaa !245, !DIAssignID !636
    #dbg_assign(i32 %31, !415, !DIExpression(), !636, ptr %cpu_dest.i, !DIExpression(), !421)
  %conv56.i = zext i32 %31 to i64, !dbg !637
  %call57.i = call i64 inttoptr (i64 51 to ptr)(ptr noundef nonnull @cpu_map, i64 noundef %conv56.i, i64 noundef 0) #4, !dbg !638
  %conv58.i = trunc i64 %call57.i to i32, !dbg !639
  br label %filter_ipv4.exit, !dbg !640

filter_ipv4.exit:                                 ; preds = %sw.bb3.i138, %sw.bb.i145, %if.then50, %if.then33.i, %if.else37.i, %if.end41.i, %land.lhs.true.i, %if.then51.i, %if.end55.i
  %retval.0.i = phi i32 [ %conv40.i, %if.else37.i ], [ %conv58.i, %if.end55.i ], [ 2, %if.then50 ], [ 1, %if.then33.i ], [ 0, %if.then51.i ], [ 2, %land.lhs.true.i ], [ 2, %if.end41.i ], [ 2, %sw.bb.i145 ], [ 2, %sw.bb3.i138 ], !dbg !421
  call void @llvm.lifetime.end.p0(ptr nonnull %cpu_dest.i) #4, !dbg !641
  call void @llvm.lifetime.end.p0(ptr nonnull %key0.i) #4, !dbg !641
  call void @llvm.lifetime.end.p0(ptr nonnull %tuple.i) #4, !dbg !641
  br label %cleanup58, !dbg !642

if.then54:                                        ; preds = %if.end46
    #dbg_value(ptr %ctx, !296, !DIExpression(), !353)
    #dbg_value(ptr %3, !297, !DIExpression(), !353)
    #dbg_value(i64 %nh_off.1, !298, !DIExpression(), !353)
    #dbg_value(ptr %1, !299, !DIExpression(), !353)
    #dbg_value(i16 %vlan0.1, !300, !DIExpression(), !353)
    #dbg_value(i16 %vlan1.1, !301, !DIExpression(), !353)
  %add.ptr.i104 = getelementptr inbounds nuw i8, ptr %3, i64 %nh_off.1, !dbg !643
    #dbg_value(ptr %add.ptr.i104, !302, !DIExpression(), !353)
  call void @llvm.lifetime.start.p0(ptr nonnull %tuple.i100) #4, !dbg !644
  call void @llvm.lifetime.start.p0(ptr nonnull %key0.i101) #4, !dbg !645
  store i32 0, ptr %key0.i101, align 4, !dbg !646, !tbaa !245, !DIAssignID !647
    #dbg_assign(i32 0, !346, !DIExpression(), !647, ptr %key0.i101, !DIExpression(), !353)
  call void @llvm.lifetime.start.p0(ptr nonnull %cpu_dest.i102) #4, !dbg !648
  %call.i105 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_count, ptr noundef nonnull %key0.i101) #4, !dbg !649
    #dbg_value(ptr %call.i105, !348, !DIExpression(), !353)
    #dbg_value(i32 0, !351, !DIExpression(), !353)
  %add.ptr1.i106 = getelementptr inbounds nuw i8, ptr %add.ptr.i104, i64 40, !dbg !650
  %cmp.i107 = icmp ugt ptr %add.ptr1.i106, %1, !dbg !652
  br i1 %cmp.i107, label %filter_ipv6.exit, label %if.end.i108, !dbg !653

if.end.i108:                                      ; preds = %if.then54
  %nexthdr.i = getelementptr inbounds nuw i8, ptr %add.ptr.i104, i64 6, !dbg !654
  %32 = load i8, ptr %nexthdr.i, align 2, !dbg !654, !tbaa !656
  switch i8 %32, label %filter_ipv6.exit [
    i8 6, label %sw.bb.i
    i8 17, label %sw.bb3.i
  ], !dbg !658

sw.bb.i:                                          ; preds = %if.end.i108
    #dbg_value(ptr %add.ptr1.i106, !516, !DIExpression(), !659)
  %add.ptr.i135 = getelementptr inbounds nuw i8, ptr %add.ptr.i104, i64 60, !dbg !661
  %cmp.i136 = icmp ugt ptr %add.ptr.i135, %1, !dbg !662
    #dbg_value(i16 poison, !343, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !353)
    #dbg_value(ptr %add.ptr1.i106, !525, !DIExpression(), !663)
    #dbg_value(ptr %1, !528, !DIExpression(), !663)
    #dbg_value(i8 %32, !529, !DIExpression(), !663)
    #dbg_value(ptr %add.ptr1.i106, !530, !DIExpression(), !663)
  br i1 %cmp.i136, label %filter_ipv6.exit, label %if.end23.i115.thread, !dbg !665

sw.bb3.i:                                         ; preds = %if.end.i108
    #dbg_value(ptr %add.ptr1.i106, !517, !DIExpression(), !659)
  %add.ptr4.i = getelementptr inbounds nuw i8, ptr %add.ptr.i104, i64 48, !dbg !666
  %cmp5.i = icmp ugt ptr %add.ptr4.i, %1, !dbg !667
    #dbg_value(i16 poison, !343, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !353)
    #dbg_value(ptr %add.ptr1.i106, !525, !DIExpression(), !663)
    #dbg_value(ptr %1, !528, !DIExpression(), !663)
    #dbg_value(i8 %32, !529, !DIExpression(), !663)
    #dbg_value(ptr %add.ptr1.i106, !531, !DIExpression(), !663)
  br i1 %cmp5.i, label %filter_ipv6.exit, label %if.end23.i115.thread246, !dbg !668

if.end23.i115.thread:                             ; preds = %sw.bb.i
    #dbg_value(i16 poison, !343, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !353)
    #dbg_value(i16 poison, !344, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !353)
  %ip_proto.i116237 = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 36, !dbg !669
    #dbg_assign(i16 -1, !291, !DIExpression(DW_OP_LLVM_fragment, 288, 16), !671, ptr %ip_proto.i116237, !DIExpression(), !353)
  %33 = or disjoint i16 %vlan0.1, 1, !dbg !672
  br label %if.end33.i, !dbg !673

if.end23.i115.thread246:                          ; preds = %sw.bb3.i
    #dbg_value(i16 poison, !343, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !353)
    #dbg_value(i16 poison, !344, !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_stack_value), !353)
  %ip_proto.i116250 = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 36, !dbg !669
    #dbg_assign(i16 0, !291, !DIExpression(DW_OP_LLVM_fragment, 288, 16), !675, ptr %ip_proto.i116250, !DIExpression(), !353)
  br label %if.end33.i

if.end33.i:                                       ; preds = %if.end23.i115.thread246, %if.end23.i115.thread
  %bf.load42.i = phi i16 [ %vlan0.1, %if.end23.i115.thread246 ], [ %33, %if.end23.i115.thread ], !dbg !460
  %ip_proto.i116244 = phi ptr [ %ip_proto.i116250, %if.end23.i115.thread246 ], [ %ip_proto.i116237, %if.end23.i115.thread ]
  %retval.0.i134.ph225.ph239.in.in = getelementptr inbounds nuw i8, ptr %add.ptr.i104, i64 42, !dbg !676
  %retval.0.i134.ph225.ph239.in = load i16, ptr %retval.0.i134.ph225.ph239.in.in, align 2, !dbg !676, !tbaa !677
  %retval.0.i157.ph241.in = load i16, ptr %add.ptr1.i106, align 2, !dbg !678, !tbaa !677
  %34 = getelementptr inbounds nuw i8, ptr %add.ptr.i104, i64 8, !dbg !679
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %tuple.i100, ptr noundef nonnull align 4 dereferenceable(16) %34, i64 16, i1 false), !dbg !680, !DIAssignID !681
    #dbg_assign(i1 poison, !291, !DIExpression(DW_OP_LLVM_fragment, 0, 128), !681, ptr %tuple.i100, !DIExpression(), !353)
  %dst.i119 = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 16, !dbg !682
  %daddr.i120 = getelementptr inbounds nuw i8, ptr %add.ptr.i104, i64 24, !dbg !683
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %dst.i119, ptr noundef nonnull align 4 dereferenceable(16) %daddr.i120, i64 16, i1 false), !dbg !684, !DIAssignID !685
    #dbg_assign(i1 poison, !291, !DIExpression(DW_OP_LLVM_fragment, 128, 128), !685, ptr %dst.i119, !DIExpression(), !353)
  %35 = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 32, !dbg !686
  store i16 %retval.0.i157.ph241.in, ptr %35, align 4, !dbg !687, !tbaa !498, !DIAssignID !688
    #dbg_assign(i16 %retval.0.i157.ph241.in, !291, !DIExpression(DW_OP_LLVM_fragment, 256, 16), !688, ptr %35, !DIExpression(), !353)
  %arrayidx40.i = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 34, !dbg !689
  store i16 %retval.0.i134.ph225.ph239.in, ptr %arrayidx40.i, align 2, !dbg !690, !tbaa !498, !DIAssignID !691
    #dbg_assign(i16 %retval.0.i134.ph225.ph239.in, !291, !DIExpression(DW_OP_LLVM_fragment, 272, 16), !691, ptr %arrayidx40.i, !DIExpression(), !353)
  store i16 %bf.load42.i, ptr %ip_proto.i116244, align 4, !dbg !692, !DIAssignID !693
    #dbg_assign(i16 %bf.load42.i, !291, !DIExpression(DW_OP_LLVM_fragment, 288, 16), !693, ptr %ip_proto.i116244, !DIExpression(), !353)
  %vlan145.i = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 38, !dbg !694
  store i16 %vlan1.1, ptr %vlan145.i, align 2, !dbg !695, !tbaa !696, !DIAssignID !698
    #dbg_assign(i16 %vlan1.1, !291, !DIExpression(DW_OP_LLVM_fragment, 304, 16), !698, ptr %vlan145.i, !DIExpression(), !353)
  %call46.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @flow_table_v6, ptr noundef nonnull %tuple.i100) #4, !dbg !699
    #dbg_value(ptr %call46.i, !345, !DIExpression(), !353)
  %tobool.not.i122 = icmp eq ptr %call46.i, null, !dbg !700
  br i1 %tobool.not.i122, label %if.end55.i130, label %if.then47.i, !dbg !702

if.then47.i:                                      ; preds = %if.end33.i
  %36 = load i64, ptr %call46.i, align 8, !dbg !703, !tbaa !573
  %inc.i123 = add i64 %36, 1, !dbg !705
  store i64 %inc.i123, ptr %call46.i, align 8, !dbg !706, !tbaa !573
  %sub.ptr.sub.i124 = sub nsw i64 %conv, %conv3, !dbg !707
  %bytes.i125 = getelementptr inbounds nuw i8, ptr %call46.i, i64 8, !dbg !708
  %37 = load i64, ptr %bytes.i125, align 8, !dbg !709, !tbaa !581
  %add.i126 = add i64 %sub.ptr.sub.i124, %37, !dbg !710
  store i64 %add.i126, ptr %bytes.i125, align 8, !dbg !711, !tbaa !581
  %call48.i127 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tx_peer_int, ptr noundef nonnull %key0.i101) #4, !dbg !712
    #dbg_value(ptr %call48.i127, !352, !DIExpression(), !353)
  %tobool49.not.i128 = icmp eq ptr %call48.i127, null, !dbg !713
  br i1 %tobool49.not.i128, label %filter_ipv6.exit, label %if.else51.i, !dbg !715

if.else51.i:                                      ; preds = %if.then47.i
  %call53.i = call i64 inttoptr (i64 51 to ptr)(ptr noundef nonnull @tx_peer, i64 noundef 0, i64 noundef 0) #4, !dbg !716
  %conv54.i = trunc i64 %call53.i to i32, !dbg !718
  br label %filter_ipv6.exit, !dbg !719

if.end55.i130:                                    ; preds = %if.end33.i
  %38 = load i32, ptr %tuple.i100, align 4, !dbg !720, !tbaa !245
  %39 = load i32, ptr %dst.i119, align 4, !dbg !721, !tbaa !245
  %add60.i = add i32 %39, %38, !dbg !722
    #dbg_value(i32 %add60.i, !350, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !353)
    #dbg_value(i32 %add60.i, !350, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !353)
  %arrayidx62.i = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 4, !dbg !723
  %40 = load i32, ptr %arrayidx62.i, align 4, !dbg !723, !tbaa !245
  %arrayidx64.i = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 20, !dbg !724
  %41 = load i32, ptr %arrayidx64.i, align 4, !dbg !724, !tbaa !245
  %add65.i = add i32 %40, %add60.i, !dbg !725
  %add66.i = add i32 %add65.i, %41, !dbg !726
    #dbg_value(i32 %add66.i, !350, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !353)
    #dbg_value(i32 %add66.i, !350, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !353)
  %arrayidx68.i = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 8, !dbg !727
  %42 = load i32, ptr %arrayidx68.i, align 4, !dbg !727, !tbaa !245
  %arrayidx70.i = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 24, !dbg !728
  %43 = load i32, ptr %arrayidx70.i, align 4, !dbg !728, !tbaa !245
  %add71.i = add i32 %add66.i, %42, !dbg !729
  %add72.i = add i32 %add71.i, %43, !dbg !730
    #dbg_value(i32 %add72.i, !350, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !353)
    #dbg_value(i32 %add72.i, !350, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !353)
  %arrayidx74.i = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 12, !dbg !731
  %44 = load i32, ptr %arrayidx74.i, align 4, !dbg !731, !tbaa !245
  %arrayidx76.i = getelementptr inbounds nuw i8, ptr %tuple.i100, i64 28, !dbg !732
  %45 = load i32, ptr %arrayidx76.i, align 4, !dbg !732, !tbaa !245
  %add77.i = add i32 %add72.i, %44, !dbg !733
  %add78.i = add i32 %add77.i, %45, !dbg !734
    #dbg_value(i32 %add78.i, !350, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !353)
    #dbg_value(i32 %add78.i, !350, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !353)
    #dbg_value(i32 15485863, !368, !DIExpression(), !372)
    #dbg_value(i32 0, !371, !DIExpression(), !372)
    #dbg_value(i32 poison, !367, !DIExpression(), !372)
    #dbg_value(ptr undef, !359, !DIExpression(), !372)
    #dbg_value(i32 15485863, !369, !DIExpression(), !372)
  %conv.i = and i32 %add78.i, 65535, !dbg !735
  %add.i176 = add nuw nsw i32 %conv.i, 15485863, !dbg !736
    #dbg_value(i32 %add.i176, !369, !DIExpression(), !372)
  %46 = lshr i32 %add78.i, 5, !dbg !737
  %shl.i = and i32 %46, 134215680, !dbg !737
    #dbg_value(!DIArgList(i32 %shl.i, i32 %add.i176), !370, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_xor, DW_OP_stack_value), !372)
  %shl4.i = shl i32 %add.i176, 16, !dbg !738
  %47 = xor i32 %shl4.i, %shl.i, !dbg !739
  %xor5.i = xor i32 %47, %add.i176, !dbg !739
    #dbg_value(i32 %xor5.i, !369, !DIExpression(), !372)
    #dbg_value(ptr undef, !359, !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value), !372)
  %shr7.i = lshr i32 %xor5.i, 11, !dbg !740
  %add8.i = add i32 %shr7.i, %xor5.i, !dbg !741
    #dbg_value(!DIArgList(i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !372)
  %shl32.i = shl i32 %add8.i, 3, !dbg !742
  %xor33.i = xor i32 %shl32.i, %add8.i, !dbg !743
  %shr34.i = lshr i32 %xor33.i, 5, !dbg !744
  %add35.i = add i32 %shr34.i, %xor33.i, !dbg !745
    #dbg_value(!DIArgList(i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !372)
  %shl36.i = shl i32 %add35.i, 4, !dbg !746
    #dbg_value(!DIArgList(i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !372)
  %xor37.i = xor i32 %shl36.i, %add35.i, !dbg !747
    #dbg_value(!DIArgList(i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !372)
  %shr38.i = lshr i32 %xor37.i, 17, !dbg !748
    #dbg_value(!DIArgList(i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %shr38.i, i32 %shr38.i, i32 %shr38.i, i32 %shr38.i), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !372)
  %add39.i = add i32 %shr38.i, %xor37.i, !dbg !749
    #dbg_value(!DIArgList(i32 %add39.i, i32 %add39.i, i32 %add39.i, i32 %add39.i), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !372)
  %shl40.i = shl i32 %add39.i, 25, !dbg !750
    #dbg_value(!DIArgList(i32 %add39.i, i32 %add39.i, i32 %shl40.i, i32 %shl40.i), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !372)
  %xor41.i = xor i32 %shl40.i, %add39.i, !dbg !751
    #dbg_value(!DIArgList(i32 %xor41.i, i32 %xor41.i), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !372)
  %shr42.i = lshr i32 %xor41.i, 6, !dbg !752
    #dbg_value(!DIArgList(i32 %xor41.i, i32 %shr42.i), !369, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !372)
  %add43.i = add i32 %shr42.i, %xor41.i, !dbg !753
    #dbg_value(i32 %add43.i, !369, !DIExpression(), !372)
    #dbg_value(i32 %add43.i, !350, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !353)
    #dbg_value(i32 %add43.i, !350, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !353)
  %tobool80.not.i = icmp eq ptr %call.i105, null, !dbg !754
  br i1 %tobool80.not.i, label %filter_ipv6.exit, label %land.lhs.true.i131, !dbg !756

land.lhs.true.i131:                               ; preds = %if.end55.i130
  %48 = load i32, ptr %call.i105, align 4, !dbg !757, !tbaa !245
  %tobool81.not.i = icmp eq i32 %48, 0, !dbg !758
  br i1 %tobool81.not.i, label %filter_ipv6.exit, label %if.then82.i, !dbg !759

if.then82.i:                                      ; preds = %land.lhs.true.i131
  %rem.i132 = urem i32 %add43.i, %48, !dbg !760
  store i32 %rem.i132, ptr %cpu_dest.i102, align 4, !dbg !762, !tbaa !245, !DIAssignID !763
    #dbg_assign(i32 %rem.i132, !347, !DIExpression(), !763, ptr %cpu_dest.i102, !DIExpression(), !353)
  %call83.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_available, ptr noundef nonnull %cpu_dest.i102) #4, !dbg !764
    #dbg_value(ptr %call83.i, !349, !DIExpression(), !353)
  %tobool84.not.i = icmp eq ptr %call83.i, null, !dbg !765
  br i1 %tobool84.not.i, label %filter_ipv6.exit, label %if.end86.i, !dbg !767

if.end86.i:                                       ; preds = %if.then82.i
  %49 = load i32, ptr %call83.i, align 4, !dbg !768, !tbaa !245
  store i32 %49, ptr %cpu_dest.i102, align 4, !dbg !769, !tbaa !245, !DIAssignID !770
    #dbg_assign(i32 %49, !347, !DIExpression(), !770, ptr %cpu_dest.i102, !DIExpression(), !353)
  %conv87.i = zext i32 %49 to i64, !dbg !771
  %call88.i = call i64 inttoptr (i64 51 to ptr)(ptr noundef nonnull @cpu_map, i64 noundef %conv87.i, i64 noundef 0) #4, !dbg !772
  %conv89.i = trunc i64 %call88.i to i32, !dbg !773
  br label %filter_ipv6.exit, !dbg !774

filter_ipv6.exit:                                 ; preds = %if.end.i108, %sw.bb3.i, %sw.bb.i, %if.then54, %if.then47.i, %if.else51.i, %if.end55.i130, %land.lhs.true.i131, %if.then82.i, %if.end86.i
  %retval.0.i129 = phi i32 [ %conv54.i, %if.else51.i ], [ %conv89.i, %if.end86.i ], [ 0, %if.then54 ], [ 2, %if.end.i108 ], [ 1, %if.then47.i ], [ 0, %if.then82.i ], [ 2, %land.lhs.true.i131 ], [ 2, %if.end55.i130 ], [ 2, %sw.bb.i ], [ 2, %sw.bb3.i ], !dbg !353
  call void @llvm.lifetime.end.p0(ptr nonnull %cpu_dest.i102) #4, !dbg !775
  call void @llvm.lifetime.end.p0(ptr nonnull %key0.i101) #4, !dbg !775
  call void @llvm.lifetime.end.p0(ptr nonnull %tuple.i100) #4, !dbg !775
  br label %cleanup58, !dbg !776

cleanup58:                                        ; preds = %if.then29, %if.then12, %if.end46, %entry, %filter_ipv6.exit, %filter_ipv4.exit
  %retval.3 = phi i32 [ %retval.0.i, %filter_ipv4.exit ], [ %retval.0.i129, %filter_ipv6.exit ], [ 2, %entry ], [ 2, %if.end46 ], [ 2, %if.then12 ], [ 2, %if.then29 ], !dbg !427
  ret i32 %retval.3, !dbg !777
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #2

; Function Attrs: nounwind memory(none)
declare i1 @llvm.bpf.passthrough.i1.i1(i32, i1) #3

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nounwind memory(none) }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!239, !240, !241, !242, !243}
!llvm.ident = !{!244}
!llvm.errno.tbaa = !{!245}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "__license", scope: !2, file: !3, line: 554, type: !238, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 22.0.0git (https://github.com/zachary-kent/llvm-project/ 17a443e799e99026e9430fea2d6fc19b39cb5b8b)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !48, globals: !94, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_filter.c", directory: "/home/otso/suricata/ebpf", checksumkind: CSK_MD5, checksum: "8d18ca92540ac07caad1b6d9e561acc2")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2609, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "include/linux/bpf.h", directory: "/home/otso/suricata/ebpf", checksumkind: CSK_MD5, checksum: "783c30496bbc98655006468758d90a0e")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 29, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "", checksumkind: CSK_MD5, checksum: "fcde28429fcbe66e109e5fe5b99ccd45")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45, !46, !47}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!38 = !DIEnumerator(name: "IPPROTO_L2TP", value: 115)
!39 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!40 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!41 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!42 = !DIEnumerator(name: "IPPROTO_ETHERNET", value: 143)
!43 = !DIEnumerator(name: "IPPROTO_AGGFRAG", value: 144)
!44 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!45 = !DIEnumerator(name: "IPPROTO_SMC", value: 256)
!46 = !DIEnumerator(name: "IPPROTO_MPTCP", value: 262)
!47 = !DIEnumerator(name: "IPPROTO_MAX", value: 263)
!48 = !{!49, !50, !51, !53, !56, !58, !83, !91, !93}
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!50 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !52, line: 32, baseType: !53)
!52 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "c0ade1a1a309d6896ce6080a51a2d105")
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !54, line: 24, baseType: !55)
!54 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!55 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !60, line: 25, size: 160, elements: !61)
!60 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "", checksumkind: CSK_MD5, checksum: "5c5770dfb56897d023c19c1713f34224")
!61 = !{!62, !63, !64, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !82}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !59, file: !60, line: 26, baseType: !51, size: 16)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !59, file: !60, line: 27, baseType: !51, size: 16, offset: 16)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !59, file: !60, line: 28, baseType: !65, size: 32, offset: 32)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !52, line: 34, baseType: !66)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !54, line: 27, baseType: !7)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !59, file: !60, line: 29, baseType: !65, size: 32, offset: 64)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "ae", scope: !59, file: !60, line: 31, baseType: !53, size: 1, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !59, file: !60, line: 32, baseType: !53, size: 3, offset: 97, flags: DIFlagBitField, extraData: i64 96)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !59, file: !60, line: 33, baseType: !53, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !59, file: !60, line: 34, baseType: !53, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !59, file: !60, line: 35, baseType: !53, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !59, file: !60, line: 36, baseType: !53, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !59, file: !60, line: 37, baseType: !53, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !59, file: !60, line: 38, baseType: !53, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !59, file: !60, line: 39, baseType: !53, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !59, file: !60, line: 40, baseType: !53, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !59, file: !60, line: 41, baseType: !53, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !59, file: !60, line: 57, baseType: !51, size: 16, offset: 112)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !59, file: !60, line: 58, baseType: !81, size: 16, offset: 128)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !52, line: 38, baseType: !53)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !59, file: !60, line: 59, baseType: !51, size: 16, offset: 144)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !85, line: 23, size: 64, elements: !86)
!85 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "45bc38cb16dbbc7584265afc2989c9cc")
!86 = !{!87, !88, !89, !90}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !84, file: !85, line: 24, baseType: !51, size: 16)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !84, file: !85, line: 25, baseType: !51, size: 16, offset: 16)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !84, file: !85, line: 26, baseType: !51, size: 16, offset: 32)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !84, file: !85, line: 27, baseType: !81, size: 16, offset: 48)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !53)
!93 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!94 = !{!0, !95, !97, !139, !163, !180, !190, !202, !215, !223, !232}
!95 = !DIGlobalVariableExpression(var: !96, expr: !DIExpression())
!96 = distinct !DIGlobalVariable(name: "__version", scope: !2, file: !3, line: 556, type: !66, isLocal: false, isDefinition: true)
!97 = !DIGlobalVariableExpression(var: !98, expr: !DIExpression())
!98 = distinct !DIGlobalVariable(name: "flow_table_v4", scope: !2, file: !3, line: 107, type: !99, isLocal: false, isDefinition: true)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 98, size: 256, elements: !100)
!100 = !{!101, !107, !126, !134}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !99, file: !3, line: 100, baseType: !102, size: 64)
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !104, size: 160, elements: !105)
!104 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!105 = !{!106}
!106 = !DISubrange(count: 5)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !99, file: !3, line: 104, baseType: !108, size: 64, offset: 64)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "flowv4_keys", file: !3, line: 69, size: 128, elements: !110)
!110 = !{!111, !112, !113, !121, !124, !125}
!111 = !DIDerivedType(tag: DW_TAG_member, name: "src", scope: !109, file: !3, line: 70, baseType: !66, size: 32)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "dst", scope: !109, file: !3, line: 71, baseType: !66, size: 32, offset: 32)
!113 = !DIDerivedType(tag: DW_TAG_member, scope: !109, file: !3, line: 72, baseType: !114, size: 32, offset: 64)
!114 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !109, file: !3, line: 72, size: 32, elements: !115)
!115 = !{!116, !117}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "ports", scope: !114, file: !3, line: 73, baseType: !66, size: 32)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "port16", scope: !114, file: !3, line: 74, baseType: !118, size: 32)
!118 = !DICompositeType(tag: DW_TAG_array_type, baseType: !53, size: 32, elements: !119)
!119 = !{!120}
!120 = !DISubrange(count: 2)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !109, file: !3, line: 76, baseType: !122, size: 1, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!122 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !54, line: 21, baseType: !123)
!123 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "vlan0", scope: !109, file: !3, line: 77, baseType: !53, size: 15, offset: 97, flags: DIFlagBitField, extraData: i64 96)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "vlan1", scope: !109, file: !3, line: 78, baseType: !53, size: 16, offset: 112)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !99, file: !3, line: 105, baseType: !127, size: 64, offset: 128)
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "pair", file: !3, line: 93, size: 128, elements: !129)
!129 = !{!130, !133}
!130 = !DIDerivedType(tag: DW_TAG_member, name: "packets", scope: !128, file: !3, line: 94, baseType: !131, size: 64)
!131 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !54, line: 31, baseType: !132)
!132 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "bytes", scope: !128, file: !3, line: 95, baseType: !131, size: 64, offset: 64)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !99, file: !3, line: 106, baseType: !135, size: 64, offset: 192)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = !DICompositeType(tag: DW_TAG_array_type, baseType: !104, size: 1048576, elements: !137)
!137 = !{!138}
!138 = !DISubrange(count: 32768)
!139 = !DIGlobalVariableExpression(var: !140, expr: !DIExpression())
!140 = distinct !DIGlobalVariable(name: "flow_table_v6", scope: !2, file: !3, line: 118, type: !141, isLocal: false, isDefinition: true)
!141 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 109, size: 256, elements: !142)
!142 = !{!143, !144, !161, !162}
!143 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !141, file: !3, line: 111, baseType: !102, size: 64)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !141, file: !3, line: 115, baseType: !145, size: 64, offset: 64)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "flowv6_keys", file: !3, line: 81, size: 320, elements: !147)
!147 = !{!148, !152, !153, !158, !159, !160}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "src", scope: !146, file: !3, line: 82, baseType: !149, size: 128)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 128, elements: !150)
!150 = !{!151}
!151 = !DISubrange(count: 4)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "dst", scope: !146, file: !3, line: 83, baseType: !149, size: 128, offset: 128)
!153 = !DIDerivedType(tag: DW_TAG_member, scope: !146, file: !3, line: 84, baseType: !154, size: 32, offset: 256)
!154 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !146, file: !3, line: 84, size: 32, elements: !155)
!155 = !{!156, !157}
!156 = !DIDerivedType(tag: DW_TAG_member, name: "ports", scope: !154, file: !3, line: 85, baseType: !66, size: 32)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "port16", scope: !154, file: !3, line: 86, baseType: !118, size: 32)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !146, file: !3, line: 88, baseType: !122, size: 1, offset: 288, flags: DIFlagBitField, extraData: i64 288)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "vlan0", scope: !146, file: !3, line: 89, baseType: !53, size: 15, offset: 289, flags: DIFlagBitField, extraData: i64 288)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "vlan1", scope: !146, file: !3, line: 90, baseType: !53, size: 16, offset: 304)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !141, file: !3, line: 116, baseType: !127, size: 64, offset: 128)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !141, file: !3, line: 117, baseType: !135, size: 64, offset: 192)
!163 = !DIGlobalVariableExpression(var: !164, expr: !DIExpression())
!164 = distinct !DIGlobalVariable(name: "cpu_map", scope: !2, file: !3, line: 140, type: !165, isLocal: false, isDefinition: true)
!165 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 135, size: 256, elements: !166)
!166 = !{!167, !172, !174, !175}
!167 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !165, file: !3, line: 136, baseType: !168, size: 64)
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !169, size: 64)
!169 = !DICompositeType(tag: DW_TAG_array_type, baseType: !104, size: 512, elements: !170)
!170 = !{!171}
!171 = !DISubrange(count: 16)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !165, file: !3, line: 137, baseType: !173, size: 64, offset: 64)
!173 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !165, file: !3, line: 138, baseType: !173, size: 64, offset: 128)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !165, file: !3, line: 139, baseType: !176, size: 64, offset: 192)
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !177, size: 64)
!177 = !DICompositeType(tag: DW_TAG_array_type, baseType: !104, size: 2048, elements: !178)
!178 = !{!179}
!179 = !DISubrange(count: 64)
!180 = !DIGlobalVariableExpression(var: !181, expr: !DIExpression())
!181 = distinct !DIGlobalVariable(name: "cpus_available", scope: !2, file: !3, line: 147, type: !182, isLocal: false, isDefinition: true)
!182 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 142, size: 256, elements: !183)
!183 = !{!184, !187, !188, !189}
!184 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !182, file: !3, line: 143, baseType: !185, size: 64)
!185 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !186, size: 64)
!186 = !DICompositeType(tag: DW_TAG_array_type, baseType: !104, size: 64, elements: !119)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !182, file: !3, line: 144, baseType: !173, size: 64, offset: 64)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !182, file: !3, line: 145, baseType: !173, size: 64, offset: 128)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !182, file: !3, line: 146, baseType: !176, size: 64, offset: 192)
!190 = !DIGlobalVariableExpression(var: !191, expr: !DIExpression())
!191 = distinct !DIGlobalVariable(name: "cpus_count", scope: !2, file: !3, line: 154, type: !192, isLocal: false, isDefinition: true)
!192 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 149, size: 256, elements: !193)
!193 = !{!194, !195, !196, !197}
!194 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !192, file: !3, line: 150, baseType: !185, size: 64)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !192, file: !3, line: 151, baseType: !173, size: 64, offset: 64)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !192, file: !3, line: 152, baseType: !173, size: 64, offset: 128)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !192, file: !3, line: 153, baseType: !198, size: 64, offset: 192)
!198 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !199, size: 64)
!199 = !DICompositeType(tag: DW_TAG_array_type, baseType: !104, size: 32, elements: !200)
!200 = !{!201}
!201 = !DISubrange(count: 1)
!202 = !DIGlobalVariableExpression(var: !203, expr: !DIExpression())
!203 = distinct !DIGlobalVariable(name: "tx_peer", scope: !2, file: !3, line: 166, type: !204, isLocal: false, isDefinition: true)
!204 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 161, size: 256, elements: !205)
!205 = !{!206, !211, !213, !214}
!206 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !204, file: !3, line: 162, baseType: !207, size: 64)
!207 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !208, size: 64)
!208 = !DICompositeType(tag: DW_TAG_array_type, baseType: !104, size: 448, elements: !209)
!209 = !{!210}
!210 = !DISubrange(count: 14)
!211 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !204, file: !3, line: 163, baseType: !212, size: 64, offset: 64)
!212 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !204, file: !3, line: 164, baseType: !212, size: 64, offset: 128)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !204, file: !3, line: 165, baseType: !198, size: 64, offset: 192)
!215 = !DIGlobalVariableExpression(var: !216, expr: !DIExpression())
!216 = distinct !DIGlobalVariable(name: "tx_peer_int", scope: !2, file: !3, line: 176, type: !217, isLocal: false, isDefinition: true)
!217 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 171, size: 256, elements: !218)
!218 = !{!219, !220, !221, !222}
!219 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !217, file: !3, line: 172, baseType: !185, size: 64)
!220 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !217, file: !3, line: 173, baseType: !212, size: 64, offset: 64)
!221 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !217, file: !3, line: 174, baseType: !212, size: 64, offset: 128)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !217, file: !3, line: 175, baseType: !198, size: 64, offset: 192)
!223 = !DIGlobalVariableExpression(var: !224, expr: !DIExpression())
!224 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !225, line: 64, type: !226, isLocal: true, isDefinition: true)
!225 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "11f09623d7230081247afacdc7c1a641")
!226 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !227)
!227 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !228, size: 64)
!228 = !DISubroutineType(types: !229)
!229 = !{!49, !49, !230}
!230 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !231, size: 64)
!231 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!232 = !DIGlobalVariableExpression(var: !233, expr: !DIExpression())
!233 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !225, line: 1338, type: !234, isLocal: true, isDefinition: true)
!234 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !235)
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !236, size: 64)
!236 = !DISubroutineType(types: !237)
!237 = !{!50, !49, !131, !131}
!238 = !DICompositeType(tag: DW_TAG_array_type, baseType: !57, size: 32, elements: !150)
!239 = !{i32 7, !"Dwarf Version", i32 5}
!240 = !{i32 2, !"Debug Info Version", i32 3}
!241 = !{i32 1, !"wchar_size", i32 4}
!242 = !{i32 7, !"frame-pointer", i32 2}
!243 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!244 = !{!"clang version 22.0.0git (https://github.com/zachary-kent/llvm-project/ 17a443e799e99026e9430fea2d6fc19b39cb5b8b)"}
!245 = !{!246, !246, i64 0}
!246 = !{!"int", !247, i64 0}
!247 = !{!"omnipotent char", !248, i64 0}
!248 = !{!"Simple C/C++ TBAA"}
!249 = distinct !DISubprogram(name: "xdp_hashfilter", scope: !3, file: !3, line: 485, type: !250, scopeLine: 486, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !260, keyInstructions: true)
!250 = !DISubroutineType(types: !251)
!251 = !{!104, !252}
!252 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !253, size: 64)
!253 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2620, size: 160, elements: !254)
!254 = !{!255, !256, !257, !258, !259}
!255 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !253, file: !6, line: 2621, baseType: !66, size: 32)
!256 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !253, file: !6, line: 2622, baseType: !66, size: 32, offset: 32)
!257 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !253, file: !6, line: 2623, baseType: !66, size: 32, offset: 64)
!258 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !253, file: !6, line: 2625, baseType: !66, size: 32, offset: 96)
!259 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !253, file: !6, line: 2626, baseType: !66, size: 32, offset: 128)
!260 = !{!261, !262, !263, !264, !275, !276, !277, !278, !279, !287}
!261 = !DILocalVariable(name: "ctx", arg: 1, scope: !249, file: !3, line: 485, type: !252)
!262 = !DILocalVariable(name: "data_end", scope: !249, file: !3, line: 487, type: !49)
!263 = !DILocalVariable(name: "data", scope: !249, file: !3, line: 488, type: !49)
!264 = !DILocalVariable(name: "eth", scope: !249, file: !3, line: 489, type: !265)
!265 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !266, size: 64)
!266 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !267, line: 173, size: 112, elements: !268)
!267 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!268 = !{!269, !273, !274}
!269 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !266, file: !267, line: 174, baseType: !270, size: 48)
!270 = !DICompositeType(tag: DW_TAG_array_type, baseType: !123, size: 48, elements: !271)
!271 = !{!272}
!272 = !DISubrange(count: 6)
!273 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !266, file: !267, line: 175, baseType: !270, size: 48, offset: 48)
!274 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !266, file: !267, line: 176, baseType: !51, size: 16, offset: 96)
!275 = !DILocalVariable(name: "h_proto", scope: !249, file: !3, line: 490, type: !53)
!276 = !DILocalVariable(name: "nh_off", scope: !249, file: !3, line: 491, type: !131)
!277 = !DILocalVariable(name: "vlan0", scope: !249, file: !3, line: 492, type: !53)
!278 = !DILocalVariable(name: "vlan1", scope: !249, file: !3, line: 493, type: !53)
!279 = !DILocalVariable(name: "vhdr", scope: !280, file: !3, line: 518, type: !282)
!280 = distinct !DILexicalBlock(scope: !281, file: !3, line: 517, column: 96)
!281 = distinct !DILexicalBlock(scope: !249, file: !3, line: 517, column: 9)
!282 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !283, size: 64)
!283 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !3, line: 64, size: 32, elements: !284)
!284 = !{!285, !286}
!285 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !283, file: !3, line: 65, baseType: !53, size: 16)
!286 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !283, file: !3, line: 66, baseType: !53, size: 16, offset: 16)
!287 = !DILocalVariable(name: "vhdr", scope: !288, file: !3, line: 532, type: !282)
!288 = distinct !DILexicalBlock(scope: !289, file: !3, line: 531, column: 96)
!289 = distinct !DILexicalBlock(scope: !249, file: !3, line: 531, column: 9)
!290 = distinct !DIAssignID()
!291 = !DILocalVariable(name: "tuple", scope: !292, file: !3, line: 384, type: !146)
!292 = distinct !DISubprogram(name: "filter_ipv6", scope: !3, file: !3, line: 379, type: !293, scopeLine: 380, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !295, keyInstructions: true)
!293 = !DISubroutineType(types: !294)
!294 = !{!104, !252, !49, !131, !49, !53, !53}
!295 = !{!296, !297, !298, !299, !300, !301, !302, !343, !344, !291, !345, !346, !347, !348, !349, !350, !351, !352}
!296 = !DILocalVariable(name: "ctx", arg: 1, scope: !292, file: !3, line: 379, type: !252)
!297 = !DILocalVariable(name: "data", arg: 2, scope: !292, file: !3, line: 379, type: !49)
!298 = !DILocalVariable(name: "nh_off", arg: 3, scope: !292, file: !3, line: 379, type: !131)
!299 = !DILocalVariable(name: "data_end", arg: 4, scope: !292, file: !3, line: 379, type: !49)
!300 = !DILocalVariable(name: "vlan0", arg: 5, scope: !292, file: !3, line: 379, type: !53)
!301 = !DILocalVariable(name: "vlan1", arg: 6, scope: !292, file: !3, line: 379, type: !53)
!302 = !DILocalVariable(name: "ip6h", scope: !292, file: !3, line: 381, type: !303)
!303 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !304, size: 64)
!304 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !305, line: 118, size: 320, elements: !306)
!305 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "", checksumkind: CSK_MD5, checksum: "2ee489601bcc9c44d828d039ff7786a6")
!306 = !{!307, !308, !309, !313, !314, !315, !316}
!307 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !304, file: !305, line: 120, baseType: !122, size: 4, flags: DIFlagBitField, extraData: i64 0)
!308 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !304, file: !305, line: 121, baseType: !122, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!309 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !304, file: !305, line: 128, baseType: !310, size: 24, offset: 8)
!310 = !DICompositeType(tag: DW_TAG_array_type, baseType: !122, size: 24, elements: !311)
!311 = !{!312}
!312 = !DISubrange(count: 3)
!313 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !304, file: !305, line: 130, baseType: !51, size: 16, offset: 32)
!314 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !304, file: !305, line: 131, baseType: !122, size: 8, offset: 48)
!315 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !304, file: !305, line: 132, baseType: !122, size: 8, offset: 56)
!316 = !DIDerivedType(tag: DW_TAG_member, scope: !304, file: !305, line: 134, baseType: !317, size: 256, offset: 64)
!317 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !304, file: !305, line: 134, size: 256, elements: !318)
!318 = !{!319, !338}
!319 = !DIDerivedType(tag: DW_TAG_member, scope: !317, file: !305, line: 134, baseType: !320, size: 256)
!320 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !317, file: !305, line: 134, size: 256, elements: !321)
!321 = !{!322, !337}
!322 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !320, file: !305, line: 135, baseType: !323, size: 128)
!323 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !324, line: 33, size: 128, elements: !325)
!324 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "", checksumkind: CSK_MD5, checksum: "6eb9610917d19b67762834b3cd333671")
!325 = !{!326}
!326 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !323, file: !324, line: 40, baseType: !327, size: 128)
!327 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !323, file: !324, line: 34, size: 128, elements: !328)
!328 = !{!329, !331, !335}
!329 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !327, file: !324, line: 35, baseType: !330, size: 128)
!330 = !DICompositeType(tag: DW_TAG_array_type, baseType: !122, size: 128, elements: !170)
!331 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !327, file: !324, line: 37, baseType: !332, size: 128)
!332 = !DICompositeType(tag: DW_TAG_array_type, baseType: !51, size: 128, elements: !333)
!333 = !{!334}
!334 = !DISubrange(count: 8)
!335 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !327, file: !324, line: 38, baseType: !336, size: 128)
!336 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 128, elements: !150)
!337 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !320, file: !305, line: 136, baseType: !323, size: 128, offset: 128)
!338 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !317, file: !305, line: 134, baseType: !339, size: 256)
!339 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !317, file: !305, line: 134, size: 256, elements: !340)
!340 = !{!341, !342}
!341 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !339, file: !305, line: 135, baseType: !323, size: 128)
!342 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !339, file: !305, line: 136, baseType: !323, size: 128, offset: 128)
!343 = !DILocalVariable(name: "dport", scope: !292, file: !3, line: 382, type: !104)
!344 = !DILocalVariable(name: "sport", scope: !292, file: !3, line: 383, type: !104)
!345 = !DILocalVariable(name: "value", scope: !292, file: !3, line: 385, type: !127)
!346 = !DILocalVariable(name: "key0", scope: !292, file: !3, line: 387, type: !66)
!347 = !DILocalVariable(name: "cpu_dest", scope: !292, file: !3, line: 390, type: !66)
!348 = !DILocalVariable(name: "cpu_max", scope: !292, file: !3, line: 391, type: !212)
!349 = !DILocalVariable(name: "cpu_selected", scope: !292, file: !3, line: 392, type: !173)
!350 = !DILocalVariable(name: "cpu_hash", scope: !292, file: !3, line: 393, type: !66)
!351 = !DILocalVariable(name: "tx_port", scope: !292, file: !3, line: 396, type: !104)
!352 = !DILocalVariable(name: "iface_peer", scope: !292, file: !3, line: 397, type: !212)
!353 = !DILocation(line: 0, scope: !292, inlinedAt: !354)
!354 = distinct !DILocation(line: 549, column: 16, scope: !355)
!355 = distinct !DILexicalBlock(scope: !356, file: !3, line: 548, column: 14)
!356 = distinct !DILexicalBlock(scope: !249, file: !3, line: 546, column: 9)
!357 = distinct !DIAssignID()
!358 = distinct !DIAssignID()
!359 = !DILocalVariable(name: "data", arg: 1, scope: !360, file: !361, line: 10, type: !364)
!360 = distinct !DISubprogram(name: "SuperFastHash", scope: !361, file: !361, line: 10, type: !362, scopeLine: 10, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !366, keyInstructions: true)
!361 = !DIFile(filename: "./hash_func01.h", directory: "/home/otso/suricata/ebpf", checksumkind: CSK_MD5, checksum: "ce1b4b031f544a3f2c7bb1ea990aba20")
!362 = !DISubroutineType(types: !363)
!363 = !{!66, !364, !104, !66}
!364 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !365, size: 64)
!365 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !57)
!366 = !{!359, !367, !368, !369, !370, !371}
!367 = !DILocalVariable(name: "len", arg: 2, scope: !360, file: !361, line: 10, type: !104)
!368 = !DILocalVariable(name: "initval", arg: 3, scope: !360, file: !361, line: 10, type: !66)
!369 = !DILocalVariable(name: "hash", scope: !360, file: !361, line: 11, type: !66)
!370 = !DILocalVariable(name: "tmp", scope: !360, file: !361, line: 12, type: !66)
!371 = !DILocalVariable(name: "rem", scope: !360, file: !361, line: 13, type: !104)
!372 = !DILocation(line: 0, scope: !360, inlinedAt: !373)
!373 = distinct !DILocation(line: 458, column: 16, scope: !292, inlinedAt: !354)
!374 = distinct !DIAssignID()
!375 = !DILocalVariable(name: "tuple", scope: !376, file: !3, line: 240, type: !109)
!376 = distinct !DISubprogram(name: "filter_ipv4", scope: !3, file: !3, line: 235, type: !293, scopeLine: 236, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !377, keyInstructions: true)
!377 = !{!378, !379, !380, !381, !382, !383, !384, !411, !412, !375, !413, !414, !415, !416, !417, !418, !419, !420}
!378 = !DILocalVariable(name: "ctx", arg: 1, scope: !376, file: !3, line: 235, type: !252)
!379 = !DILocalVariable(name: "data", arg: 2, scope: !376, file: !3, line: 235, type: !49)
!380 = !DILocalVariable(name: "nh_off", arg: 3, scope: !376, file: !3, line: 235, type: !131)
!381 = !DILocalVariable(name: "data_end", arg: 4, scope: !376, file: !3, line: 235, type: !49)
!382 = !DILocalVariable(name: "vlan0", arg: 5, scope: !376, file: !3, line: 235, type: !53)
!383 = !DILocalVariable(name: "vlan1", arg: 6, scope: !376, file: !3, line: 235, type: !53)
!384 = !DILocalVariable(name: "iph", scope: !376, file: !3, line: 237, type: !385)
!385 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !386, size: 64)
!386 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !387, line: 87, size: 160, elements: !388)
!387 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "5c58d077e910b6c258855dca54d0ec22")
!388 = !{!389, !390, !391, !392, !393, !394, !395, !396, !397, !398}
!389 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !386, file: !387, line: 89, baseType: !122, size: 4, flags: DIFlagBitField, extraData: i64 0)
!390 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !386, file: !387, line: 90, baseType: !122, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!391 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !386, file: !387, line: 97, baseType: !122, size: 8, offset: 8)
!392 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !386, file: !387, line: 98, baseType: !51, size: 16, offset: 16)
!393 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !386, file: !387, line: 99, baseType: !51, size: 16, offset: 32)
!394 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !386, file: !387, line: 100, baseType: !51, size: 16, offset: 48)
!395 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !386, file: !387, line: 101, baseType: !122, size: 8, offset: 64)
!396 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !386, file: !387, line: 102, baseType: !122, size: 8, offset: 72)
!397 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !386, file: !387, line: 103, baseType: !81, size: 16, offset: 80)
!398 = !DIDerivedType(tag: DW_TAG_member, scope: !386, file: !387, line: 104, baseType: !399, size: 64, offset: 96)
!399 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !386, file: !387, line: 104, size: 64, elements: !400)
!400 = !{!401, !406}
!401 = !DIDerivedType(tag: DW_TAG_member, scope: !399, file: !387, line: 104, baseType: !402, size: 64)
!402 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !399, file: !387, line: 104, size: 64, elements: !403)
!403 = !{!404, !405}
!404 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !402, file: !387, line: 105, baseType: !65, size: 32)
!405 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !402, file: !387, line: 106, baseType: !65, size: 32, offset: 32)
!406 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !399, file: !387, line: 104, baseType: !407, size: 64)
!407 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !399, file: !387, line: 104, size: 64, elements: !408)
!408 = !{!409, !410}
!409 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !407, file: !387, line: 105, baseType: !65, size: 32)
!410 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !407, file: !387, line: 106, baseType: !65, size: 32, offset: 32)
!411 = !DILocalVariable(name: "dport", scope: !376, file: !3, line: 238, type: !104)
!412 = !DILocalVariable(name: "sport", scope: !376, file: !3, line: 239, type: !104)
!413 = !DILocalVariable(name: "value", scope: !376, file: !3, line: 241, type: !127)
!414 = !DILocalVariable(name: "key0", scope: !376, file: !3, line: 243, type: !66)
!415 = !DILocalVariable(name: "cpu_dest", scope: !376, file: !3, line: 250, type: !66)
!416 = !DILocalVariable(name: "cpu_max", scope: !376, file: !3, line: 251, type: !173)
!417 = !DILocalVariable(name: "cpu_selected", scope: !376, file: !3, line: 252, type: !173)
!418 = !DILocalVariable(name: "cpu_hash", scope: !376, file: !3, line: 253, type: !66)
!419 = !DILocalVariable(name: "iface_peer", scope: !376, file: !3, line: 256, type: !212)
!420 = !DILocalVariable(name: "tx_port", scope: !376, file: !3, line: 257, type: !104)
!421 = !DILocation(line: 0, scope: !376, inlinedAt: !422)
!422 = distinct !DILocation(line: 547, column: 16, scope: !356)
!423 = distinct !DIAssignID()
!424 = distinct !DIAssignID()
!425 = !DILocation(line: 0, scope: !360, inlinedAt: !426)
!426 = distinct !DILocation(line: 356, column: 16, scope: !376, inlinedAt: !422)
!427 = !DILocation(line: 0, scope: !249)
!428 = !DILocation(line: 487, column: 41, scope: !249)
!429 = !DILocation(line: 487, column: 41, scope: !249, atomGroup: 1, atomRank: 4)
!430 = !{!431, !246, i64 4}
!431 = !{!"xdp_md", !246, i64 0, !246, i64 4, !246, i64 8, !246, i64 12, !246, i64 16}
!432 = !DILocation(line: 487, column: 30, scope: !249, atomGroup: 1, atomRank: 3)
!433 = !DILocation(line: 487, column: 22, scope: !249, atomGroup: 1, atomRank: 2)
!434 = !DILocation(line: 488, column: 37, scope: !249, atomGroup: 2, atomRank: 4)
!435 = !{!431, !246, i64 0}
!436 = !DILocation(line: 488, column: 26, scope: !249, atomGroup: 2, atomRank: 3)
!437 = !DILocation(line: 488, column: 18, scope: !249, atomGroup: 2, atomRank: 2)
!438 = !DILocation(line: 512, column: 14, scope: !439)
!439 = distinct !DILexicalBlock(scope: !249, file: !3, line: 512, column: 9)
!440 = !DILocation(line: 512, column: 23, scope: !439, atomGroup: 7, atomRank: 2)
!441 = !DILocation(line: 512, column: 23, scope: !439, atomGroup: 7, atomRank: 1)
!442 = !DILocation(line: 515, column: 20, scope: !249)
!443 = !DILocation(line: 515, column: 20, scope: !249, atomGroup: 9, atomRank: 2)
!444 = !{!445, !446, i64 12}
!445 = !{!"ethhdr", !247, i64 0, !247, i64 6, !446, i64 12}
!446 = !{!"short", !247, i64 0}
!447 = !DILocation(line: 517, column: 17, scope: !281, atomGroup: 10, atomRank: 2)
!448 = !DILocation(line: 517, column: 50, scope: !281, atomGroup: 10, atomRank: 1)
!449 = !DILocation(line: 0, scope: !280)
!450 = !DILocation(line: 522, column: 18, scope: !451)
!451 = distinct !DILexicalBlock(scope: !280, file: !3, line: 522, column: 13)
!452 = !DILocation(line: 522, column: 27, scope: !451, atomGroup: 14, atomRank: 2)
!453 = !DILocation(line: 522, column: 27, scope: !451, atomGroup: 14, atomRank: 1)
!454 = !DILocation(line: 524, column: 25, scope: !280)
!455 = !DILocation(line: 524, column: 25, scope: !280, atomGroup: 16, atomRank: 2)
!456 = !{!457, !446, i64 2}
!457 = !{!"vlan_hdr", !446, i64 0, !446, i64 2}
!458 = !DILocation(line: 526, column: 23, scope: !280)
!459 = !{!457, !446, i64 0}
!460 = !DILocation(line: 423, column: 17, scope: !292, inlinedAt: !354)
!461 = !DILocation(line: 492, column: 11, scope: !249, atomGroup: 4, atomRank: 1)
!462 = !DILocation(line: 515, column: 13, scope: !249, atomGroup: 9, atomRank: 1)
!463 = !DILocation(line: 531, column: 17, scope: !289, atomGroup: 18, atomRank: 2)
!464 = !DILocation(line: 531, column: 50, scope: !289, atomGroup: 18, atomRank: 1)
!465 = !DILocation(line: 0, scope: !288)
!466 = !DILocation(line: 535, column: 16, scope: !288, atomGroup: 21, atomRank: 2)
!467 = !DILocation(line: 536, column: 18, scope: !468)
!468 = distinct !DILexicalBlock(scope: !288, file: !3, line: 536, column: 13)
!469 = !DILocation(line: 536, column: 27, scope: !468, atomGroup: 22, atomRank: 2)
!470 = !DILocation(line: 536, column: 27, scope: !468, atomGroup: 22, atomRank: 1)
!471 = !DILocation(line: 534, column: 21, scope: !288, atomGroup: 20, atomRank: 2)
!472 = !DILocation(line: 538, column: 25, scope: !288)
!473 = !DILocation(line: 538, column: 25, scope: !288, atomGroup: 24, atomRank: 2)
!474 = !DILocation(line: 540, column: 23, scope: !288)
!475 = !DILocation(line: 540, column: 34, scope: !288, atomGroup: 25, atomRank: 3)
!476 = !DILocation(line: 493, column: 11, scope: !249, atomGroup: 5, atomRank: 1)
!477 = !DILocation(line: 546, column: 17, scope: !356, atomGroup: 26, atomRank: 1)
!478 = !DILocation(line: 237, column: 30, scope: !376, inlinedAt: !422, atomGroup: 1, atomRank: 2)
!479 = !DILocation(line: 240, column: 5, scope: !376, inlinedAt: !422)
!480 = !DILocation(line: 243, column: 5, scope: !376, inlinedAt: !422)
!481 = !DILocation(line: 243, column: 11, scope: !376, inlinedAt: !422, atomGroup: 2, atomRank: 1)
!482 = distinct !DIAssignID()
!483 = !DILocation(line: 250, column: 5, scope: !376, inlinedAt: !422)
!484 = !DILocation(line: 251, column: 22, scope: !376, inlinedAt: !422, atomGroup: 3, atomRank: 2)
!485 = !DILocation(line: 260, column: 22, scope: !486, inlinedAt: !422)
!486 = distinct !DILexicalBlock(scope: !376, file: !3, line: 260, column: 9)
!487 = !DILocation(line: 260, column: 27, scope: !486, inlinedAt: !422, atomGroup: 5, atomRank: 2)
!488 = !DILocation(line: 260, column: 27, scope: !486, inlinedAt: !422, atomGroup: 5, atomRank: 1)
!489 = !DILocation(line: 263, column: 14, scope: !490, inlinedAt: !422)
!490 = distinct !DILexicalBlock(scope: !376, file: !3, line: 263, column: 9)
!491 = !{!492, !247, i64 9}
!492 = !{!"iphdr", !247, i64 0, !247, i64 0, !247, i64 1, !446, i64 2, !446, i64 4, !446, i64 6, !247, i64 8, !247, i64 9, !446, i64 10, !247, i64 12}
!493 = !DILocation(line: 263, column: 23, scope: !490, inlinedAt: !422, atomGroup: 7, atomRank: 2)
!494 = !DILocation(line: 0, scope: !490, inlinedAt: !422)
!495 = !DILocation(line: 263, column: 23, scope: !490, inlinedAt: !422, atomGroup: 7, atomRank: 1)
!496 = !DILocation(line: 268, column: 22, scope: !376, inlinedAt: !422)
!497 = !DILocation(line: 268, column: 22, scope: !376, inlinedAt: !422, atomGroup: 10, atomRank: 2)
!498 = !{!247, !247, i64 0}
!499 = !DILocation(line: 268, column: 15, scope: !376, inlinedAt: !422, atomGroup: 10, atomRank: 1)
!500 = !{!501, !246, i64 0}
!501 = !{!"flowv4_keys", !246, i64 0, !246, i64 4, !247, i64 8, !247, i64 12, !446, i64 12, !446, i64 14}
!502 = distinct !DIAssignID()
!503 = !DILocation(line: 269, column: 22, scope: !376, inlinedAt: !422)
!504 = !DILocation(line: 269, column: 22, scope: !376, inlinedAt: !422, atomGroup: 11, atomRank: 2)
!505 = !DILocation(line: 269, column: 11, scope: !376, inlinedAt: !422)
!506 = !DILocation(line: 269, column: 15, scope: !376, inlinedAt: !422, atomGroup: 11, atomRank: 1)
!507 = !{!501, !246, i64 4}
!508 = distinct !DIAssignID()
!509 = !DILocalVariable(name: "trans_data", arg: 1, scope: !510, file: !3, line: 213, type: !49)
!510 = distinct !DISubprogram(name: "get_dport", scope: !3, file: !3, line: 213, type: !511, scopeLine: 215, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !513, keyInstructions: true)
!511 = !DISubroutineType(types: !512)
!512 = !{!104, !49, !49, !122}
!513 = !{!509, !514, !515, !516, !517}
!514 = !DILocalVariable(name: "data_end", arg: 2, scope: !510, file: !3, line: 213, type: !49)
!515 = !DILocalVariable(name: "protocol", arg: 3, scope: !510, file: !3, line: 214, type: !122)
!516 = !DILocalVariable(name: "th", scope: !510, file: !3, line: 216, type: !58)
!517 = !DILocalVariable(name: "uh", scope: !510, file: !3, line: 217, type: !83)
!518 = !DILocation(line: 0, scope: !510, inlinedAt: !519)
!519 = distinct !DILocation(line: 271, column: 13, scope: !376, inlinedAt: !422)
!520 = !DILocation(line: 219, column: 5, scope: !510, inlinedAt: !519, atomGroup: 1, atomRank: 1)
!521 = !DILocation(line: 222, column: 29, scope: !522, inlinedAt: !519)
!522 = distinct !DILexicalBlock(scope: !523, file: !3, line: 222, column: 17)
!523 = distinct !DILexicalBlock(scope: !510, file: !3, line: 219, column: 23)
!524 = !DILocation(line: 222, column: 34, scope: !522, inlinedAt: !519, atomGroup: 3, atomRank: 2)
!525 = !DILocalVariable(name: "trans_data", arg: 1, scope: !526, file: !3, line: 191, type: !49)
!526 = distinct !DISubprogram(name: "get_sport", scope: !3, file: !3, line: 191, type: !511, scopeLine: 193, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !527, keyInstructions: true)
!527 = !{!525, !528, !529, !530, !531}
!528 = !DILocalVariable(name: "data_end", arg: 2, scope: !526, file: !3, line: 191, type: !49)
!529 = !DILocalVariable(name: "protocol", arg: 3, scope: !526, file: !3, line: 192, type: !122)
!530 = !DILocalVariable(name: "th", scope: !526, file: !3, line: 194, type: !58)
!531 = !DILocalVariable(name: "uh", scope: !526, file: !3, line: 195, type: !83)
!532 = !DILocation(line: 0, scope: !526, inlinedAt: !533)
!533 = distinct !DILocation(line: 275, column: 13, scope: !376, inlinedAt: !422)
!534 = !DILocation(line: 222, column: 34, scope: !522, inlinedAt: !519, atomGroup: 3, atomRank: 1)
!535 = !DILocation(line: 227, column: 29, scope: !536, inlinedAt: !519)
!536 = distinct !DILexicalBlock(scope: !523, file: !3, line: 227, column: 17)
!537 = !DILocation(line: 227, column: 34, scope: !536, inlinedAt: !519, atomGroup: 7, atomRank: 2)
!538 = !DILocation(line: 227, column: 34, scope: !536, inlinedAt: !519, atomGroup: 7, atomRank: 1)
!539 = !DILocation(line: 224, column: 24, scope: !523, inlinedAt: !519)
!540 = !DILocation(line: 224, column: 24, scope: !523, inlinedAt: !519, atomGroup: 5, atomRank: 3)
!541 = !{!542, !446, i64 2}
!542 = !{!"tcphdr", !446, i64 0, !446, i64 2, !246, i64 4, !246, i64 8, !446, i64 12, !446, i64 12, !446, i64 12, !446, i64 13, !446, i64 13, !446, i64 13, !446, i64 13, !446, i64 13, !446, i64 13, !446, i64 13, !446, i64 13, !446, i64 14, !446, i64 16, !446, i64 18}
!543 = !DILocation(line: 202, column: 24, scope: !544, inlinedAt: !533, atomGroup: 5, atomRank: 3)
!544 = distinct !DILexicalBlock(scope: !526, file: !3, line: 197, column: 23)
!545 = !{!542, !446, i64 0}
!546 = !DILocation(line: 202, column: 13, scope: !544, inlinedAt: !533, atomGroup: 5, atomRank: 1)
!547 = !DILocation(line: 229, column: 24, scope: !523, inlinedAt: !519)
!548 = !DILocation(line: 229, column: 24, scope: !523, inlinedAt: !519, atomGroup: 9, atomRank: 3)
!549 = !{!550, !446, i64 2}
!550 = !{!"udphdr", !446, i64 0, !446, i64 2, !446, i64 4, !446, i64 6}
!551 = !DILocation(line: 207, column: 24, scope: !544, inlinedAt: !533, atomGroup: 9, atomRank: 3)
!552 = !{!550, !446, i64 0}
!553 = !DILocation(line: 207, column: 13, scope: !544, inlinedAt: !533, atomGroup: 9, atomRank: 1)
!554 = !DILocation(line: 279, column: 11, scope: !376, inlinedAt: !422)
!555 = !DILocation(line: 279, column: 21, scope: !376, inlinedAt: !422, atomGroup: 18, atomRank: 1)
!556 = distinct !DIAssignID()
!557 = !DILocation(line: 280, column: 5, scope: !376, inlinedAt: !422)
!558 = !DILocation(line: 280, column: 21, scope: !376, inlinedAt: !422, atomGroup: 19, atomRank: 1)
!559 = distinct !DIAssignID()
!560 = !DILocation(line: 282, column: 17, scope: !376, inlinedAt: !422, atomGroup: 20, atomRank: 2)
!561 = !DILocation(line: 282, column: 17, scope: !376, inlinedAt: !422, atomGroup: 20, atomRank: 1)
!562 = distinct !DIAssignID()
!563 = !DILocation(line: 283, column: 11, scope: !376, inlinedAt: !422)
!564 = !DILocation(line: 283, column: 17, scope: !376, inlinedAt: !422, atomGroup: 21, atomRank: 1)
!565 = !{!501, !446, i64 14}
!566 = distinct !DIAssignID()
!567 = !DILocation(line: 285, column: 13, scope: !376, inlinedAt: !422, atomGroup: 22, atomRank: 2)
!568 = !DILocation(line: 294, column: 9, scope: !569, inlinedAt: !422, atomGroup: 23, atomRank: 2)
!569 = distinct !DILexicalBlock(scope: !376, file: !3, line: 294, column: 9)
!570 = !DILocation(line: 294, column: 9, scope: !569, inlinedAt: !422, atomGroup: 23, atomRank: 1)
!571 = !DILocation(line: 302, column: 23, scope: !572, inlinedAt: !422)
!572 = distinct !DILexicalBlock(scope: !569, file: !3, line: 294, column: 16)
!573 = !{!574, !575, i64 0}
!574 = !{!"pair", !575, i64 0, !575, i64 8}
!575 = !{!"long long", !247, i64 0}
!576 = !DILocation(line: 302, column: 23, scope: !572, inlinedAt: !422, atomGroup: 24, atomRank: 2)
!577 = !DILocation(line: 302, column: 23, scope: !572, inlinedAt: !422, atomGroup: 24, atomRank: 1)
!578 = !DILocation(line: 303, column: 34, scope: !572, inlinedAt: !422)
!579 = !DILocation(line: 303, column: 16, scope: !572, inlinedAt: !422)
!580 = !DILocation(line: 303, column: 22, scope: !572, inlinedAt: !422)
!581 = !{!574, !575, i64 8}
!582 = !DILocation(line: 303, column: 22, scope: !572, inlinedAt: !422, atomGroup: 25, atomRank: 2)
!583 = !DILocation(line: 303, column: 22, scope: !572, inlinedAt: !422, atomGroup: 25, atomRank: 1)
!584 = !DILocation(line: 310, column: 22, scope: !572, inlinedAt: !422, atomGroup: 26, atomRank: 2)
!585 = !DILocation(line: 311, column: 14, scope: !586, inlinedAt: !422, atomGroup: 27, atomRank: 2)
!586 = distinct !DILexicalBlock(scope: !572, file: !3, line: 311, column: 13)
!587 = !DILocation(line: 311, column: 13, scope: !586, inlinedAt: !422, atomGroup: 27, atomRank: 1)
!588 = !DILocation(line: 314, column: 20, scope: !589, inlinedAt: !422, atomGroup: 29, atomRank: 3)
!589 = distinct !DILexicalBlock(scope: !586, file: !3, line: 313, column: 16)
!590 = !DILocation(line: 314, column: 20, scope: !589, inlinedAt: !422, atomGroup: 29, atomRank: 2)
!591 = !DILocation(line: 314, column: 13, scope: !589, inlinedAt: !422, atomGroup: 29, atomRank: 1)
!592 = !DILocation(line: 355, column: 22, scope: !376, inlinedAt: !422)
!593 = !DILocation(line: 355, column: 34, scope: !376, inlinedAt: !422)
!594 = !DILocation(line: 355, column: 26, scope: !376, inlinedAt: !422, atomGroup: 30, atomRank: 2)
!595 = !DILocation(line: 356, column: 67, scope: !376, inlinedAt: !422)
!596 = !DILocation(line: 356, column: 62, scope: !376, inlinedAt: !422)
!597 = !DILocation(line: 356, column: 60, scope: !376, inlinedAt: !422)
!598 = !DILocation(line: 23, column: 12, scope: !599, inlinedAt: !426)
!599 = distinct !DILexicalBlock(scope: !600, file: !361, line: 22, column: 24)
!600 = distinct !DILexicalBlock(scope: !601, file: !361, line: 22, column: 2)
!601 = distinct !DILexicalBlock(scope: !360, file: !361, line: 22, column: 2)
!602 = !DILocation(line: 23, column: 9, scope: !599, inlinedAt: !426, atomGroup: 9, atomRank: 2)
!603 = !DILocation(line: 24, column: 32, scope: !599, inlinedAt: !426)
!604 = !DILocation(line: 25, column: 18, scope: !599, inlinedAt: !426)
!605 = !DILocation(line: 25, column: 25, scope: !599, inlinedAt: !426, atomGroup: 11, atomRank: 2)
!606 = !DILocation(line: 27, column: 17, scope: !599, inlinedAt: !426)
!607 = !DILocation(line: 27, column: 9, scope: !599, inlinedAt: !426, atomGroup: 13, atomRank: 2)
!608 = !DILocation(line: 47, column: 15, scope: !360, inlinedAt: !426)
!609 = !DILocation(line: 47, column: 7, scope: !360, inlinedAt: !426, atomGroup: 29, atomRank: 2)
!610 = !DILocation(line: 48, column: 15, scope: !360, inlinedAt: !426)
!611 = !DILocation(line: 48, column: 7, scope: !360, inlinedAt: !426, atomGroup: 30, atomRank: 2)
!612 = !DILocation(line: 49, column: 15, scope: !360, inlinedAt: !426)
!613 = !DILocation(line: 49, column: 7, scope: !360, inlinedAt: !426, atomGroup: 31, atomRank: 2)
!614 = !DILocation(line: 50, column: 15, scope: !360, inlinedAt: !426)
!615 = !DILocation(line: 50, column: 7, scope: !360, inlinedAt: !426, atomGroup: 32, atomRank: 2)
!616 = !DILocation(line: 51, column: 15, scope: !360, inlinedAt: !426)
!617 = !DILocation(line: 51, column: 7, scope: !360, inlinedAt: !426, atomGroup: 33, atomRank: 2)
!618 = !DILocation(line: 52, column: 15, scope: !360, inlinedAt: !426)
!619 = !DILocation(line: 52, column: 7, scope: !360, inlinedAt: !426, atomGroup: 34, atomRank: 2)
!620 = !DILocation(line: 358, column: 9, scope: !621, inlinedAt: !422, atomGroup: 32, atomRank: 2)
!621 = distinct !DILexicalBlock(scope: !376, file: !3, line: 358, column: 9)
!622 = !DILocation(line: 358, column: 17, scope: !621, inlinedAt: !422, atomGroup: 32, atomRank: 1)
!623 = !DILocation(line: 358, column: 20, scope: !621, inlinedAt: !422)
!624 = !DILocation(line: 358, column: 20, scope: !621, inlinedAt: !422, atomGroup: 33, atomRank: 2)
!625 = !DILocation(line: 358, column: 17, scope: !621, inlinedAt: !422, atomGroup: 33, atomRank: 1)
!626 = !DILocation(line: 359, column: 29, scope: !627, inlinedAt: !422, atomGroup: 34, atomRank: 2)
!627 = distinct !DILexicalBlock(scope: !621, file: !3, line: 358, column: 30)
!628 = !DILocation(line: 359, column: 18, scope: !627, inlinedAt: !422, atomGroup: 34, atomRank: 1)
!629 = distinct !DIAssignID()
!630 = !DILocation(line: 360, column: 24, scope: !627, inlinedAt: !422, atomGroup: 35, atomRank: 2)
!631 = !DILocation(line: 361, column: 14, scope: !632, inlinedAt: !422, atomGroup: 36, atomRank: 2)
!632 = distinct !DILexicalBlock(scope: !627, file: !3, line: 361, column: 13)
!633 = !DILocation(line: 361, column: 13, scope: !632, inlinedAt: !422, atomGroup: 36, atomRank: 1)
!634 = !DILocation(line: 363, column: 20, scope: !627, inlinedAt: !422, atomGroup: 38, atomRank: 2)
!635 = !DILocation(line: 363, column: 18, scope: !627, inlinedAt: !422, atomGroup: 38, atomRank: 1)
!636 = distinct !DIAssignID()
!637 = !DILocation(line: 364, column: 43, scope: !627, inlinedAt: !422)
!638 = !DILocation(line: 364, column: 16, scope: !627, inlinedAt: !422, atomGroup: 39, atomRank: 3)
!639 = !DILocation(line: 364, column: 16, scope: !627, inlinedAt: !422, atomGroup: 39, atomRank: 2)
!640 = !DILocation(line: 364, column: 9, scope: !627, inlinedAt: !422, atomGroup: 39, atomRank: 1)
!641 = !DILocation(line: 377, column: 1, scope: !376, inlinedAt: !422)
!642 = !DILocation(line: 547, column: 9, scope: !356, atomGroup: 27, atomRank: 1)
!643 = !DILocation(line: 381, column: 33, scope: !292, inlinedAt: !354, atomGroup: 1, atomRank: 2)
!644 = !DILocation(line: 384, column: 5, scope: !292, inlinedAt: !354)
!645 = !DILocation(line: 387, column: 5, scope: !292, inlinedAt: !354)
!646 = !DILocation(line: 387, column: 11, scope: !292, inlinedAt: !354, atomGroup: 2, atomRank: 1)
!647 = distinct !DIAssignID()
!648 = !DILocation(line: 390, column: 5, scope: !292, inlinedAt: !354)
!649 = !DILocation(line: 391, column: 20, scope: !292, inlinedAt: !354, atomGroup: 3, atomRank: 2)
!650 = !DILocation(line: 400, column: 23, scope: !651, inlinedAt: !354)
!651 = distinct !DILexicalBlock(scope: !292, file: !3, line: 400, column: 9)
!652 = !DILocation(line: 400, column: 28, scope: !651, inlinedAt: !354, atomGroup: 5, atomRank: 2)
!653 = !DILocation(line: 400, column: 28, scope: !651, inlinedAt: !354, atomGroup: 5, atomRank: 1)
!654 = !DILocation(line: 402, column: 18, scope: !655, inlinedAt: !354)
!655 = distinct !DILexicalBlock(scope: !292, file: !3, line: 402, column: 9)
!656 = !{!657, !247, i64 6}
!657 = !{!"ipv6hdr", !247, i64 0, !247, i64 0, !247, i64 1, !446, i64 4, !247, i64 6, !247, i64 7, !247, i64 8}
!658 = !DILocation(line: 402, column: 42, scope: !655, inlinedAt: !354, atomGroup: 7, atomRank: 1)
!659 = !DILocation(line: 0, scope: !510, inlinedAt: !660)
!660 = distinct !DILocation(line: 405, column: 13, scope: !292, inlinedAt: !354)
!661 = !DILocation(line: 222, column: 29, scope: !522, inlinedAt: !660)
!662 = !DILocation(line: 222, column: 34, scope: !522, inlinedAt: !660, atomGroup: 3, atomRank: 2)
!663 = !DILocation(line: 0, scope: !526, inlinedAt: !664)
!664 = distinct !DILocation(line: 409, column: 13, scope: !292, inlinedAt: !354)
!665 = !DILocation(line: 222, column: 34, scope: !522, inlinedAt: !660, atomGroup: 3, atomRank: 1)
!666 = !DILocation(line: 227, column: 29, scope: !536, inlinedAt: !660)
!667 = !DILocation(line: 227, column: 34, scope: !536, inlinedAt: !660, atomGroup: 7, atomRank: 2)
!668 = !DILocation(line: 227, column: 34, scope: !536, inlinedAt: !660, atomGroup: 7, atomRank: 1)
!669 = !DILocation(line: 0, scope: !670, inlinedAt: !354)
!670 = distinct !DILexicalBlock(scope: !292, file: !3, line: 413, column: 9)
!671 = distinct !DIAssignID()
!672 = !DILocation(line: 423, column: 17, scope: !292, inlinedAt: !354, atomGroup: 23, atomRank: 2)
!673 = !DILocation(line: 415, column: 5, scope: !674, inlinedAt: !354)
!674 = distinct !DILexicalBlock(scope: !670, file: !3, line: 413, column: 39)
!675 = distinct !DIAssignID()
!676 = !DILocation(line: 0, scope: !523, inlinedAt: !660)
!677 = !{!446, !446, i64 0}
!678 = !DILocation(line: 0, scope: !544, inlinedAt: !664)
!679 = !DILocation(line: 418, column: 39, scope: !292, inlinedAt: !354)
!680 = !DILocation(line: 418, column: 5, scope: !292, inlinedAt: !354, atomGroup: 19, atomRank: 1)
!681 = distinct !DIAssignID()
!682 = !DILocation(line: 419, column: 28, scope: !292, inlinedAt: !354)
!683 = !DILocation(line: 419, column: 39, scope: !292, inlinedAt: !354)
!684 = !DILocation(line: 419, column: 5, scope: !292, inlinedAt: !354, atomGroup: 20, atomRank: 1)
!685 = distinct !DIAssignID()
!686 = !DILocation(line: 420, column: 11, scope: !292, inlinedAt: !354)
!687 = !DILocation(line: 420, column: 21, scope: !292, inlinedAt: !354, atomGroup: 21, atomRank: 1)
!688 = distinct !DIAssignID()
!689 = !DILocation(line: 421, column: 5, scope: !292, inlinedAt: !354)
!690 = !DILocation(line: 421, column: 21, scope: !292, inlinedAt: !354, atomGroup: 22, atomRank: 1)
!691 = distinct !DIAssignID()
!692 = !DILocation(line: 423, column: 17, scope: !292, inlinedAt: !354, atomGroup: 23, atomRank: 1)
!693 = distinct !DIAssignID()
!694 = !DILocation(line: 424, column: 11, scope: !292, inlinedAt: !354)
!695 = !DILocation(line: 424, column: 17, scope: !292, inlinedAt: !354, atomGroup: 24, atomRank: 1)
!696 = !{!697, !446, i64 38}
!697 = !{!"flowv6_keys", !247, i64 0, !247, i64 16, !247, i64 32, !247, i64 36, !446, i64 36, !446, i64 38}
!698 = distinct !DIAssignID()
!699 = !DILocation(line: 426, column: 13, scope: !292, inlinedAt: !354, atomGroup: 25, atomRank: 2)
!700 = !DILocation(line: 427, column: 9, scope: !701, inlinedAt: !354, atomGroup: 26, atomRank: 2)
!701 = distinct !DILexicalBlock(scope: !292, file: !3, line: 427, column: 9)
!702 = !DILocation(line: 427, column: 9, scope: !701, inlinedAt: !354, atomGroup: 26, atomRank: 1)
!703 = !DILocation(line: 433, column: 23, scope: !704, inlinedAt: !354)
!704 = distinct !DILexicalBlock(scope: !701, file: !3, line: 427, column: 16)
!705 = !DILocation(line: 433, column: 23, scope: !704, inlinedAt: !354, atomGroup: 27, atomRank: 2)
!706 = !DILocation(line: 433, column: 23, scope: !704, inlinedAt: !354, atomGroup: 27, atomRank: 1)
!707 = !DILocation(line: 434, column: 34, scope: !704, inlinedAt: !354)
!708 = !DILocation(line: 434, column: 16, scope: !704, inlinedAt: !354)
!709 = !DILocation(line: 434, column: 22, scope: !704, inlinedAt: !354)
!710 = !DILocation(line: 434, column: 22, scope: !704, inlinedAt: !354, atomGroup: 28, atomRank: 2)
!711 = !DILocation(line: 434, column: 22, scope: !704, inlinedAt: !354, atomGroup: 28, atomRank: 1)
!712 = !DILocation(line: 441, column: 22, scope: !704, inlinedAt: !354, atomGroup: 29, atomRank: 2)
!713 = !DILocation(line: 442, column: 14, scope: !714, inlinedAt: !354, atomGroup: 30, atomRank: 2)
!714 = distinct !DILexicalBlock(scope: !704, file: !3, line: 442, column: 13)
!715 = !DILocation(line: 442, column: 13, scope: !714, inlinedAt: !354, atomGroup: 30, atomRank: 1)
!716 = !DILocation(line: 445, column: 20, scope: !717, inlinedAt: !354, atomGroup: 32, atomRank: 3)
!717 = distinct !DILexicalBlock(scope: !714, file: !3, line: 444, column: 16)
!718 = !DILocation(line: 445, column: 20, scope: !717, inlinedAt: !354, atomGroup: 32, atomRank: 2)
!719 = !DILocation(line: 445, column: 13, scope: !717, inlinedAt: !354, atomGroup: 32, atomRank: 1)
!720 = !DILocation(line: 454, column: 17, scope: !292, inlinedAt: !354)
!721 = !DILocation(line: 454, column: 32, scope: !292, inlinedAt: !354)
!722 = !DILocation(line: 454, column: 30, scope: !292, inlinedAt: !354, atomGroup: 33, atomRank: 2)
!723 = !DILocation(line: 455, column: 17, scope: !292, inlinedAt: !354)
!724 = !DILocation(line: 455, column: 32, scope: !292, inlinedAt: !354)
!725 = !DILocation(line: 455, column: 30, scope: !292, inlinedAt: !354)
!726 = !DILocation(line: 455, column: 14, scope: !292, inlinedAt: !354, atomGroup: 34, atomRank: 2)
!727 = !DILocation(line: 456, column: 17, scope: !292, inlinedAt: !354)
!728 = !DILocation(line: 456, column: 32, scope: !292, inlinedAt: !354)
!729 = !DILocation(line: 456, column: 30, scope: !292, inlinedAt: !354)
!730 = !DILocation(line: 456, column: 14, scope: !292, inlinedAt: !354, atomGroup: 35, atomRank: 2)
!731 = !DILocation(line: 457, column: 17, scope: !292, inlinedAt: !354)
!732 = !DILocation(line: 457, column: 32, scope: !292, inlinedAt: !354)
!733 = !DILocation(line: 457, column: 30, scope: !292, inlinedAt: !354)
!734 = !DILocation(line: 457, column: 14, scope: !292, inlinedAt: !354, atomGroup: 36, atomRank: 2)
!735 = !DILocation(line: 23, column: 12, scope: !599, inlinedAt: !373)
!736 = !DILocation(line: 23, column: 9, scope: !599, inlinedAt: !373, atomGroup: 9, atomRank: 2)
!737 = !DILocation(line: 24, column: 32, scope: !599, inlinedAt: !373)
!738 = !DILocation(line: 25, column: 18, scope: !599, inlinedAt: !373)
!739 = !DILocation(line: 25, column: 25, scope: !599, inlinedAt: !373, atomGroup: 11, atomRank: 2)
!740 = !DILocation(line: 27, column: 17, scope: !599, inlinedAt: !373)
!741 = !DILocation(line: 27, column: 9, scope: !599, inlinedAt: !373, atomGroup: 13, atomRank: 2)
!742 = !DILocation(line: 47, column: 15, scope: !360, inlinedAt: !373)
!743 = !DILocation(line: 47, column: 7, scope: !360, inlinedAt: !373, atomGroup: 29, atomRank: 2)
!744 = !DILocation(line: 48, column: 15, scope: !360, inlinedAt: !373)
!745 = !DILocation(line: 48, column: 7, scope: !360, inlinedAt: !373, atomGroup: 30, atomRank: 2)
!746 = !DILocation(line: 49, column: 15, scope: !360, inlinedAt: !373)
!747 = !DILocation(line: 49, column: 7, scope: !360, inlinedAt: !373, atomGroup: 31, atomRank: 2)
!748 = !DILocation(line: 50, column: 15, scope: !360, inlinedAt: !373)
!749 = !DILocation(line: 50, column: 7, scope: !360, inlinedAt: !373, atomGroup: 32, atomRank: 2)
!750 = !DILocation(line: 51, column: 15, scope: !360, inlinedAt: !373)
!751 = !DILocation(line: 51, column: 7, scope: !360, inlinedAt: !373, atomGroup: 33, atomRank: 2)
!752 = !DILocation(line: 52, column: 15, scope: !360, inlinedAt: !373)
!753 = !DILocation(line: 52, column: 7, scope: !360, inlinedAt: !373, atomGroup: 34, atomRank: 2)
!754 = !DILocation(line: 460, column: 9, scope: !755, inlinedAt: !354, atomGroup: 38, atomRank: 2)
!755 = distinct !DILexicalBlock(scope: !292, file: !3, line: 460, column: 9)
!756 = !DILocation(line: 460, column: 17, scope: !755, inlinedAt: !354, atomGroup: 38, atomRank: 1)
!757 = !DILocation(line: 460, column: 20, scope: !755, inlinedAt: !354)
!758 = !DILocation(line: 460, column: 20, scope: !755, inlinedAt: !354, atomGroup: 39, atomRank: 2)
!759 = !DILocation(line: 460, column: 17, scope: !755, inlinedAt: !354, atomGroup: 39, atomRank: 1)
!760 = !DILocation(line: 461, column: 29, scope: !761, inlinedAt: !354, atomGroup: 40, atomRank: 2)
!761 = distinct !DILexicalBlock(scope: !755, file: !3, line: 460, column: 30)
!762 = !DILocation(line: 461, column: 18, scope: !761, inlinedAt: !354, atomGroup: 40, atomRank: 1)
!763 = distinct !DIAssignID()
!764 = !DILocation(line: 462, column: 24, scope: !761, inlinedAt: !354, atomGroup: 41, atomRank: 2)
!765 = !DILocation(line: 463, column: 14, scope: !766, inlinedAt: !354, atomGroup: 42, atomRank: 2)
!766 = distinct !DILexicalBlock(scope: !761, file: !3, line: 463, column: 13)
!767 = !DILocation(line: 463, column: 13, scope: !766, inlinedAt: !354, atomGroup: 42, atomRank: 1)
!768 = !DILocation(line: 465, column: 20, scope: !761, inlinedAt: !354, atomGroup: 44, atomRank: 2)
!769 = !DILocation(line: 465, column: 18, scope: !761, inlinedAt: !354, atomGroup: 44, atomRank: 1)
!770 = distinct !DIAssignID()
!771 = !DILocation(line: 466, column: 43, scope: !761, inlinedAt: !354)
!772 = !DILocation(line: 466, column: 16, scope: !761, inlinedAt: !354, atomGroup: 45, atomRank: 3)
!773 = !DILocation(line: 466, column: 16, scope: !761, inlinedAt: !354, atomGroup: 45, atomRank: 2)
!774 = !DILocation(line: 466, column: 9, scope: !761, inlinedAt: !354, atomGroup: 45, atomRank: 1)
!775 = !DILocation(line: 483, column: 1, scope: !292, inlinedAt: !354)
!776 = !DILocation(line: 549, column: 9, scope: !355, atomGroup: 29, atomRank: 1)
!777 = !DILocation(line: 552, column: 1, scope: !249, atomGroup: 31, atomRank: 1)
