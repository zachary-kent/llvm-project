; ModuleID = 'xdp_lb.c'
source_filename = "xdp_lb.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.anon.0 = type { ptr, ptr, ptr, ptr }
%struct.anon.1 = type { ptr, ptr, ptr, ptr }

@__license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@__version = dso_local global i32 263682, section "version", align 4, !dbg !139
@cpu_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !141
@cpus_available = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !158
@cpus_count = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !170
@llvm.compiler.used = appending global [6 x ptr] [ptr @__license, ptr @__version, ptr @cpu_map, ptr @cpus_available, ptr @cpus_count, ptr @xdp_loadfilter], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_loadfilter(ptr noundef %ctx) #0 section "xdp" !dbg !216 {
entry:
  %key0.i143 = alloca i32, align 4, !DIAssignID !232
    #dbg_assign(i1 poison, !233, !DIExpression(), !232, ptr %key0.i143, !DIExpression(), !285)
  %cpu_dest.i144 = alloca i32, align 4, !DIAssignID !297
    #dbg_assign(i1 poison, !281, !DIExpression(), !297, ptr %cpu_dest.i144, !DIExpression(), !285)
    #dbg_value(ptr poison, !298, !DIExpression(DW_OP_LLVM_fragment, 0, 16), !311)
    #dbg_value(ptr poison, !298, !DIExpression(DW_OP_LLVM_fragment, 16, 16), !311)
  %key0.i126 = alloca i32, align 4, !DIAssignID !313
    #dbg_assign(i1 poison, !233, !DIExpression(), !313, ptr %key0.i126, !DIExpression(), !314)
  %cpu_dest.i127 = alloca i32, align 4, !DIAssignID !330
    #dbg_assign(i1 poison, !281, !DIExpression(), !330, ptr %cpu_dest.i127, !DIExpression(), !314)
    #dbg_value(ptr poison, !298, !DIExpression(DW_OP_LLVM_fragment, 0, 16), !331)
    #dbg_value(ptr poison, !298, !DIExpression(DW_OP_LLVM_fragment, 16, 16), !331)
  %key0.i101 = alloca i32, align 4, !DIAssignID !333
    #dbg_assign(i1 poison, !334, !DIExpression(), !333, ptr %key0.i101, !DIExpression(), !344)
  %cpu_dest.i102 = alloca i32, align 4, !DIAssignID !346
    #dbg_assign(i1 poison, !340, !DIExpression(), !346, ptr %cpu_dest.i102, !DIExpression(), !344)
    #dbg_value(ptr poison, !298, !DIExpression(DW_OP_LLVM_fragment, 0, 16), !347)
    #dbg_value(ptr poison, !298, !DIExpression(DW_OP_LLVM_fragment, 16, 16), !347)
  %key0.i = alloca i32, align 4, !DIAssignID !349
    #dbg_assign(i1 poison, !334, !DIExpression(), !349, ptr %key0.i, !DIExpression(), !350)
  %cpu_dest.i = alloca i32, align 4, !DIAssignID !353
    #dbg_assign(i1 poison, !340, !DIExpression(), !353, ptr %cpu_dest.i, !DIExpression(), !350)
    #dbg_value(ptr poison, !298, !DIExpression(DW_OP_LLVM_fragment, 0, 16), !354)
    #dbg_value(ptr poison, !298, !DIExpression(DW_OP_LLVM_fragment, 16, 16), !354)
    #dbg_value(ptr %ctx, !220, !DIExpression(), !356)
  %data_end1 = getelementptr inbounds nuw i8, ptr %ctx, i64 4, !dbg !357
  %0 = load i32, ptr %data_end1, align 4, !dbg !358, !tbaa !359
  %conv = zext i32 %0 to i64, !dbg !361
  %1 = inttoptr i64 %conv to ptr, !dbg !362
    #dbg_value(ptr %1, !221, !DIExpression(), !356)
  %2 = load i32, ptr %ctx, align 4, !dbg !363, !tbaa !364
  %conv3 = zext i32 %2 to i64, !dbg !365
  %3 = inttoptr i64 %conv3 to ptr, !dbg !366
    #dbg_value(ptr %3, !222, !DIExpression(), !356)
    #dbg_value(ptr %3, !223, !DIExpression(), !356)
    #dbg_value(i64 14, !225, !DIExpression(), !356)
  %add.ptr = getelementptr inbounds nuw i8, ptr %3, i64 14, !dbg !367
  %cmp = icmp samesign ugt ptr %add.ptr, %1, !dbg !369
  br i1 %cmp, label %cleanup52, label %if.end, !dbg !370

if.end:                                           ; preds = %entry
  %h_proto5 = getelementptr inbounds nuw i8, ptr %3, i64 12, !dbg !371
  %4 = load i16, ptr %h_proto5, align 1, !dbg !372, !tbaa !373
    #dbg_value(i16 %4, !224, !DIExpression(), !356)
  %cmp7 = icmp eq i16 %4, 129, !dbg !376
  %cmp10 = icmp eq i16 %4, -22392
  %5 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 0, i1 %cmp7)
  %or.cond = select i1 %5, i1 true, i1 %cmp10, !dbg !377
  br i1 %or.cond, label %if.then12, label %if.end19, !dbg !377

if.then12:                                        ; preds = %if.end
    #dbg_value(ptr %add.ptr, !226, !DIExpression(), !378)
    #dbg_value(i64 18, !225, !DIExpression(), !356)
  %add.ptr14 = getelementptr inbounds nuw i8, ptr %3, i64 18, !dbg !379
  %cmp15.not = icmp samesign ugt ptr %add.ptr14, %1, !dbg !381
  br i1 %cmp15.not, label %cleanup52, label %if.end18, !dbg !382

if.end18:                                         ; preds = %if.then12
  %h_vlan_encapsulated_proto = getelementptr inbounds nuw i8, ptr %3, i64 16, !dbg !383
  %6 = load i16, ptr %h_vlan_encapsulated_proto, align 2, !dbg !384, !tbaa !385
    #dbg_value(i16 %6, !224, !DIExpression(), !356)
  br label %if.end19

if.end19:                                         ; preds = %if.end18, %if.end
  %nh_off.0 = phi i64 [ 18, %if.end18 ], [ 14, %if.end ], !dbg !356
  %h_proto.1 = phi i16 [ %6, %if.end18 ], [ %4, %if.end ], !dbg !387
    #dbg_value(i16 %h_proto.1, !224, !DIExpression(), !356)
    #dbg_value(i64 %nh_off.0, !225, !DIExpression(), !356)
  %cmp21 = icmp eq i16 %h_proto.1, 129, !dbg !388
  %cmp25 = icmp eq i16 %h_proto.1, -22392
  %7 = tail call i1 @llvm.bpf.passthrough.i1.i1(i32 1, i1 %cmp21)
  %or.cond58 = select i1 %7, i1 true, i1 %cmp25, !dbg !389
  br i1 %or.cond58, label %if.then27, label %if.end40, !dbg !389

if.then27:                                        ; preds = %if.end19
    #dbg_value(!DIArgList(ptr %3, i64 %nh_off.0), !229, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !390)
  %add30 = add nuw nsw i64 %nh_off.0, 4, !dbg !391
    #dbg_value(i64 %add30, !225, !DIExpression(), !356)
  %add.ptr31 = getelementptr inbounds nuw i8, ptr %3, i64 %add30, !dbg !392
  %cmp32.not = icmp samesign ugt ptr %add.ptr31, %1, !dbg !394
  br i1 %cmp32.not, label %cleanup52, label %if.end35, !dbg !395

if.end35:                                         ; preds = %if.then27
  %add.ptr29 = getelementptr inbounds nuw i8, ptr %3, i64 %nh_off.0, !dbg !396
    #dbg_value(ptr %add.ptr29, !229, !DIExpression(), !390)
  %h_vlan_encapsulated_proto36 = getelementptr inbounds nuw i8, ptr %add.ptr29, i64 2, !dbg !397
  %8 = load i16, ptr %h_vlan_encapsulated_proto36, align 2, !dbg !398, !tbaa !385
    #dbg_value(i16 %8, !224, !DIExpression(), !356)
  br label %if.end40

if.end40:                                         ; preds = %if.end35, %if.end19
  %nh_off.1 = phi i64 [ %add30, %if.end35 ], [ %nh_off.0, %if.end19 ], !dbg !356
  %h_proto.3 = phi i16 [ %8, %if.end35 ], [ %h_proto.1, %if.end19 ], !dbg !387
    #dbg_value(i16 %h_proto.3, !224, !DIExpression(), !356)
    #dbg_value(i64 %nh_off.1, !225, !DIExpression(), !356)
  switch i16 %h_proto.3, label %cleanup52 [
    i16 8, label %if.then44
    i16 -8826, label %if.then48
  ], !dbg !399

if.then44:                                        ; preds = %if.end40
    #dbg_value(ptr %ctx, !324, !DIExpression(), !400)
    #dbg_value(ptr %3, !325, !DIExpression(), !400)
    #dbg_value(i64 %nh_off.1, !326, !DIExpression(), !400)
    #dbg_value(ptr %1, !327, !DIExpression(), !400)
  %add.ptr.i = getelementptr inbounds nuw i8, ptr %3, i64 %nh_off.1, !dbg !401
    #dbg_value(ptr %add.ptr.i, !328, !DIExpression(), !400)
  %add.ptr1.i = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 20, !dbg !402
  %cmp.i = icmp ugt ptr %add.ptr1.i, %1, !dbg !404
  br i1 %cmp.i, label %cleanup52, label %if.end.i, !dbg !405

if.end.i:                                         ; preds = %if.then44
  %protocol.i = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 9, !dbg !406
  %9 = load i8, ptr %protocol.i, align 1, !dbg !406, !tbaa !407
  %cmp2.i = icmp eq i8 %9, 47, !dbg !409
  br i1 %cmp2.i, label %if.then4.i, label %if.end.i106, !dbg !410

if.then4.i:                                       ; preds = %if.end.i
    #dbg_value(ptr %ctx, !74, !DIExpression(), !411)
    #dbg_value(ptr %3, !75, !DIExpression(), !411)
    #dbg_value(ptr %1, !77, !DIExpression(), !411)
    #dbg_value(ptr %add.ptr.i, !78, !DIExpression(), !411)
    #dbg_value(i64 %nh_off.1, !76, !DIExpression(DW_OP_plus_uconst, 20, DW_OP_stack_value), !411)
    #dbg_value(ptr %add.ptr1.i, !110, !DIExpression(), !411)
  %add.ptr2.i = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 24, !dbg !412
  %cmp.i92 = icmp ugt ptr %add.ptr2.i, %1, !dbg !414
  br i1 %cmp.i92, label %cleanup52, label %if.end.i93, !dbg !415

if.end.i93:                                       ; preds = %if.then4.i
  %10 = load i16, ptr %add.ptr1.i, align 2, !dbg !416, !tbaa !418
  %conv.i = zext i16 %10 to i32, !dbg !420
  %and.i = and i32 %conv.i, 1856, !dbg !421
  %tobool.not.i = icmp eq i32 %and.i, 0, !dbg !422
  br i1 %tobool.not.i, label %if.end4.i, label %cleanup52, !dbg !423

if.end4.i:                                        ; preds = %if.end.i93
    #dbg_value(i64 %nh_off.1, !76, !DIExpression(DW_OP_plus_uconst, 24, DW_OP_stack_value), !411)
  %proto6.i = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 22, !dbg !424
  %11 = load i16, ptr %proto6.i, align 2, !dbg !425, !tbaa !426
    #dbg_value(i16 %11, !109, !DIExpression(), !411)
  %and9.i = and i32 %conv.i, 128, !dbg !427
  %tobool10.not.i = icmp eq i32 %and9.i, 0, !dbg !429
  %nh_off.addr.0.i.v = select i1 %tobool10.not.i, i64 24, i64 28, !dbg !430
    #dbg_value(i64 poison, !76, !DIExpression(), !411)
  %12 = lshr i16 %10, 3, !dbg !431
  %13 = and i16 %12, 4, !dbg !431
  %14 = zext nneg i16 %13 to i64, !dbg !431
  %15 = lshr i16 %10, 2, !dbg !433
  %16 = and i16 %15, 4, !dbg !433
  %17 = zext nneg i16 %16 to i64, !dbg !433
  %nh_off.addr.0.i = add nuw nsw i64 %nh_off.1, %14, !dbg !430
  %nh_off.addr.1.i = add nuw nsw i64 %nh_off.addr.0.i, %17, !dbg !431
  %nh_off.addr.2.i = add nuw nsw i64 %nh_off.addr.1.i, %nh_off.addr.0.i.v, !dbg !433
    #dbg_value(i64 %nh_off.addr.2.i, !76, !DIExpression(), !411)
  %cmp29.i = icmp eq i16 %11, -16760, !dbg !435
  %add32.i = add nuw nsw i64 %nh_off.addr.2.i, 8, !dbg !437
  %nh_off.addr.3.i = select i1 %cmp29.i, i64 %add32.i, i64 %nh_off.addr.2.i, !dbg !437
    #dbg_value(i64 %nh_off.addr.3.i, !76, !DIExpression(), !411)
  %add.ptr34.i = getelementptr inbounds nuw i8, ptr %3, i64 %nh_off.addr.3.i, !dbg !438
  %cmp35.i = icmp ugt ptr %add.ptr34.i, %1, !dbg !440
  br i1 %cmp35.i, label %cleanup52, label %if.end38.i, !dbg !441

if.end38.i:                                       ; preds = %if.end4.i
  %conv40.i = trunc nuw nsw i64 %nh_off.addr.3.i to i32, !dbg !442
  %call.i94 = tail call i64 inttoptr (i64 44 to ptr)(ptr noundef nonnull %ctx, i32 noundef %conv40.i) #3, !dbg !444
  %tobool41.not.i = icmp eq i64 %call.i94, 0, !dbg !445
  br i1 %tobool41.not.i, label %if.end43.i, label %cleanup52, !dbg !446

if.end43.i:                                       ; preds = %if.end38.i
  %18 = load i32, ptr %ctx, align 4, !dbg !447, !tbaa !364
  %conv45.i = zext i32 %18 to i64, !dbg !448
  %19 = inttoptr i64 %conv45.i to ptr, !dbg !449
    #dbg_value(ptr %19, !75, !DIExpression(), !411)
  %20 = load i32, ptr %data_end1, align 4, !dbg !450, !tbaa !359
  %conv47.i = zext i32 %20 to i64, !dbg !451
  %21 = inttoptr i64 %conv47.i to ptr, !dbg !452
    #dbg_value(ptr %21, !77, !DIExpression(), !411)
    #dbg_value(ptr %19, !111, !DIExpression(), !411)
    #dbg_value(i16 poison, !109, !DIExpression(), !411)
    #dbg_value(i64 14, !76, !DIExpression(), !411)
  %add.ptr48.i = getelementptr inbounds nuw i8, ptr %19, i64 14, !dbg !453
  %cmp49.i = icmp samesign ugt ptr %add.ptr48.i, %21, !dbg !455
  br i1 %cmp49.i, label %cleanup52, label %if.end52.i, !dbg !456

if.end52.i:                                       ; preds = %if.end43.i
  %h_proto.i = getelementptr inbounds nuw i8, ptr %19, i64 12, !dbg !457
  %22 = load i16, ptr %h_proto.i, align 1, !dbg !458, !tbaa !373
    #dbg_value(i16 %22, !109, !DIExpression(), !411)
  %cmp54.i = icmp eq i16 %22, 129, !dbg !459
  br i1 %cmp54.i, label %if.then56.i, label %if.end64.i, !dbg !460

if.then56.i:                                      ; preds = %if.end52.i
    #dbg_value(ptr %add.ptr48.i, !122, !DIExpression(), !461)
  %add.ptr58.i = getelementptr inbounds nuw i8, ptr %19, i64 18, !dbg !462
  %cmp59.not.i = icmp samesign ugt ptr %add.ptr58.i, %21, !dbg !464
  br i1 %cmp59.not.i, label %cleanup52, label %if.end62.i, !dbg !465

if.end62.i:                                       ; preds = %if.then56.i
  %h_vlan_encapsulated_proto.i = getelementptr inbounds nuw i8, ptr %19, i64 16, !dbg !466
  %23 = load i16, ptr %h_vlan_encapsulated_proto.i, align 2, !dbg !467, !tbaa !385
    #dbg_value(i64 18, !76, !DIExpression(), !411)
    #dbg_value(i16 %23, !109, !DIExpression(), !411)
  br label %if.end64.i

if.end64.i:                                       ; preds = %if.end62.i, %if.end52.i
  %proto.1.i = phi i16 [ %23, %if.end62.i ], [ %22, %if.end52.i ], !dbg !468
  %nh_off.addr.5.i = phi i64 [ 18, %if.end62.i ], [ 14, %if.end52.i ], !dbg !469
    #dbg_value(i64 %nh_off.addr.5.i, !76, !DIExpression(), !411)
    #dbg_value(i16 %proto.1.i, !109, !DIExpression(), !411)
  %add.ptr65.i = getelementptr inbounds nuw i8, ptr %19, i64 %nh_off.addr.5.i, !dbg !470
  %cmp66.i = icmp samesign ugt ptr %add.ptr65.i, %21, !dbg !472
  br i1 %cmp66.i, label %cleanup52, label %if.end69.i, !dbg !473

if.end69.i:                                       ; preds = %if.end64.i
  switch i16 %proto.1.i, label %cleanup52 [
    i16 8, label %if.then73.i
    i16 -8826, label %if.then79.i
  ], !dbg !474

if.then73.i:                                      ; preds = %if.end69.i
    #dbg_value(ptr %add.ptr65.i, !337, !DIExpression(), !350)
    #dbg_value(ptr %21, !338, !DIExpression(), !350)
    #dbg_value(ptr %add.ptr65.i, !339, !DIExpression(), !350)
  %add.ptr.i95 = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 20, !dbg !475
  %cmp.i96 = icmp samesign ugt ptr %add.ptr.i95, %21, !dbg !477
  br i1 %cmp.i96, label %cleanup52, label %if.end.i97, !dbg !478

if.end.i97:                                       ; preds = %if.then73.i
  call void @llvm.lifetime.start.p0(ptr nonnull %key0.i) #3, !dbg !479
  store i32 0, ptr %key0.i, align 4, !dbg !480, !tbaa !212, !DIAssignID !481
    #dbg_assign(i32 0, !334, !DIExpression(), !481, ptr %key0.i, !DIExpression(), !350)
  call void @llvm.lifetime.start.p0(ptr nonnull %cpu_dest.i) #3, !dbg !482
  %call.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_count, ptr noundef nonnull %key0.i) #3, !dbg !483
    #dbg_value(ptr %call.i, !341, !DIExpression(), !350)
  %24 = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 12, !dbg !484
  %25 = load i32, ptr %24, align 4, !dbg !484, !tbaa !485
  %daddr.i = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 16, !dbg !486
  %26 = load i32, ptr %daddr.i, align 4, !dbg !486, !tbaa !485
  %add.i = add i32 %26, %25, !dbg !487
    #dbg_value(i32 %add.i, !343, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !350)
    #dbg_value(i32 %add.i, !343, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !350)
    #dbg_value(i32 15485863, !307, !DIExpression(), !354)
    #dbg_value(i32 0, !310, !DIExpression(), !354)
    #dbg_value(i32 poison, !306, !DIExpression(), !354)
    #dbg_value(ptr undef, !298, !DIExpression(), !354)
    #dbg_value(i32 15485863, !308, !DIExpression(), !354)
  %conv.i261 = and i32 %add.i, 65535, !dbg !488
  %add.i262 = add nuw nsw i32 %conv.i261, 15485863, !dbg !492
    #dbg_value(i32 %add.i262, !308, !DIExpression(), !354)
  %27 = lshr i32 %add.i, 5, !dbg !493
  %shl.i265 = and i32 %27, 134215680, !dbg !493
    #dbg_value(!DIArgList(i32 %shl.i265, i32 %add.i262), !309, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_xor, DW_OP_stack_value), !354)
  %shl4.i266 = shl i32 %add.i262, 16, !dbg !494
  %28 = xor i32 %shl4.i266, %shl.i265, !dbg !495
  %xor5.i267 = xor i32 %28, %add.i262, !dbg !495
    #dbg_value(i32 %xor5.i267, !308, !DIExpression(), !354)
    #dbg_value(ptr undef, !298, !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value), !354)
  %shr7.i269 = lshr i32 %xor5.i267, 11, !dbg !496
  %add8.i270 = add i32 %shr7.i269, %xor5.i267, !dbg !497
    #dbg_value(!DIArgList(i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !354)
  %shl32.i248 = shl i32 %add8.i270, 3, !dbg !498
  %xor33.i249 = xor i32 %shl32.i248, %add8.i270, !dbg !499
  %shr34.i250 = lshr i32 %xor33.i249, 5, !dbg !500
  %add35.i251 = add i32 %shr34.i250, %xor33.i249, !dbg !501
    #dbg_value(!DIArgList(i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !354)
  %shl36.i252 = shl i32 %add35.i251, 4, !dbg !502
    #dbg_value(!DIArgList(i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %add35.i251, i32 %shl36.i252, i32 %shl36.i252, i32 %shl36.i252, i32 %shl36.i252, i32 %shl36.i252, i32 %shl36.i252, i32 %shl36.i252, i32 %shl36.i252), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !354)
  %xor37.i253 = xor i32 %shl36.i252, %add35.i251, !dbg !503
    #dbg_value(!DIArgList(i32 %xor37.i253, i32 %xor37.i253, i32 %xor37.i253, i32 %xor37.i253, i32 %xor37.i253, i32 %xor37.i253, i32 %xor37.i253, i32 %xor37.i253), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !354)
  %shr38.i254 = lshr i32 %xor37.i253, 17, !dbg !504
    #dbg_value(!DIArgList(i32 %xor37.i253, i32 %xor37.i253, i32 %xor37.i253, i32 %xor37.i253, i32 %shr38.i254, i32 %shr38.i254, i32 %shr38.i254, i32 %shr38.i254), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !354)
  %add39.i255 = add i32 %shr38.i254, %xor37.i253, !dbg !505
    #dbg_value(!DIArgList(i32 %add39.i255, i32 %add39.i255, i32 %add39.i255, i32 %add39.i255), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !354)
  %shl40.i256 = shl i32 %add39.i255, 25, !dbg !506
    #dbg_value(!DIArgList(i32 %add39.i255, i32 %add39.i255, i32 %shl40.i256, i32 %shl40.i256), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !354)
  %xor41.i257 = xor i32 %shl40.i256, %add39.i255, !dbg !507
    #dbg_value(!DIArgList(i32 %xor41.i257, i32 %xor41.i257), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !354)
  %shr42.i258 = lshr i32 %xor41.i257, 6, !dbg !508
    #dbg_value(!DIArgList(i32 %xor41.i257, i32 %shr42.i258), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !354)
  %add43.i259 = add i32 %shr42.i258, %xor41.i257, !dbg !509
    #dbg_value(i32 %add43.i259, !308, !DIExpression(), !354)
    #dbg_value(i32 %add43.i259, !343, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !350)
    #dbg_value(i32 %add43.i259, !343, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !350)
  %tobool.not.i98 = icmp eq ptr %call.i, null, !dbg !510
  br i1 %tobool.not.i98, label %cleanup.i, label %land.lhs.true.i, !dbg !512

land.lhs.true.i:                                  ; preds = %if.end.i97
  %29 = load i32, ptr %call.i, align 4, !dbg !513, !tbaa !212
  %tobool2.not.i = icmp eq i32 %29, 0, !dbg !514
  br i1 %tobool2.not.i, label %cleanup.i, label %if.then3.i, !dbg !515

if.then3.i:                                       ; preds = %land.lhs.true.i
  %rem.i = urem i32 %add43.i259, %29, !dbg !516
  store i32 %rem.i, ptr %cpu_dest.i, align 4, !dbg !518, !tbaa !212, !DIAssignID !519
    #dbg_assign(i32 %rem.i, !340, !DIExpression(), !519, ptr %cpu_dest.i, !DIExpression(), !350)
  %call4.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_available, ptr noundef nonnull %cpu_dest.i) #3, !dbg !520
    #dbg_value(ptr %call4.i, !342, !DIExpression(), !350)
  %tobool5.not.i = icmp eq ptr %call4.i, null, !dbg !521
  br i1 %tobool5.not.i, label %cleanup.i, label %if.end7.i, !dbg !523

if.end7.i:                                        ; preds = %if.then3.i
  %30 = load i32, ptr %call4.i, align 4, !dbg !524, !tbaa !212
  store i32 %30, ptr %cpu_dest.i, align 4, !dbg !525, !tbaa !212, !DIAssignID !526
    #dbg_assign(i32 %30, !340, !DIExpression(), !526, ptr %cpu_dest.i, !DIExpression(), !350)
  %conv.i99 = zext i32 %30 to i64, !dbg !527
  %call8.i = call i64 inttoptr (i64 51 to ptr)(ptr noundef nonnull @cpu_map, i64 noundef %conv.i99, i64 noundef 0) #3, !dbg !528
  %conv9.i = trunc i64 %call8.i to i32, !dbg !529
  br label %cleanup.i, !dbg !530

cleanup.i:                                        ; preds = %if.end7.i, %if.then3.i, %land.lhs.true.i, %if.end.i97
  %retval.0.i100 = phi i32 [ %conv9.i, %if.end7.i ], [ 0, %if.then3.i ], [ 2, %land.lhs.true.i ], [ 2, %if.end.i97 ], !dbg !531
  call void @llvm.lifetime.end.p0(ptr nonnull %cpu_dest.i) #3, !dbg !532
  call void @llvm.lifetime.end.p0(ptr nonnull %key0.i) #3, !dbg !532
  br label %cleanup52

if.then79.i:                                      ; preds = %if.end69.i
    #dbg_value(ptr %add.ptr65.i, !238, !DIExpression(), !314)
    #dbg_value(ptr %21, !239, !DIExpression(), !314)
    #dbg_value(ptr %add.ptr65.i, !240, !DIExpression(), !314)
  %add.ptr.i129 = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 40, !dbg !533
  %cmp.i130 = icmp samesign ugt ptr %add.ptr.i129, %21, !dbg !535
  br i1 %cmp.i130, label %cleanup52, label %if.end.i131, !dbg !536

if.end.i131:                                      ; preds = %if.then79.i
  call void @llvm.lifetime.start.p0(ptr nonnull %key0.i126) #3, !dbg !537
  store i32 0, ptr %key0.i126, align 4, !dbg !538, !tbaa !212, !DIAssignID !539
    #dbg_assign(i32 0, !233, !DIExpression(), !539, ptr %key0.i126, !DIExpression(), !314)
  call void @llvm.lifetime.start.p0(ptr nonnull %cpu_dest.i127) #3, !dbg !540
  %call.i132 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_count, ptr noundef nonnull %key0.i126) #3, !dbg !541
    #dbg_value(ptr %call.i132, !282, !DIExpression(), !314)
  %31 = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 8, !dbg !542
  %32 = load i32, ptr %31, align 4, !dbg !543, !tbaa !485
  %daddr.i133 = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 24, !dbg !544
  %33 = load i32, ptr %daddr.i133, align 4, !dbg !545, !tbaa !485
  %add.i134 = add i32 %33, %32, !dbg !546
    #dbg_value(i32 %add.i134, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !314)
    #dbg_value(i32 %add.i134, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !314)
  %arrayidx5.i = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 12, !dbg !547
  %34 = load i32, ptr %arrayidx5.i, align 4, !dbg !547, !tbaa !485
  %arrayidx8.i = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 28, !dbg !548
  %35 = load i32, ptr %arrayidx8.i, align 4, !dbg !548, !tbaa !485
  %add9.i = add i32 %34, %add.i134, !dbg !549
  %add10.i = add i32 %add9.i, %35, !dbg !550
    #dbg_value(i32 %add10.i, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !314)
    #dbg_value(i32 %add10.i, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !314)
  %arrayidx13.i = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 16, !dbg !551
  %36 = load i32, ptr %arrayidx13.i, align 4, !dbg !551, !tbaa !485
  %arrayidx16.i = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 32, !dbg !552
  %37 = load i32, ptr %arrayidx16.i, align 4, !dbg !552, !tbaa !485
  %add17.i = add i32 %add10.i, %36, !dbg !553
  %add18.i = add i32 %add17.i, %37, !dbg !554
    #dbg_value(i32 %add18.i, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !314)
    #dbg_value(i32 %add18.i, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !314)
  %arrayidx21.i = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 20, !dbg !555
  %38 = load i32, ptr %arrayidx21.i, align 4, !dbg !555, !tbaa !485
  %arrayidx24.i = getelementptr inbounds nuw i8, ptr %add.ptr65.i, i64 36, !dbg !556
  %39 = load i32, ptr %arrayidx24.i, align 4, !dbg !556, !tbaa !485
  %add25.i = add i32 %add18.i, %38, !dbg !557
  %add26.i135 = add i32 %add25.i, %39, !dbg !558
    #dbg_value(i32 %add26.i135, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !314)
    #dbg_value(i32 %add26.i135, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !314)
    #dbg_value(i32 15485863, !307, !DIExpression(), !331)
    #dbg_value(i32 0, !310, !DIExpression(), !331)
    #dbg_value(i32 poison, !306, !DIExpression(), !331)
    #dbg_value(ptr undef, !298, !DIExpression(), !331)
    #dbg_value(i32 15485863, !308, !DIExpression(), !331)
  %conv.i203 = and i32 %add26.i135, 65535, !dbg !559
  %add.i204 = add nuw nsw i32 %conv.i203, 15485863, !dbg !560
    #dbg_value(i32 %add.i204, !308, !DIExpression(), !331)
  %40 = lshr i32 %add26.i135, 5, !dbg !561
  %shl.i207 = and i32 %40, 134215680, !dbg !561
    #dbg_value(!DIArgList(i32 %shl.i207, i32 %add.i204), !309, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_xor, DW_OP_stack_value), !331)
  %shl4.i208 = shl i32 %add.i204, 16, !dbg !562
  %41 = xor i32 %shl4.i208, %shl.i207, !dbg !563
  %xor5.i209 = xor i32 %41, %add.i204, !dbg !563
    #dbg_value(i32 %xor5.i209, !308, !DIExpression(), !331)
    #dbg_value(ptr undef, !298, !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value), !331)
  %shr7.i211 = lshr i32 %xor5.i209, 11, !dbg !564
  %add8.i212 = add i32 %shr7.i211, %xor5.i209, !dbg !565
    #dbg_value(!DIArgList(i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !331)
  %shl32.i190 = shl i32 %add8.i212, 3, !dbg !566
  %xor33.i191 = xor i32 %shl32.i190, %add8.i212, !dbg !567
  %shr34.i192 = lshr i32 %xor33.i191, 5, !dbg !568
  %add35.i193 = add i32 %shr34.i192, %xor33.i191, !dbg !569
    #dbg_value(!DIArgList(i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !331)
  %shl36.i194 = shl i32 %add35.i193, 4, !dbg !570
    #dbg_value(!DIArgList(i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %add35.i193, i32 %shl36.i194, i32 %shl36.i194, i32 %shl36.i194, i32 %shl36.i194, i32 %shl36.i194, i32 %shl36.i194, i32 %shl36.i194, i32 %shl36.i194), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !331)
  %xor37.i195 = xor i32 %shl36.i194, %add35.i193, !dbg !571
    #dbg_value(!DIArgList(i32 %xor37.i195, i32 %xor37.i195, i32 %xor37.i195, i32 %xor37.i195, i32 %xor37.i195, i32 %xor37.i195, i32 %xor37.i195, i32 %xor37.i195), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !331)
  %shr38.i196 = lshr i32 %xor37.i195, 17, !dbg !572
    #dbg_value(!DIArgList(i32 %xor37.i195, i32 %xor37.i195, i32 %xor37.i195, i32 %xor37.i195, i32 %shr38.i196, i32 %shr38.i196, i32 %shr38.i196, i32 %shr38.i196), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !331)
  %add39.i197 = add i32 %shr38.i196, %xor37.i195, !dbg !573
    #dbg_value(!DIArgList(i32 %add39.i197, i32 %add39.i197, i32 %add39.i197, i32 %add39.i197), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !331)
  %shl40.i198 = shl i32 %add39.i197, 25, !dbg !574
    #dbg_value(!DIArgList(i32 %add39.i197, i32 %add39.i197, i32 %shl40.i198, i32 %shl40.i198), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !331)
  %xor41.i199 = xor i32 %shl40.i198, %add39.i197, !dbg !575
    #dbg_value(!DIArgList(i32 %xor41.i199, i32 %xor41.i199), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !331)
  %shr42.i200 = lshr i32 %xor41.i199, 6, !dbg !576
    #dbg_value(!DIArgList(i32 %xor41.i199, i32 %shr42.i200), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !331)
  %add43.i201 = add i32 %shr42.i200, %xor41.i199, !dbg !577
    #dbg_value(i32 %add43.i201, !308, !DIExpression(), !331)
    #dbg_value(i32 %add43.i201, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !314)
    #dbg_value(i32 %add43.i201, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !314)
  %tobool.not.i136 = icmp eq ptr %call.i132, null, !dbg !578
  br i1 %tobool.not.i136, label %cleanup.i140, label %land.lhs.true.i137, !dbg !580

land.lhs.true.i137:                               ; preds = %if.end.i131
  %42 = load i32, ptr %call.i132, align 4, !dbg !581, !tbaa !212
  %tobool28.not.i = icmp eq i32 %42, 0, !dbg !582
  br i1 %tobool28.not.i, label %cleanup.i140, label %if.then29.i, !dbg !583

if.then29.i:                                      ; preds = %land.lhs.true.i137
  %rem.i138 = urem i32 %add43.i201, %42, !dbg !584
  store i32 %rem.i138, ptr %cpu_dest.i127, align 4, !dbg !586, !tbaa !212, !DIAssignID !587
    #dbg_assign(i32 %rem.i138, !281, !DIExpression(), !587, ptr %cpu_dest.i127, !DIExpression(), !314)
  %call30.i = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_available, ptr noundef nonnull %cpu_dest.i127) #3, !dbg !588
    #dbg_value(ptr %call30.i, !283, !DIExpression(), !314)
  %tobool31.not.i = icmp eq ptr %call30.i, null, !dbg !589
  br i1 %tobool31.not.i, label %cleanup.i140, label %if.end33.i, !dbg !591

if.end33.i:                                       ; preds = %if.then29.i
  %43 = load i32, ptr %call30.i, align 4, !dbg !592, !tbaa !212
  store i32 %43, ptr %cpu_dest.i127, align 4, !dbg !593, !tbaa !212, !DIAssignID !594
    #dbg_assign(i32 %43, !281, !DIExpression(), !594, ptr %cpu_dest.i127, !DIExpression(), !314)
  %conv.i139 = zext i32 %43 to i64, !dbg !595
  %call34.i = call i64 inttoptr (i64 51 to ptr)(ptr noundef nonnull @cpu_map, i64 noundef %conv.i139, i64 noundef 0) #3, !dbg !596
  %conv35.i = trunc i64 %call34.i to i32, !dbg !597
  br label %cleanup.i140, !dbg !598

cleanup.i140:                                     ; preds = %if.end33.i, %if.then29.i, %land.lhs.true.i137, %if.end.i131
  %retval.0.i141 = phi i32 [ %conv35.i, %if.end33.i ], [ 0, %if.then29.i ], [ 2, %land.lhs.true.i137 ], [ 2, %if.end.i131 ], !dbg !599
  call void @llvm.lifetime.end.p0(ptr nonnull %cpu_dest.i127) #3, !dbg !600
  call void @llvm.lifetime.end.p0(ptr nonnull %key0.i126) #3, !dbg !600
  br label %cleanup52

if.end.i106:                                      ; preds = %if.end.i
    #dbg_value(ptr %add.ptr.i, !337, !DIExpression(), !344)
    #dbg_value(ptr %1, !338, !DIExpression(), !344)
    #dbg_value(ptr %add.ptr.i, !339, !DIExpression(), !344)
  call void @llvm.lifetime.start.p0(ptr nonnull %key0.i101) #3, !dbg !601
  store i32 0, ptr %key0.i101, align 4, !dbg !602, !tbaa !212, !DIAssignID !603
    #dbg_assign(i32 0, !334, !DIExpression(), !603, ptr %key0.i101, !DIExpression(), !344)
  call void @llvm.lifetime.start.p0(ptr nonnull %cpu_dest.i102) #3, !dbg !604
  %call.i107 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_count, ptr noundef nonnull %key0.i101) #3, !dbg !605
    #dbg_value(ptr %call.i107, !341, !DIExpression(), !344)
  %44 = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 12, !dbg !606
  %45 = load i32, ptr %44, align 4, !dbg !606, !tbaa !485
  %daddr.i108 = getelementptr inbounds nuw i8, ptr %add.ptr.i, i64 16, !dbg !607
  %46 = load i32, ptr %daddr.i108, align 4, !dbg !607, !tbaa !485
  %add.i109 = add i32 %46, %45, !dbg !608
    #dbg_value(i32 %add.i109, !343, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !344)
    #dbg_value(i32 %add.i109, !343, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !344)
    #dbg_value(i32 15485863, !307, !DIExpression(), !347)
    #dbg_value(i32 0, !310, !DIExpression(), !347)
    #dbg_value(i32 poison, !306, !DIExpression(), !347)
    #dbg_value(ptr undef, !298, !DIExpression(), !347)
    #dbg_value(i32 15485863, !308, !DIExpression(), !347)
  %conv.i232 = and i32 %add.i109, 65535, !dbg !609
  %add.i233 = add nuw nsw i32 %conv.i232, 15485863, !dbg !610
    #dbg_value(i32 %add.i233, !308, !DIExpression(), !347)
  %47 = lshr i32 %add.i109, 5, !dbg !611
  %shl.i236 = and i32 %47, 134215680, !dbg !611
    #dbg_value(!DIArgList(i32 %shl.i236, i32 %add.i233), !309, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_xor, DW_OP_stack_value), !347)
  %shl4.i237 = shl i32 %add.i233, 16, !dbg !612
  %48 = xor i32 %shl4.i237, %shl.i236, !dbg !613
  %xor5.i238 = xor i32 %48, %add.i233, !dbg !613
    #dbg_value(i32 %xor5.i238, !308, !DIExpression(), !347)
    #dbg_value(ptr undef, !298, !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value), !347)
  %shr7.i240 = lshr i32 %xor5.i238, 11, !dbg !614
  %add8.i241 = add i32 %shr7.i240, %xor5.i238, !dbg !615
    #dbg_value(!DIArgList(i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !347)
  %shl32.i219 = shl i32 %add8.i241, 3, !dbg !616
  %xor33.i220 = xor i32 %shl32.i219, %add8.i241, !dbg !617
  %shr34.i221 = lshr i32 %xor33.i220, 5, !dbg !618
  %add35.i222 = add i32 %shr34.i221, %xor33.i220, !dbg !619
    #dbg_value(!DIArgList(i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !347)
  %shl36.i223 = shl i32 %add35.i222, 4, !dbg !620
    #dbg_value(!DIArgList(i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %add35.i222, i32 %shl36.i223, i32 %shl36.i223, i32 %shl36.i223, i32 %shl36.i223, i32 %shl36.i223, i32 %shl36.i223, i32 %shl36.i223, i32 %shl36.i223), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !347)
  %xor37.i224 = xor i32 %shl36.i223, %add35.i222, !dbg !621
    #dbg_value(!DIArgList(i32 %xor37.i224, i32 %xor37.i224, i32 %xor37.i224, i32 %xor37.i224, i32 %xor37.i224, i32 %xor37.i224, i32 %xor37.i224, i32 %xor37.i224), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !347)
  %shr38.i225 = lshr i32 %xor37.i224, 17, !dbg !622
    #dbg_value(!DIArgList(i32 %xor37.i224, i32 %xor37.i224, i32 %xor37.i224, i32 %xor37.i224, i32 %shr38.i225, i32 %shr38.i225, i32 %shr38.i225, i32 %shr38.i225), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !347)
  %add39.i226 = add i32 %shr38.i225, %xor37.i224, !dbg !623
    #dbg_value(!DIArgList(i32 %add39.i226, i32 %add39.i226, i32 %add39.i226, i32 %add39.i226), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !347)
  %shl40.i227 = shl i32 %add39.i226, 25, !dbg !624
    #dbg_value(!DIArgList(i32 %add39.i226, i32 %add39.i226, i32 %shl40.i227, i32 %shl40.i227), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !347)
  %xor41.i228 = xor i32 %shl40.i227, %add39.i226, !dbg !625
    #dbg_value(!DIArgList(i32 %xor41.i228, i32 %xor41.i228), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !347)
  %shr42.i229 = lshr i32 %xor41.i228, 6, !dbg !626
    #dbg_value(!DIArgList(i32 %xor41.i228, i32 %shr42.i229), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !347)
  %add43.i230 = add i32 %shr42.i229, %xor41.i228, !dbg !627
    #dbg_value(i32 %add43.i230, !308, !DIExpression(), !347)
    #dbg_value(i32 %add43.i230, !343, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !344)
    #dbg_value(i32 %add43.i230, !343, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !344)
  %tobool.not.i111 = icmp eq ptr %call.i107, null, !dbg !628
  br i1 %tobool.not.i111, label %hash_ipv4.exit125, label %land.lhs.true.i112, !dbg !629

land.lhs.true.i112:                               ; preds = %if.end.i106
  %49 = load i32, ptr %call.i107, align 4, !dbg !630, !tbaa !212
  %tobool2.not.i113 = icmp eq i32 %49, 0, !dbg !631
  br i1 %tobool2.not.i113, label %hash_ipv4.exit125, label %if.then3.i114, !dbg !632

if.then3.i114:                                    ; preds = %land.lhs.true.i112
  %rem.i115 = urem i32 %add43.i230, %49, !dbg !633
  store i32 %rem.i115, ptr %cpu_dest.i102, align 4, !dbg !634, !tbaa !212, !DIAssignID !635
    #dbg_assign(i32 %rem.i115, !340, !DIExpression(), !635, ptr %cpu_dest.i102, !DIExpression(), !344)
  %call4.i116 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_available, ptr noundef nonnull %cpu_dest.i102) #3, !dbg !636
    #dbg_value(ptr %call4.i116, !342, !DIExpression(), !344)
  %tobool5.not.i117 = icmp eq ptr %call4.i116, null, !dbg !637
  br i1 %tobool5.not.i117, label %hash_ipv4.exit125, label %if.end7.i118, !dbg !638

if.end7.i118:                                     ; preds = %if.then3.i114
  %50 = load i32, ptr %call4.i116, align 4, !dbg !639, !tbaa !212
  store i32 %50, ptr %cpu_dest.i102, align 4, !dbg !640, !tbaa !212, !DIAssignID !641
    #dbg_assign(i32 %50, !340, !DIExpression(), !641, ptr %cpu_dest.i102, !DIExpression(), !344)
  %conv.i119 = zext i32 %50 to i64, !dbg !642
  %call8.i120 = call i64 inttoptr (i64 51 to ptr)(ptr noundef nonnull @cpu_map, i64 noundef %conv.i119, i64 noundef 0) #3, !dbg !643
  %conv9.i121 = trunc i64 %call8.i120 to i32, !dbg !644
  br label %hash_ipv4.exit125, !dbg !645

hash_ipv4.exit125:                                ; preds = %if.end.i106, %land.lhs.true.i112, %if.then3.i114, %if.end7.i118
  %retval.0.i123 = phi i32 [ %conv9.i121, %if.end7.i118 ], [ 0, %if.then3.i114 ], [ 2, %land.lhs.true.i112 ], [ 2, %if.end.i106 ], !dbg !646
  call void @llvm.lifetime.end.p0(ptr nonnull %cpu_dest.i102) #3, !dbg !647
  call void @llvm.lifetime.end.p0(ptr nonnull %key0.i101) #3, !dbg !647
  br label %cleanup52, !dbg !648

if.then48:                                        ; preds = %if.end40
    #dbg_value(ptr %ctx, !289, !DIExpression(), !649)
    #dbg_value(ptr %3, !290, !DIExpression(), !649)
    #dbg_value(i64 %nh_off.1, !291, !DIExpression(), !649)
    #dbg_value(ptr %1, !292, !DIExpression(), !649)
  %add.ptr.i88 = getelementptr inbounds nuw i8, ptr %3, i64 %nh_off.1, !dbg !650
    #dbg_value(ptr %add.ptr.i88, !293, !DIExpression(), !649)
    #dbg_value(ptr %add.ptr.i88, !238, !DIExpression(), !285)
    #dbg_value(ptr %1, !239, !DIExpression(), !285)
    #dbg_value(ptr %add.ptr.i88, !240, !DIExpression(), !285)
  %add.ptr.i146 = getelementptr inbounds nuw i8, ptr %add.ptr.i88, i64 40, !dbg !651
  %cmp.i147 = icmp ugt ptr %add.ptr.i146, %1, !dbg !652
  br i1 %cmp.i147, label %cleanup52, label %if.end.i148, !dbg !653

if.end.i148:                                      ; preds = %if.then48
  call void @llvm.lifetime.start.p0(ptr nonnull %key0.i143) #3, !dbg !654
  store i32 0, ptr %key0.i143, align 4, !dbg !655, !tbaa !212, !DIAssignID !656
    #dbg_assign(i32 0, !233, !DIExpression(), !656, ptr %key0.i143, !DIExpression(), !285)
  call void @llvm.lifetime.start.p0(ptr nonnull %cpu_dest.i144) #3, !dbg !657
  %call.i149 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_count, ptr noundef nonnull %key0.i143) #3, !dbg !658
    #dbg_value(ptr %call.i149, !282, !DIExpression(), !285)
  %51 = getelementptr inbounds nuw i8, ptr %add.ptr.i88, i64 8, !dbg !659
  %52 = load i32, ptr %51, align 4, !dbg !660, !tbaa !485
  %daddr.i150 = getelementptr inbounds nuw i8, ptr %add.ptr.i88, i64 24, !dbg !661
  %53 = load i32, ptr %daddr.i150, align 4, !dbg !662, !tbaa !485
  %add.i151 = add i32 %53, %52, !dbg !663
    #dbg_value(i32 %add.i151, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !285)
    #dbg_value(i32 %add.i151, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !285)
  %arrayidx5.i152 = getelementptr inbounds nuw i8, ptr %add.ptr.i88, i64 12, !dbg !664
  %54 = load i32, ptr %arrayidx5.i152, align 4, !dbg !664, !tbaa !485
  %arrayidx8.i153 = getelementptr inbounds nuw i8, ptr %add.ptr.i88, i64 28, !dbg !665
  %55 = load i32, ptr %arrayidx8.i153, align 4, !dbg !665, !tbaa !485
  %add9.i154 = add i32 %54, %add.i151, !dbg !666
  %add10.i155 = add i32 %add9.i154, %55, !dbg !667
    #dbg_value(i32 %add10.i155, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !285)
    #dbg_value(i32 %add10.i155, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !285)
  %arrayidx13.i156 = getelementptr inbounds nuw i8, ptr %add.ptr.i88, i64 16, !dbg !668
  %56 = load i32, ptr %arrayidx13.i156, align 4, !dbg !668, !tbaa !485
  %arrayidx16.i157 = getelementptr inbounds nuw i8, ptr %add.ptr.i88, i64 32, !dbg !669
  %57 = load i32, ptr %arrayidx16.i157, align 4, !dbg !669, !tbaa !485
  %add17.i158 = add i32 %add10.i155, %56, !dbg !670
  %add18.i159 = add i32 %add17.i158, %57, !dbg !671
    #dbg_value(i32 %add18.i159, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !285)
    #dbg_value(i32 %add18.i159, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !285)
  %arrayidx21.i160 = getelementptr inbounds nuw i8, ptr %add.ptr.i88, i64 20, !dbg !672
  %58 = load i32, ptr %arrayidx21.i160, align 4, !dbg !672, !tbaa !485
  %arrayidx24.i161 = getelementptr inbounds nuw i8, ptr %add.ptr.i88, i64 36, !dbg !673
  %59 = load i32, ptr %arrayidx24.i161, align 4, !dbg !673, !tbaa !485
  %add25.i162 = add i32 %add18.i159, %58, !dbg !674
  %add26.i163 = add i32 %add25.i162, %59, !dbg !675
    #dbg_value(i32 %add26.i163, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !285)
    #dbg_value(i32 %add26.i163, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !285)
    #dbg_value(i32 15485863, !307, !DIExpression(), !311)
    #dbg_value(i32 0, !310, !DIExpression(), !311)
    #dbg_value(i32 poison, !306, !DIExpression(), !311)
    #dbg_value(ptr undef, !298, !DIExpression(), !311)
    #dbg_value(i32 15485863, !308, !DIExpression(), !311)
  %conv.i182 = and i32 %add26.i163, 65535, !dbg !676
  %add.i183 = add nuw nsw i32 %conv.i182, 15485863, !dbg !677
    #dbg_value(i32 %add.i183, !308, !DIExpression(), !311)
  %60 = lshr i32 %add26.i163, 5, !dbg !678
  %shl.i = and i32 %60, 134215680, !dbg !678
    #dbg_value(!DIArgList(i32 %shl.i, i32 %add.i183), !309, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_xor, DW_OP_stack_value), !311)
  %shl4.i = shl i32 %add.i183, 16, !dbg !679
  %61 = xor i32 %shl4.i, %shl.i, !dbg !680
  %xor5.i = xor i32 %61, %add.i183, !dbg !680
    #dbg_value(i32 %xor5.i, !308, !DIExpression(), !311)
    #dbg_value(ptr undef, !298, !DIExpression(DW_OP_plus_uconst, 4, DW_OP_stack_value), !311)
  %shr7.i = lshr i32 %xor5.i, 11, !dbg !681
  %add8.i = add i32 %shr7.i, %xor5.i, !dbg !682
    #dbg_value(!DIArgList(i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !311)
  %shl32.i = shl i32 %add8.i, 3, !dbg !683
  %xor33.i = xor i32 %shl32.i, %add8.i, !dbg !684
  %shr34.i = lshr i32 %xor33.i, 5, !dbg !685
  %add35.i = add i32 %shr34.i, %xor33.i, !dbg !686
    #dbg_value(!DIArgList(i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_constu, 4, DW_OP_shl, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !311)
  %shl36.i = shl i32 %add35.i, 4, !dbg !687
    #dbg_value(!DIArgList(i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %add35.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i, i32 %shl36.i), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 8, DW_OP_xor, DW_OP_LLVM_arg, 4, DW_OP_LLVM_arg, 12, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 10, DW_OP_xor, DW_OP_LLVM_arg, 6, DW_OP_LLVM_arg, 14, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 9, DW_OP_xor, DW_OP_LLVM_arg, 5, DW_OP_LLVM_arg, 13, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 11, DW_OP_xor, DW_OP_LLVM_arg, 7, DW_OP_LLVM_arg, 15, DW_OP_xor, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !311)
  %xor37.i = xor i32 %shl36.i, %add35.i, !dbg !688
    #dbg_value(!DIArgList(i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_constu, 17, DW_OP_shr, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !311)
  %shr38.i = lshr i32 %xor37.i, 17, !dbg !689
    #dbg_value(!DIArgList(i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %xor37.i, i32 %shr38.i, i32 %shr38.i, i32 %shr38.i, i32 %shr38.i), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 4, DW_OP_plus, DW_OP_LLVM_arg, 2, DW_OP_LLVM_arg, 6, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 5, DW_OP_plus, DW_OP_LLVM_arg, 3, DW_OP_LLVM_arg, 7, DW_OP_plus, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !311)
  %add39.i = add i32 %shr38.i, %xor37.i, !dbg !690
    #dbg_value(!DIArgList(i32 %add39.i, i32 %add39.i, i32 %add39.i, i32 %add39.i), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_constu, 25, DW_OP_shl, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !311)
  %shl40.i = shl i32 %add39.i, 25, !dbg !691
    #dbg_value(!DIArgList(i32 %add39.i, i32 %add39.i, i32 %shl40.i, i32 %shl40.i), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 2, DW_OP_xor, DW_OP_LLVM_arg, 1, DW_OP_LLVM_arg, 3, DW_OP_xor, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !311)
  %xor41.i = xor i32 %shl40.i, %add39.i, !dbg !692
    #dbg_value(!DIArgList(i32 %xor41.i, i32 %xor41.i), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_constu, 6, DW_OP_shr, DW_OP_plus, DW_OP_stack_value), !311)
  %shr42.i = lshr i32 %xor41.i, 6, !dbg !693
    #dbg_value(!DIArgList(i32 %xor41.i, i32 %shr42.i), !308, !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_plus, DW_OP_stack_value), !311)
  %add43.i = add i32 %shr42.i, %xor41.i, !dbg !694
    #dbg_value(i32 %add43.i, !308, !DIExpression(), !311)
    #dbg_value(i32 %add43.i, !284, !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 16), !285)
    #dbg_value(i32 %add43.i, !284, !DIExpression(DW_OP_constu, 16, DW_OP_shr, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 16, DW_ATE_unsigned, DW_OP_stack_value, DW_OP_LLVM_fragment, 16, 16), !285)
  %tobool.not.i165 = icmp eq ptr %call.i149, null, !dbg !695
  br i1 %tobool.not.i165, label %cleanup.i176, label %land.lhs.true.i166, !dbg !696

land.lhs.true.i166:                               ; preds = %if.end.i148
  %62 = load i32, ptr %call.i149, align 4, !dbg !697, !tbaa !212
  %tobool28.not.i167 = icmp eq i32 %62, 0, !dbg !698
  br i1 %tobool28.not.i167, label %cleanup.i176, label %if.then29.i168, !dbg !699

if.then29.i168:                                   ; preds = %land.lhs.true.i166
  %rem.i169 = urem i32 %add43.i, %62, !dbg !700
  store i32 %rem.i169, ptr %cpu_dest.i144, align 4, !dbg !701, !tbaa !212, !DIAssignID !702
    #dbg_assign(i32 %rem.i169, !281, !DIExpression(), !702, ptr %cpu_dest.i144, !DIExpression(), !285)
  %call30.i170 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @cpus_available, ptr noundef nonnull %cpu_dest.i144) #3, !dbg !703
    #dbg_value(ptr %call30.i170, !283, !DIExpression(), !285)
  %tobool31.not.i171 = icmp eq ptr %call30.i170, null, !dbg !704
  br i1 %tobool31.not.i171, label %cleanup.i176, label %if.end33.i172, !dbg !705

if.end33.i172:                                    ; preds = %if.then29.i168
  %63 = load i32, ptr %call30.i170, align 4, !dbg !706, !tbaa !212
  store i32 %63, ptr %cpu_dest.i144, align 4, !dbg !707, !tbaa !212, !DIAssignID !708
    #dbg_assign(i32 %63, !281, !DIExpression(), !708, ptr %cpu_dest.i144, !DIExpression(), !285)
  %conv.i173 = zext i32 %63 to i64, !dbg !709
  %call34.i174 = call i64 inttoptr (i64 51 to ptr)(ptr noundef nonnull @cpu_map, i64 noundef %conv.i173, i64 noundef 0) #3, !dbg !710
  %conv35.i175 = trunc i64 %call34.i174 to i32, !dbg !711
  br label %cleanup.i176, !dbg !712

cleanup.i176:                                     ; preds = %if.end33.i172, %if.then29.i168, %land.lhs.true.i166, %if.end.i148
  %retval.0.i177 = phi i32 [ %conv35.i175, %if.end33.i172 ], [ 0, %if.then29.i168 ], [ 2, %land.lhs.true.i166 ], [ 2, %if.end.i148 ], !dbg !713
  call void @llvm.lifetime.end.p0(ptr nonnull %cpu_dest.i144) #3, !dbg !714
  call void @llvm.lifetime.end.p0(ptr nonnull %key0.i143) #3, !dbg !714
  br label %cleanup52

cleanup52:                                        ; preds = %cleanup.i176, %if.then48, %hash_ipv4.exit125, %if.then44, %cleanup.i140, %if.then79.i, %cleanup.i, %if.then73.i, %if.then4.i, %if.end.i93, %if.end4.i, %if.end38.i, %if.end43.i, %if.then56.i, %if.end64.i, %if.end69.i, %if.then27, %if.then12, %if.end40, %entry
  %retval.3 = phi i32 [ 2, %entry ], [ 2, %if.end40 ], [ 2, %if.then12 ], [ 2, %if.then27 ], [ %retval.0.i123, %hash_ipv4.exit125 ], [ 2, %if.then44 ], [ 2, %if.then4.i ], [ 2, %if.end.i93 ], [ 2, %if.end4.i ], [ 2, %if.end38.i ], [ 2, %if.end43.i ], [ 2, %if.end64.i ], [ 2, %if.end69.i ], [ 2, %if.then56.i ], [ %retval.0.i100, %cleanup.i ], [ 2, %if.then73.i ], [ %retval.0.i141, %cleanup.i140 ], [ 2, %if.then79.i ], [ %retval.0.i177, %cleanup.i176 ], [ 2, %if.then48 ], !dbg !356
  ret i32 %retval.3, !dbg !715
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #1

; Function Attrs: nounwind memory(none)
declare i1 @llvm.bpf.passthrough.i1.i1(i32, i1) #2

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind memory(none) }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!206, !207, !208, !209, !210}
!llvm.ident = !{!211}
!llvm.errno.tbaa = !{!212}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "__license", scope: !2, file: !3, line: 270, type: !203, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 22.0.0git (https://github.com/zachary-kent/llvm-project/ 17a443e799e99026e9430fea2d6fc19b39cb5b8b)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !48, globals: !138, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_lb.c", directory: "/home/otso/suricata/ebpf", checksumkind: CSK_MD5, checksum: "1112918e8052ba7e4522e4b2899347b0")
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
!48 = !{!49, !50, !51, !53, !56, !125, !133, !135, !137}
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!50 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !52, line: 32, baseType: !53)
!52 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "c0ade1a1a309d6896ce6080a51a2d105")
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !54, line: 24, baseType: !55)
!54 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!55 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "gre_hdr", scope: !58, file: !3, line: 139, size: 32, elements: !130)
!58 = distinct !DISubprogram(name: "filter_gre", scope: !3, file: !3, line: 135, type: !59, scopeLine: 136, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !73, keyInstructions: true)
!59 = !DISubroutineType(types: !60)
!60 = !{!61, !62, !49, !71, !49}
!61 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2620, size: 160, elements: !64)
!64 = !{!65, !67, !68, !69, !70}
!65 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !63, file: !6, line: 2621, baseType: !66, size: 32)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !54, line: 27, baseType: !7)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !63, file: !6, line: 2622, baseType: !66, size: 32, offset: 32)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !63, file: !6, line: 2623, baseType: !66, size: 32, offset: 64)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !63, file: !6, line: 2625, baseType: !66, size: 32, offset: 96)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !63, file: !6, line: 2626, baseType: !66, size: 32, offset: 128)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !54, line: 31, baseType: !72)
!72 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!73 = !{!74, !75, !76, !77, !78, !109, !110, !111, !122}
!74 = !DILocalVariable(name: "ctx", arg: 1, scope: !58, file: !3, line: 135, type: !62)
!75 = !DILocalVariable(name: "data", arg: 2, scope: !58, file: !3, line: 135, type: !49)
!76 = !DILocalVariable(name: "nh_off", arg: 3, scope: !58, file: !3, line: 135, type: !71)
!77 = !DILocalVariable(name: "data_end", arg: 4, scope: !58, file: !3, line: 135, type: !49)
!78 = !DILocalVariable(name: "iph", scope: !58, file: !3, line: 137, type: !79)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !81, line: 87, size: 160, elements: !82)
!81 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "5c58d077e910b6c258855dca54d0ec22")
!82 = !{!83, !86, !87, !88, !89, !90, !91, !92, !93, !95}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !80, file: !81, line: 89, baseType: !84, size: 4, flags: DIFlagBitField, extraData: i64 0)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !54, line: 21, baseType: !85)
!85 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !80, file: !81, line: 90, baseType: !84, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !80, file: !81, line: 97, baseType: !84, size: 8, offset: 8)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !80, file: !81, line: 98, baseType: !51, size: 16, offset: 16)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !80, file: !81, line: 99, baseType: !51, size: 16, offset: 32)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !80, file: !81, line: 100, baseType: !51, size: 16, offset: 48)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !80, file: !81, line: 101, baseType: !84, size: 8, offset: 64)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !80, file: !81, line: 102, baseType: !84, size: 8, offset: 72)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !80, file: !81, line: 103, baseType: !94, size: 16, offset: 80)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !52, line: 38, baseType: !53)
!95 = !DIDerivedType(tag: DW_TAG_member, scope: !80, file: !81, line: 104, baseType: !96, size: 64, offset: 96)
!96 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !80, file: !81, line: 104, size: 64, elements: !97)
!97 = !{!98, !104}
!98 = !DIDerivedType(tag: DW_TAG_member, scope: !96, file: !81, line: 104, baseType: !99, size: 64)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !96, file: !81, line: 104, size: 64, elements: !100)
!100 = !{!101, !103}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !99, file: !81, line: 105, baseType: !102, size: 32)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !52, line: 34, baseType: !66)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !99, file: !81, line: 106, baseType: !102, size: 32, offset: 32)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !96, file: !81, line: 104, baseType: !105, size: 64)
!105 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !96, file: !81, line: 104, size: 64, elements: !106)
!106 = !{!107, !108}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !105, file: !81, line: 105, baseType: !102, size: 32)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !105, file: !81, line: 106, baseType: !102, size: 32, offset: 32)
!109 = !DILocalVariable(name: "proto", scope: !58, file: !3, line: 138, type: !53)
!110 = !DILocalVariable(name: "grhdr", scope: !58, file: !3, line: 145, type: !56)
!111 = !DILocalVariable(name: "eth", scope: !58, file: !3, line: 176, type: !112)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !114, line: 173, size: 112, elements: !115)
!114 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!115 = !{!116, !120, !121}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !113, file: !114, line: 174, baseType: !117, size: 48)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !85, size: 48, elements: !118)
!118 = !{!119}
!119 = !DISubrange(count: 6)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !113, file: !114, line: 175, baseType: !117, size: 48, offset: 48)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !113, file: !114, line: 176, baseType: !51, size: 16, offset: 96)
!122 = !DILocalVariable(name: "vhdr", scope: !123, file: !3, line: 187, type: !125)
!123 = distinct !DILexicalBlock(scope: !124, file: !3, line: 186, column: 49)
!124 = distinct !DILexicalBlock(scope: !58, file: !3, line: 186, column: 9)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !3, line: 47, size: 32, elements: !127)
!127 = !{!128, !129}
!128 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !126, file: !3, line: 48, baseType: !53, size: 16)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !126, file: !3, line: 49, baseType: !53, size: 16, offset: 16)
!130 = !{!131, !132}
!131 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !57, file: !3, line: 140, baseType: !51, size: 16)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "proto", scope: !57, file: !3, line: 141, baseType: !51, size: 16, offset: 16)
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !134, size: 64)
!134 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !53)
!137 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!138 = !{!0, !139, !141, !158, !170, !182, !189, !197}
!139 = !DIGlobalVariableExpression(var: !140, expr: !DIExpression())
!140 = distinct !DIGlobalVariable(name: "__version", scope: !2, file: !3, line: 272, type: !66, isLocal: false, isDefinition: true)
!141 = !DIGlobalVariableExpression(var: !142, expr: !DIExpression())
!142 = distinct !DIGlobalVariable(name: "cpu_map", scope: !2, file: !3, line: 58, type: !143, isLocal: false, isDefinition: true)
!143 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 53, size: 256, elements: !144)
!144 = !{!145, !150, !152, !153}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !143, file: !3, line: 54, baseType: !146, size: 64)
!146 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64)
!147 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 512, elements: !148)
!148 = !{!149}
!149 = !DISubrange(count: 16)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !143, file: !3, line: 55, baseType: !151, size: 64, offset: 64)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !143, file: !3, line: 56, baseType: !151, size: 64, offset: 128)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !143, file: !3, line: 57, baseType: !154, size: 64, offset: 192)
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!155 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 4096, elements: !156)
!156 = !{!157}
!157 = !DISubrange(count: 128)
!158 = !DIGlobalVariableExpression(var: !159, expr: !DIExpression())
!159 = distinct !DIGlobalVariable(name: "cpus_available", scope: !2, file: !3, line: 65, type: !160, isLocal: false, isDefinition: true)
!160 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 60, size: 256, elements: !161)
!161 = !{!162, !167, !168, !169}
!162 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !160, file: !3, line: 61, baseType: !163, size: 64)
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!164 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 64, elements: !165)
!165 = !{!166}
!166 = !DISubrange(count: 2)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !160, file: !3, line: 62, baseType: !151, size: 64, offset: 64)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !160, file: !3, line: 63, baseType: !151, size: 64, offset: 128)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !160, file: !3, line: 64, baseType: !154, size: 64, offset: 192)
!170 = !DIGlobalVariableExpression(var: !171, expr: !DIExpression())
!171 = distinct !DIGlobalVariable(name: "cpus_count", scope: !2, file: !3, line: 72, type: !172, isLocal: false, isDefinition: true)
!172 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 67, size: 256, elements: !173)
!173 = !{!174, !175, !176, !177}
!174 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !172, file: !3, line: 68, baseType: !163, size: 64)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !172, file: !3, line: 69, baseType: !151, size: 64, offset: 64)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !172, file: !3, line: 70, baseType: !151, size: 64, offset: 128)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !172, file: !3, line: 71, baseType: !178, size: 64, offset: 192)
!178 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !179, size: 64)
!179 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 32, elements: !180)
!180 = !{!181}
!181 = !DISubrange(count: 1)
!182 = !DIGlobalVariableExpression(var: !183, expr: !DIExpression())
!183 = distinct !DIGlobalVariable(name: "bpf_xdp_adjust_head", scope: !2, file: !184, line: 1149, type: !185, isLocal: true, isDefinition: true)
!184 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "11f09623d7230081247afacdc7c1a641")
!185 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !186)
!186 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !187, size: 64)
!187 = !DISubroutineType(types: !188)
!188 = !{!50, !62, !61}
!189 = !DIGlobalVariableExpression(var: !190, expr: !DIExpression())
!190 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !184, line: 64, type: !191, isLocal: true, isDefinition: true)
!191 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !192)
!192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !193, size: 64)
!193 = !DISubroutineType(types: !194)
!194 = !{!49, !49, !195}
!195 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !196, size: 64)
!196 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!197 = !DIGlobalVariableExpression(var: !198, expr: !DIExpression())
!198 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !184, line: 1338, type: !199, isLocal: true, isDefinition: true)
!199 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !200)
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !201, size: 64)
!201 = !DISubroutineType(types: !202)
!202 = !{!50, !49, !71, !71}
!203 = !DICompositeType(tag: DW_TAG_array_type, baseType: !134, size: 32, elements: !204)
!204 = !{!205}
!205 = !DISubrange(count: 4)
!206 = !{i32 7, !"Dwarf Version", i32 5}
!207 = !{i32 2, !"Debug Info Version", i32 3}
!208 = !{i32 1, !"wchar_size", i32 4}
!209 = !{i32 7, !"frame-pointer", i32 2}
!210 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!211 = !{!"clang version 22.0.0git (https://github.com/zachary-kent/llvm-project/ 17a443e799e99026e9430fea2d6fc19b39cb5b8b)"}
!212 = !{!213, !213, i64 0}
!213 = !{!"int", !214, i64 0}
!214 = !{!"omnipotent char", !215, i64 0}
!215 = !{!"Simple C/C++ TBAA"}
!216 = distinct !DISubprogram(name: "xdp_loadfilter", scope: !3, file: !3, line: 223, type: !217, scopeLine: 224, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !219, keyInstructions: true)
!217 = !DISubroutineType(types: !218)
!218 = !{!61, !62}
!219 = !{!220, !221, !222, !223, !224, !225, !226, !229}
!220 = !DILocalVariable(name: "ctx", arg: 1, scope: !216, file: !3, line: 223, type: !62)
!221 = !DILocalVariable(name: "data_end", scope: !216, file: !3, line: 225, type: !49)
!222 = !DILocalVariable(name: "data", scope: !216, file: !3, line: 226, type: !49)
!223 = !DILocalVariable(name: "eth", scope: !216, file: !3, line: 227, type: !112)
!224 = !DILocalVariable(name: "h_proto", scope: !216, file: !3, line: 228, type: !53)
!225 = !DILocalVariable(name: "nh_off", scope: !216, file: !3, line: 229, type: !71)
!226 = !DILocalVariable(name: "vhdr", scope: !227, file: !3, line: 244, type: !125)
!227 = distinct !DILexicalBlock(scope: !228, file: !3, line: 243, column: 96)
!228 = distinct !DILexicalBlock(scope: !216, file: !3, line: 243, column: 9)
!229 = !DILocalVariable(name: "vhdr", scope: !230, file: !3, line: 253, type: !125)
!230 = distinct !DILexicalBlock(scope: !231, file: !3, line: 252, column: 96)
!231 = distinct !DILexicalBlock(scope: !216, file: !3, line: 252, column: 9)
!232 = distinct !DIAssignID()
!233 = !DILocalVariable(name: "key0", scope: !234, file: !3, line: 108, type: !66)
!234 = distinct !DISubprogram(name: "hash_ipv6", scope: !3, file: !3, line: 102, type: !235, scopeLine: 103, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !237, keyInstructions: true)
!235 = !DISubroutineType(types: !236)
!236 = !{!61, !49, !49}
!237 = !{!238, !239, !240, !233, !281, !282, !283, !284}
!238 = !DILocalVariable(name: "data", arg: 1, scope: !234, file: !3, line: 102, type: !49)
!239 = !DILocalVariable(name: "data_end", arg: 2, scope: !234, file: !3, line: 102, type: !49)
!240 = !DILocalVariable(name: "ip6h", scope: !234, file: !3, line: 104, type: !241)
!241 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !242, size: 64)
!242 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !243, line: 118, size: 320, elements: !244)
!243 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "", checksumkind: CSK_MD5, checksum: "2ee489601bcc9c44d828d039ff7786a6")
!244 = !{!245, !246, !247, !251, !252, !253, !254}
!245 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !242, file: !243, line: 120, baseType: !84, size: 4, flags: DIFlagBitField, extraData: i64 0)
!246 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !242, file: !243, line: 121, baseType: !84, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!247 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !242, file: !243, line: 128, baseType: !248, size: 24, offset: 8)
!248 = !DICompositeType(tag: DW_TAG_array_type, baseType: !84, size: 24, elements: !249)
!249 = !{!250}
!250 = !DISubrange(count: 3)
!251 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !242, file: !243, line: 130, baseType: !51, size: 16, offset: 32)
!252 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !242, file: !243, line: 131, baseType: !84, size: 8, offset: 48)
!253 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !242, file: !243, line: 132, baseType: !84, size: 8, offset: 56)
!254 = !DIDerivedType(tag: DW_TAG_member, scope: !242, file: !243, line: 134, baseType: !255, size: 256, offset: 64)
!255 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !242, file: !243, line: 134, size: 256, elements: !256)
!256 = !{!257, !276}
!257 = !DIDerivedType(tag: DW_TAG_member, scope: !255, file: !243, line: 134, baseType: !258, size: 256)
!258 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !255, file: !243, line: 134, size: 256, elements: !259)
!259 = !{!260, !275}
!260 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !258, file: !243, line: 135, baseType: !261, size: 128)
!261 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !262, line: 33, size: 128, elements: !263)
!262 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "", checksumkind: CSK_MD5, checksum: "6eb9610917d19b67762834b3cd333671")
!263 = !{!264}
!264 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !261, file: !262, line: 40, baseType: !265, size: 128)
!265 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !261, file: !262, line: 34, size: 128, elements: !266)
!266 = !{!267, !269, !273}
!267 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !265, file: !262, line: 35, baseType: !268, size: 128)
!268 = !DICompositeType(tag: DW_TAG_array_type, baseType: !84, size: 128, elements: !148)
!269 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !265, file: !262, line: 37, baseType: !270, size: 128)
!270 = !DICompositeType(tag: DW_TAG_array_type, baseType: !51, size: 128, elements: !271)
!271 = !{!272}
!272 = !DISubrange(count: 8)
!273 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !265, file: !262, line: 38, baseType: !274, size: 128)
!274 = !DICompositeType(tag: DW_TAG_array_type, baseType: !102, size: 128, elements: !204)
!275 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !258, file: !243, line: 136, baseType: !261, size: 128, offset: 128)
!276 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !255, file: !243, line: 134, baseType: !277, size: 256)
!277 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !255, file: !243, line: 134, size: 256, elements: !278)
!278 = !{!279, !280}
!279 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !277, file: !243, line: 135, baseType: !261, size: 128)
!280 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !277, file: !243, line: 136, baseType: !261, size: 128, offset: 128)
!281 = !DILocalVariable(name: "cpu_dest", scope: !234, file: !3, line: 109, type: !66)
!282 = !DILocalVariable(name: "cpu_max", scope: !234, file: !3, line: 110, type: !151)
!283 = !DILocalVariable(name: "cpu_selected", scope: !234, file: !3, line: 111, type: !151)
!284 = !DILocalVariable(name: "cpu_hash", scope: !234, file: !3, line: 112, type: !66)
!285 = !DILocation(line: 0, scope: !234, inlinedAt: !286)
!286 = distinct !DILocation(line: 220, column: 12, scope: !287, inlinedAt: !294)
!287 = distinct !DISubprogram(name: "filter_ipv6", scope: !3, file: !3, line: 217, type: !59, scopeLine: 218, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !288, keyInstructions: true)
!288 = !{!289, !290, !291, !292, !293}
!289 = !DILocalVariable(name: "ctx", arg: 1, scope: !287, file: !3, line: 217, type: !62)
!290 = !DILocalVariable(name: "data", arg: 2, scope: !287, file: !3, line: 217, type: !49)
!291 = !DILocalVariable(name: "nh_off", arg: 3, scope: !287, file: !3, line: 217, type: !71)
!292 = !DILocalVariable(name: "data_end", arg: 4, scope: !287, file: !3, line: 217, type: !49)
!293 = !DILocalVariable(name: "ip6h", scope: !287, file: !3, line: 219, type: !241)
!294 = distinct !DILocation(line: 265, column: 16, scope: !295)
!295 = distinct !DILexicalBlock(scope: !296, file: !3, line: 264, column: 14)
!296 = distinct !DILexicalBlock(scope: !216, file: !3, line: 262, column: 9)
!297 = distinct !DIAssignID()
!298 = !DILocalVariable(name: "data", arg: 1, scope: !299, file: !300, line: 10, type: !303)
!299 = distinct !DISubprogram(name: "SuperFastHash", scope: !300, file: !300, line: 10, type: !301, scopeLine: 10, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !305, keyInstructions: true)
!300 = !DIFile(filename: "./hash_func01.h", directory: "/home/otso/suricata/ebpf", checksumkind: CSK_MD5, checksum: "ce1b4b031f544a3f2c7bb1ea990aba20")
!301 = !DISubroutineType(types: !302)
!302 = !{!66, !303, !61, !66}
!303 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !304, size: 64)
!304 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !134)
!305 = !{!298, !306, !307, !308, !309, !310}
!306 = !DILocalVariable(name: "len", arg: 2, scope: !299, file: !300, line: 10, type: !61)
!307 = !DILocalVariable(name: "initval", arg: 3, scope: !299, file: !300, line: 10, type: !66)
!308 = !DILocalVariable(name: "hash", scope: !299, file: !300, line: 11, type: !66)
!309 = !DILocalVariable(name: "tmp", scope: !299, file: !300, line: 12, type: !66)
!310 = !DILocalVariable(name: "rem", scope: !299, file: !300, line: 13, type: !61)
!311 = !DILocation(line: 0, scope: !299, inlinedAt: !312)
!312 = distinct !DILocation(line: 119, column: 16, scope: !234, inlinedAt: !286)
!313 = distinct !DIAssignID()
!314 = !DILocation(line: 0, scope: !234, inlinedAt: !315)
!315 = distinct !DILocation(line: 200, column: 16, scope: !316, inlinedAt: !319)
!316 = distinct !DILexicalBlock(scope: !317, file: !3, line: 199, column: 55)
!317 = distinct !DILexicalBlock(scope: !318, file: !3, line: 199, column: 16)
!318 = distinct !DILexicalBlock(scope: !58, file: !3, line: 197, column: 9)
!319 = distinct !DILocation(line: 212, column: 16, scope: !320, inlinedAt: !329)
!320 = distinct !DILexicalBlock(scope: !321, file: !3, line: 211, column: 39)
!321 = distinct !DILexicalBlock(scope: !322, file: !3, line: 211, column: 9)
!322 = distinct !DISubprogram(name: "filter_ipv4", scope: !3, file: !3, line: 205, type: !59, scopeLine: 206, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !323, keyInstructions: true)
!323 = !{!324, !325, !326, !327, !328}
!324 = !DILocalVariable(name: "ctx", arg: 1, scope: !322, file: !3, line: 205, type: !62)
!325 = !DILocalVariable(name: "data", arg: 2, scope: !322, file: !3, line: 205, type: !49)
!326 = !DILocalVariable(name: "nh_off", arg: 3, scope: !322, file: !3, line: 205, type: !71)
!327 = !DILocalVariable(name: "data_end", arg: 4, scope: !322, file: !3, line: 205, type: !49)
!328 = !DILocalVariable(name: "iph", scope: !322, file: !3, line: 207, type: !79)
!329 = distinct !DILocation(line: 263, column: 16, scope: !296)
!330 = distinct !DIAssignID()
!331 = !DILocation(line: 0, scope: !299, inlinedAt: !332)
!332 = distinct !DILocation(line: 119, column: 16, scope: !234, inlinedAt: !315)
!333 = distinct !DIAssignID()
!334 = !DILocalVariable(name: "key0", scope: !335, file: !3, line: 80, type: !66)
!335 = distinct !DISubprogram(name: "hash_ipv4", scope: !3, file: !3, line: 74, type: !235, scopeLine: 75, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !336, keyInstructions: true)
!336 = !{!337, !338, !339, !334, !340, !341, !342, !343}
!337 = !DILocalVariable(name: "data", arg: 1, scope: !335, file: !3, line: 74, type: !49)
!338 = !DILocalVariable(name: "data_end", arg: 2, scope: !335, file: !3, line: 74, type: !49)
!339 = !DILocalVariable(name: "iph", scope: !335, file: !3, line: 76, type: !79)
!340 = !DILocalVariable(name: "cpu_dest", scope: !335, file: !3, line: 81, type: !66)
!341 = !DILocalVariable(name: "cpu_max", scope: !335, file: !3, line: 82, type: !151)
!342 = !DILocalVariable(name: "cpu_selected", scope: !335, file: !3, line: 83, type: !151)
!343 = !DILocalVariable(name: "cpu_hash", scope: !335, file: !3, line: 84, type: !66)
!344 = !DILocation(line: 0, scope: !335, inlinedAt: !345)
!345 = distinct !DILocation(line: 214, column: 12, scope: !322, inlinedAt: !329)
!346 = distinct !DIAssignID()
!347 = !DILocation(line: 0, scope: !299, inlinedAt: !348)
!348 = distinct !DILocation(line: 88, column: 16, scope: !335, inlinedAt: !345)
!349 = distinct !DIAssignID()
!350 = !DILocation(line: 0, scope: !335, inlinedAt: !351)
!351 = distinct !DILocation(line: 198, column: 16, scope: !352, inlinedAt: !319)
!352 = distinct !DILexicalBlock(scope: !318, file: !3, line: 197, column: 46)
!353 = distinct !DIAssignID()
!354 = !DILocation(line: 0, scope: !299, inlinedAt: !355)
!355 = distinct !DILocation(line: 88, column: 16, scope: !335, inlinedAt: !351)
!356 = !DILocation(line: 0, scope: !216)
!357 = !DILocation(line: 225, column: 41, scope: !216)
!358 = !DILocation(line: 225, column: 41, scope: !216, atomGroup: 1, atomRank: 4)
!359 = !{!360, !213, i64 4}
!360 = !{!"xdp_md", !213, i64 0, !213, i64 4, !213, i64 8, !213, i64 12, !213, i64 16}
!361 = !DILocation(line: 225, column: 30, scope: !216, atomGroup: 1, atomRank: 3)
!362 = !DILocation(line: 225, column: 22, scope: !216, atomGroup: 1, atomRank: 2)
!363 = !DILocation(line: 226, column: 37, scope: !216, atomGroup: 2, atomRank: 4)
!364 = !{!360, !213, i64 0}
!365 = !DILocation(line: 226, column: 26, scope: !216, atomGroup: 2, atomRank: 3)
!366 = !DILocation(line: 226, column: 18, scope: !216, atomGroup: 2, atomRank: 2)
!367 = !DILocation(line: 232, column: 14, scope: !368)
!368 = distinct !DILexicalBlock(scope: !216, file: !3, line: 232, column: 9)
!369 = !DILocation(line: 232, column: 23, scope: !368, atomGroup: 5, atomRank: 2)
!370 = !DILocation(line: 232, column: 23, scope: !368, atomGroup: 5, atomRank: 1)
!371 = !DILocation(line: 235, column: 20, scope: !216)
!372 = !DILocation(line: 235, column: 20, scope: !216, atomGroup: 7, atomRank: 2)
!373 = !{!374, !375, i64 12}
!374 = !{!"ethhdr", !214, i64 0, !214, i64 6, !375, i64 12}
!375 = !{!"short", !214, i64 0}
!376 = !DILocation(line: 243, column: 17, scope: !228, atomGroup: 8, atomRank: 2)
!377 = !DILocation(line: 243, column: 50, scope: !228, atomGroup: 8, atomRank: 1)
!378 = !DILocation(line: 0, scope: !227)
!379 = !DILocation(line: 248, column: 18, scope: !380)
!380 = distinct !DILexicalBlock(scope: !227, file: !3, line: 248, column: 13)
!381 = !DILocation(line: 248, column: 27, scope: !380, atomGroup: 12, atomRank: 2)
!382 = !DILocation(line: 248, column: 27, scope: !380, atomGroup: 12, atomRank: 1)
!383 = !DILocation(line: 250, column: 25, scope: !227)
!384 = !DILocation(line: 250, column: 25, scope: !227, atomGroup: 14, atomRank: 2)
!385 = !{!386, !375, i64 2}
!386 = !{!"vlan_hdr", !375, i64 0, !375, i64 2}
!387 = !DILocation(line: 235, column: 13, scope: !216, atomGroup: 7, atomRank: 1)
!388 = !DILocation(line: 252, column: 17, scope: !231, atomGroup: 15, atomRank: 2)
!389 = !DILocation(line: 252, column: 50, scope: !231, atomGroup: 15, atomRank: 1)
!390 = !DILocation(line: 0, scope: !230)
!391 = !DILocation(line: 256, column: 16, scope: !230, atomGroup: 18, atomRank: 2)
!392 = !DILocation(line: 257, column: 18, scope: !393)
!393 = distinct !DILexicalBlock(scope: !230, file: !3, line: 257, column: 13)
!394 = !DILocation(line: 257, column: 27, scope: !393, atomGroup: 19, atomRank: 2)
!395 = !DILocation(line: 257, column: 27, scope: !393, atomGroup: 19, atomRank: 1)
!396 = !DILocation(line: 255, column: 21, scope: !230, atomGroup: 17, atomRank: 2)
!397 = !DILocation(line: 259, column: 25, scope: !230)
!398 = !DILocation(line: 259, column: 25, scope: !230, atomGroup: 21, atomRank: 2)
!399 = !DILocation(line: 262, column: 17, scope: !296, atomGroup: 22, atomRank: 1)
!400 = !DILocation(line: 0, scope: !322, inlinedAt: !329)
!401 = !DILocation(line: 207, column: 30, scope: !322, inlinedAt: !329, atomGroup: 1, atomRank: 2)
!402 = !DILocation(line: 208, column: 22, scope: !403, inlinedAt: !329)
!403 = distinct !DILexicalBlock(scope: !322, file: !3, line: 208, column: 9)
!404 = !DILocation(line: 208, column: 27, scope: !403, inlinedAt: !329, atomGroup: 2, atomRank: 2)
!405 = !DILocation(line: 208, column: 27, scope: !403, inlinedAt: !329, atomGroup: 2, atomRank: 1)
!406 = !DILocation(line: 211, column: 14, scope: !321, inlinedAt: !329)
!407 = !{!408, !214, i64 9}
!408 = !{!"iphdr", !214, i64 0, !214, i64 0, !214, i64 1, !375, i64 2, !375, i64 4, !375, i64 6, !214, i64 8, !214, i64 9, !375, i64 10, !214, i64 12}
!409 = !DILocation(line: 211, column: 23, scope: !321, inlinedAt: !329, atomGroup: 4, atomRank: 2)
!410 = !DILocation(line: 211, column: 23, scope: !321, inlinedAt: !329, atomGroup: 4, atomRank: 1)
!411 = !DILocation(line: 0, scope: !58, inlinedAt: !319)
!412 = !DILocation(line: 147, column: 24, scope: !413, inlinedAt: !319)
!413 = distinct !DILexicalBlock(scope: !58, file: !3, line: 147, column: 9)
!414 = !DILocation(line: 147, column: 29, scope: !413, inlinedAt: !319, atomGroup: 4, atomRank: 2)
!415 = !DILocation(line: 147, column: 29, scope: !413, inlinedAt: !319, atomGroup: 4, atomRank: 1)
!416 = !DILocation(line: 150, column: 16, scope: !417, inlinedAt: !319)
!417 = distinct !DILexicalBlock(scope: !58, file: !3, line: 150, column: 9)
!418 = !{!419, !375, i64 0}
!419 = !{!"gre_hdr", !375, i64 0, !375, i64 2}
!420 = !DILocation(line: 150, column: 9, scope: !417, inlinedAt: !319)
!421 = !DILocation(line: 150, column: 22, scope: !417, inlinedAt: !319)
!422 = !DILocation(line: 150, column: 22, scope: !417, inlinedAt: !319, atomGroup: 6, atomRank: 2)
!423 = !DILocation(line: 150, column: 22, scope: !417, inlinedAt: !319, atomGroup: 6, atomRank: 1)
!424 = !DILocation(line: 154, column: 20, scope: !58, inlinedAt: !319)
!425 = !DILocation(line: 154, column: 20, scope: !58, inlinedAt: !319, atomGroup: 9, atomRank: 2)
!426 = !{!419, !375, i64 2}
!427 = !DILocation(line: 155, column: 22, scope: !428, inlinedAt: !319)
!428 = distinct !DILexicalBlock(scope: !58, file: !3, line: 155, column: 9)
!429 = !DILocation(line: 155, column: 22, scope: !428, inlinedAt: !319, atomGroup: 10, atomRank: 2)
!430 = !DILocation(line: 155, column: 22, scope: !428, inlinedAt: !319, atomGroup: 10, atomRank: 1)
!431 = !DILocation(line: 157, column: 22, scope: !432, inlinedAt: !319, atomGroup: 12, atomRank: 1)
!432 = distinct !DILexicalBlock(scope: !58, file: !3, line: 157, column: 9)
!433 = !DILocation(line: 159, column: 22, scope: !434, inlinedAt: !319, atomGroup: 14, atomRank: 1)
!434 = distinct !DILexicalBlock(scope: !58, file: !3, line: 159, column: 9)
!435 = !DILocation(line: 163, column: 15, scope: !436, inlinedAt: !319, atomGroup: 16, atomRank: 2)
!436 = distinct !DILexicalBlock(scope: !58, file: !3, line: 163, column: 9)
!437 = !DILocation(line: 163, column: 15, scope: !436, inlinedAt: !319, atomGroup: 16, atomRank: 1)
!438 = !DILocation(line: 167, column: 14, scope: !439, inlinedAt: !319)
!439 = distinct !DILexicalBlock(scope: !58, file: !3, line: 167, column: 9)
!440 = !DILocation(line: 167, column: 23, scope: !439, inlinedAt: !319, atomGroup: 18, atomRank: 2)
!441 = !DILocation(line: 167, column: 23, scope: !439, inlinedAt: !319, atomGroup: 18, atomRank: 1)
!442 = !DILocation(line: 169, column: 34, scope: !443, inlinedAt: !319)
!443 = distinct !DILexicalBlock(scope: !58, file: !3, line: 169, column: 9)
!444 = !DILocation(line: 169, column: 9, scope: !443, inlinedAt: !319)
!445 = !DILocation(line: 169, column: 9, scope: !443, inlinedAt: !319, atomGroup: 20, atomRank: 2)
!446 = !DILocation(line: 169, column: 9, scope: !443, inlinedAt: !319, atomGroup: 20, atomRank: 1)
!447 = !DILocation(line: 172, column: 31, scope: !58, inlinedAt: !319, atomGroup: 22, atomRank: 4)
!448 = !DILocation(line: 172, column: 20, scope: !58, inlinedAt: !319, atomGroup: 22, atomRank: 3)
!449 = !DILocation(line: 172, column: 12, scope: !58, inlinedAt: !319, atomGroup: 22, atomRank: 2)
!450 = !DILocation(line: 173, column: 35, scope: !58, inlinedAt: !319, atomGroup: 23, atomRank: 4)
!451 = !DILocation(line: 173, column: 24, scope: !58, inlinedAt: !319, atomGroup: 23, atomRank: 3)
!452 = !DILocation(line: 173, column: 16, scope: !58, inlinedAt: !319, atomGroup: 23, atomRank: 2)
!453 = !DILocation(line: 181, column: 14, scope: !454, inlinedAt: !319)
!454 = distinct !DILexicalBlock(scope: !58, file: !3, line: 181, column: 9)
!455 = !DILocation(line: 181, column: 23, scope: !454, inlinedAt: !319, atomGroup: 27, atomRank: 2)
!456 = !DILocation(line: 181, column: 23, scope: !454, inlinedAt: !319, atomGroup: 27, atomRank: 1)
!457 = !DILocation(line: 177, column: 18, scope: !58, inlinedAt: !319)
!458 = !DILocation(line: 177, column: 18, scope: !58, inlinedAt: !319, atomGroup: 25, atomRank: 2)
!459 = !DILocation(line: 186, column: 15, scope: !124, inlinedAt: !319, atomGroup: 29, atomRank: 2)
!460 = !DILocation(line: 186, column: 15, scope: !124, inlinedAt: !319, atomGroup: 29, atomRank: 1)
!461 = !DILocation(line: 0, scope: !123, inlinedAt: !319)
!462 = !DILocation(line: 188, column: 27, scope: !463, inlinedAt: !319)
!463 = distinct !DILexicalBlock(scope: !123, file: !3, line: 188, column: 13)
!464 = !DILocation(line: 188, column: 32, scope: !463, inlinedAt: !319, atomGroup: 31, atomRank: 2)
!465 = !DILocation(line: 188, column: 32, scope: !463, inlinedAt: !319, atomGroup: 31, atomRank: 1)
!466 = !DILocation(line: 190, column: 23, scope: !123, inlinedAt: !319)
!467 = !DILocation(line: 190, column: 23, scope: !123, inlinedAt: !319, atomGroup: 33, atomRank: 2)
!468 = !DILocation(line: 177, column: 11, scope: !58, inlinedAt: !319, atomGroup: 25, atomRank: 1)
!469 = !DILocation(line: 179, column: 12, scope: !58, inlinedAt: !319, atomGroup: 26, atomRank: 1)
!470 = !DILocation(line: 194, column: 14, scope: !471, inlinedAt: !319)
!471 = distinct !DILexicalBlock(scope: !58, file: !3, line: 194, column: 9)
!472 = !DILocation(line: 194, column: 23, scope: !471, inlinedAt: !319, atomGroup: 35, atomRank: 2)
!473 = !DILocation(line: 194, column: 23, scope: !471, inlinedAt: !319, atomGroup: 35, atomRank: 1)
!474 = !DILocation(line: 197, column: 15, scope: !318, inlinedAt: !319, atomGroup: 37, atomRank: 1)
!475 = !DILocation(line: 77, column: 22, scope: !476, inlinedAt: !351)
!476 = distinct !DILexicalBlock(scope: !335, file: !3, line: 77, column: 9)
!477 = !DILocation(line: 77, column: 27, scope: !476, inlinedAt: !351, atomGroup: 2, atomRank: 2)
!478 = !DILocation(line: 77, column: 27, scope: !476, inlinedAt: !351, atomGroup: 2, atomRank: 1)
!479 = !DILocation(line: 80, column: 5, scope: !335, inlinedAt: !351)
!480 = !DILocation(line: 80, column: 11, scope: !335, inlinedAt: !351, atomGroup: 4, atomRank: 1)
!481 = distinct !DIAssignID()
!482 = !DILocation(line: 81, column: 5, scope: !335, inlinedAt: !351)
!483 = !DILocation(line: 82, column: 22, scope: !335, inlinedAt: !351, atomGroup: 5, atomRank: 2)
!484 = !DILocation(line: 87, column: 21, scope: !335, inlinedAt: !351)
!485 = !{!214, !214, i64 0}
!486 = !DILocation(line: 87, column: 34, scope: !335, inlinedAt: !351)
!487 = !DILocation(line: 87, column: 27, scope: !335, inlinedAt: !351, atomGroup: 6, atomRank: 2)
!488 = !DILocation(line: 23, column: 12, scope: !489, inlinedAt: !355)
!489 = distinct !DILexicalBlock(scope: !490, file: !300, line: 22, column: 24)
!490 = distinct !DILexicalBlock(scope: !491, file: !300, line: 22, column: 2)
!491 = distinct !DILexicalBlock(scope: !299, file: !300, line: 22, column: 2)
!492 = !DILocation(line: 23, column: 9, scope: !489, inlinedAt: !355, atomGroup: 9, atomRank: 2)
!493 = !DILocation(line: 24, column: 32, scope: !489, inlinedAt: !355)
!494 = !DILocation(line: 25, column: 18, scope: !489, inlinedAt: !355)
!495 = !DILocation(line: 25, column: 25, scope: !489, inlinedAt: !355, atomGroup: 11, atomRank: 2)
!496 = !DILocation(line: 27, column: 17, scope: !489, inlinedAt: !355)
!497 = !DILocation(line: 27, column: 9, scope: !489, inlinedAt: !355, atomGroup: 13, atomRank: 2)
!498 = !DILocation(line: 47, column: 15, scope: !299, inlinedAt: !355)
!499 = !DILocation(line: 47, column: 7, scope: !299, inlinedAt: !355, atomGroup: 29, atomRank: 2)
!500 = !DILocation(line: 48, column: 15, scope: !299, inlinedAt: !355)
!501 = !DILocation(line: 48, column: 7, scope: !299, inlinedAt: !355, atomGroup: 30, atomRank: 2)
!502 = !DILocation(line: 49, column: 15, scope: !299, inlinedAt: !355)
!503 = !DILocation(line: 49, column: 7, scope: !299, inlinedAt: !355, atomGroup: 31, atomRank: 2)
!504 = !DILocation(line: 50, column: 15, scope: !299, inlinedAt: !355)
!505 = !DILocation(line: 50, column: 7, scope: !299, inlinedAt: !355, atomGroup: 32, atomRank: 2)
!506 = !DILocation(line: 51, column: 15, scope: !299, inlinedAt: !355)
!507 = !DILocation(line: 51, column: 7, scope: !299, inlinedAt: !355, atomGroup: 33, atomRank: 2)
!508 = !DILocation(line: 52, column: 15, scope: !299, inlinedAt: !355)
!509 = !DILocation(line: 52, column: 7, scope: !299, inlinedAt: !355, atomGroup: 34, atomRank: 2)
!510 = !DILocation(line: 90, column: 9, scope: !511, inlinedAt: !351, atomGroup: 8, atomRank: 2)
!511 = distinct !DILexicalBlock(scope: !335, file: !3, line: 90, column: 9)
!512 = !DILocation(line: 90, column: 17, scope: !511, inlinedAt: !351, atomGroup: 8, atomRank: 1)
!513 = !DILocation(line: 90, column: 20, scope: !511, inlinedAt: !351)
!514 = !DILocation(line: 90, column: 20, scope: !511, inlinedAt: !351, atomGroup: 9, atomRank: 2)
!515 = !DILocation(line: 90, column: 17, scope: !511, inlinedAt: !351, atomGroup: 9, atomRank: 1)
!516 = !DILocation(line: 91, column: 29, scope: !517, inlinedAt: !351, atomGroup: 10, atomRank: 2)
!517 = distinct !DILexicalBlock(scope: !511, file: !3, line: 90, column: 30)
!518 = !DILocation(line: 91, column: 18, scope: !517, inlinedAt: !351, atomGroup: 10, atomRank: 1)
!519 = distinct !DIAssignID()
!520 = !DILocation(line: 92, column: 24, scope: !517, inlinedAt: !351, atomGroup: 11, atomRank: 2)
!521 = !DILocation(line: 93, column: 14, scope: !522, inlinedAt: !351, atomGroup: 12, atomRank: 2)
!522 = distinct !DILexicalBlock(scope: !517, file: !3, line: 93, column: 13)
!523 = !DILocation(line: 93, column: 13, scope: !522, inlinedAt: !351, atomGroup: 12, atomRank: 1)
!524 = !DILocation(line: 95, column: 20, scope: !517, inlinedAt: !351, atomGroup: 14, atomRank: 2)
!525 = !DILocation(line: 95, column: 18, scope: !517, inlinedAt: !351, atomGroup: 14, atomRank: 1)
!526 = distinct !DIAssignID()
!527 = !DILocation(line: 96, column: 43, scope: !517, inlinedAt: !351)
!528 = !DILocation(line: 96, column: 16, scope: !517, inlinedAt: !351, atomGroup: 15, atomRank: 3)
!529 = !DILocation(line: 96, column: 16, scope: !517, inlinedAt: !351, atomGroup: 15, atomRank: 2)
!530 = !DILocation(line: 96, column: 9, scope: !517, inlinedAt: !351, atomGroup: 15, atomRank: 1)
!531 = !DILocation(line: 0, scope: !511, inlinedAt: !351)
!532 = !DILocation(line: 100, column: 1, scope: !335, inlinedAt: !351)
!533 = !DILocation(line: 105, column: 23, scope: !534, inlinedAt: !315)
!534 = distinct !DILexicalBlock(scope: !234, file: !3, line: 105, column: 9)
!535 = !DILocation(line: 105, column: 28, scope: !534, inlinedAt: !315, atomGroup: 2, atomRank: 2)
!536 = !DILocation(line: 105, column: 28, scope: !534, inlinedAt: !315, atomGroup: 2, atomRank: 1)
!537 = !DILocation(line: 108, column: 5, scope: !234, inlinedAt: !315)
!538 = !DILocation(line: 108, column: 11, scope: !234, inlinedAt: !315, atomGroup: 4, atomRank: 1)
!539 = distinct !DIAssignID()
!540 = !DILocation(line: 109, column: 5, scope: !234, inlinedAt: !315)
!541 = !DILocation(line: 110, column: 22, scope: !234, inlinedAt: !315, atomGroup: 5, atomRank: 2)
!542 = !DILocation(line: 115, column: 23, scope: !234, inlinedAt: !315)
!543 = !DILocation(line: 115, column: 17, scope: !234, inlinedAt: !315)
!544 = !DILocation(line: 115, column: 50, scope: !234, inlinedAt: !315)
!545 = !DILocation(line: 115, column: 44, scope: !234, inlinedAt: !315)
!546 = !DILocation(line: 115, column: 42, scope: !234, inlinedAt: !315, atomGroup: 6, atomRank: 2)
!547 = !DILocation(line: 116, column: 17, scope: !234, inlinedAt: !315)
!548 = !DILocation(line: 116, column: 44, scope: !234, inlinedAt: !315)
!549 = !DILocation(line: 116, column: 42, scope: !234, inlinedAt: !315)
!550 = !DILocation(line: 116, column: 14, scope: !234, inlinedAt: !315, atomGroup: 7, atomRank: 2)
!551 = !DILocation(line: 117, column: 17, scope: !234, inlinedAt: !315)
!552 = !DILocation(line: 117, column: 44, scope: !234, inlinedAt: !315)
!553 = !DILocation(line: 117, column: 42, scope: !234, inlinedAt: !315)
!554 = !DILocation(line: 117, column: 14, scope: !234, inlinedAt: !315, atomGroup: 8, atomRank: 2)
!555 = !DILocation(line: 118, column: 17, scope: !234, inlinedAt: !315)
!556 = !DILocation(line: 118, column: 44, scope: !234, inlinedAt: !315)
!557 = !DILocation(line: 118, column: 42, scope: !234, inlinedAt: !315)
!558 = !DILocation(line: 118, column: 14, scope: !234, inlinedAt: !315, atomGroup: 9, atomRank: 2)
!559 = !DILocation(line: 23, column: 12, scope: !489, inlinedAt: !332)
!560 = !DILocation(line: 23, column: 9, scope: !489, inlinedAt: !332, atomGroup: 9, atomRank: 2)
!561 = !DILocation(line: 24, column: 32, scope: !489, inlinedAt: !332)
!562 = !DILocation(line: 25, column: 18, scope: !489, inlinedAt: !332)
!563 = !DILocation(line: 25, column: 25, scope: !489, inlinedAt: !332, atomGroup: 11, atomRank: 2)
!564 = !DILocation(line: 27, column: 17, scope: !489, inlinedAt: !332)
!565 = !DILocation(line: 27, column: 9, scope: !489, inlinedAt: !332, atomGroup: 13, atomRank: 2)
!566 = !DILocation(line: 47, column: 15, scope: !299, inlinedAt: !332)
!567 = !DILocation(line: 47, column: 7, scope: !299, inlinedAt: !332, atomGroup: 29, atomRank: 2)
!568 = !DILocation(line: 48, column: 15, scope: !299, inlinedAt: !332)
!569 = !DILocation(line: 48, column: 7, scope: !299, inlinedAt: !332, atomGroup: 30, atomRank: 2)
!570 = !DILocation(line: 49, column: 15, scope: !299, inlinedAt: !332)
!571 = !DILocation(line: 49, column: 7, scope: !299, inlinedAt: !332, atomGroup: 31, atomRank: 2)
!572 = !DILocation(line: 50, column: 15, scope: !299, inlinedAt: !332)
!573 = !DILocation(line: 50, column: 7, scope: !299, inlinedAt: !332, atomGroup: 32, atomRank: 2)
!574 = !DILocation(line: 51, column: 15, scope: !299, inlinedAt: !332)
!575 = !DILocation(line: 51, column: 7, scope: !299, inlinedAt: !332, atomGroup: 33, atomRank: 2)
!576 = !DILocation(line: 52, column: 15, scope: !299, inlinedAt: !332)
!577 = !DILocation(line: 52, column: 7, scope: !299, inlinedAt: !332, atomGroup: 34, atomRank: 2)
!578 = !DILocation(line: 121, column: 9, scope: !579, inlinedAt: !315, atomGroup: 11, atomRank: 2)
!579 = distinct !DILexicalBlock(scope: !234, file: !3, line: 121, column: 9)
!580 = !DILocation(line: 121, column: 17, scope: !579, inlinedAt: !315, atomGroup: 11, atomRank: 1)
!581 = !DILocation(line: 121, column: 20, scope: !579, inlinedAt: !315)
!582 = !DILocation(line: 121, column: 20, scope: !579, inlinedAt: !315, atomGroup: 12, atomRank: 2)
!583 = !DILocation(line: 121, column: 17, scope: !579, inlinedAt: !315, atomGroup: 12, atomRank: 1)
!584 = !DILocation(line: 122, column: 29, scope: !585, inlinedAt: !315, atomGroup: 13, atomRank: 2)
!585 = distinct !DILexicalBlock(scope: !579, file: !3, line: 121, column: 30)
!586 = !DILocation(line: 122, column: 18, scope: !585, inlinedAt: !315, atomGroup: 13, atomRank: 1)
!587 = distinct !DIAssignID()
!588 = !DILocation(line: 123, column: 24, scope: !585, inlinedAt: !315, atomGroup: 14, atomRank: 2)
!589 = !DILocation(line: 124, column: 14, scope: !590, inlinedAt: !315, atomGroup: 15, atomRank: 2)
!590 = distinct !DILexicalBlock(scope: !585, file: !3, line: 124, column: 13)
!591 = !DILocation(line: 124, column: 13, scope: !590, inlinedAt: !315, atomGroup: 15, atomRank: 1)
!592 = !DILocation(line: 126, column: 20, scope: !585, inlinedAt: !315, atomGroup: 17, atomRank: 2)
!593 = !DILocation(line: 126, column: 18, scope: !585, inlinedAt: !315, atomGroup: 17, atomRank: 1)
!594 = distinct !DIAssignID()
!595 = !DILocation(line: 127, column: 43, scope: !585, inlinedAt: !315)
!596 = !DILocation(line: 127, column: 16, scope: !585, inlinedAt: !315, atomGroup: 18, atomRank: 3)
!597 = !DILocation(line: 127, column: 16, scope: !585, inlinedAt: !315, atomGroup: 18, atomRank: 2)
!598 = !DILocation(line: 127, column: 9, scope: !585, inlinedAt: !315, atomGroup: 18, atomRank: 1)
!599 = !DILocation(line: 0, scope: !579, inlinedAt: !315)
!600 = !DILocation(line: 133, column: 1, scope: !234, inlinedAt: !315)
!601 = !DILocation(line: 80, column: 5, scope: !335, inlinedAt: !345)
!602 = !DILocation(line: 80, column: 11, scope: !335, inlinedAt: !345, atomGroup: 4, atomRank: 1)
!603 = distinct !DIAssignID()
!604 = !DILocation(line: 81, column: 5, scope: !335, inlinedAt: !345)
!605 = !DILocation(line: 82, column: 22, scope: !335, inlinedAt: !345, atomGroup: 5, atomRank: 2)
!606 = !DILocation(line: 87, column: 21, scope: !335, inlinedAt: !345)
!607 = !DILocation(line: 87, column: 34, scope: !335, inlinedAt: !345)
!608 = !DILocation(line: 87, column: 27, scope: !335, inlinedAt: !345, atomGroup: 6, atomRank: 2)
!609 = !DILocation(line: 23, column: 12, scope: !489, inlinedAt: !348)
!610 = !DILocation(line: 23, column: 9, scope: !489, inlinedAt: !348, atomGroup: 9, atomRank: 2)
!611 = !DILocation(line: 24, column: 32, scope: !489, inlinedAt: !348)
!612 = !DILocation(line: 25, column: 18, scope: !489, inlinedAt: !348)
!613 = !DILocation(line: 25, column: 25, scope: !489, inlinedAt: !348, atomGroup: 11, atomRank: 2)
!614 = !DILocation(line: 27, column: 17, scope: !489, inlinedAt: !348)
!615 = !DILocation(line: 27, column: 9, scope: !489, inlinedAt: !348, atomGroup: 13, atomRank: 2)
!616 = !DILocation(line: 47, column: 15, scope: !299, inlinedAt: !348)
!617 = !DILocation(line: 47, column: 7, scope: !299, inlinedAt: !348, atomGroup: 29, atomRank: 2)
!618 = !DILocation(line: 48, column: 15, scope: !299, inlinedAt: !348)
!619 = !DILocation(line: 48, column: 7, scope: !299, inlinedAt: !348, atomGroup: 30, atomRank: 2)
!620 = !DILocation(line: 49, column: 15, scope: !299, inlinedAt: !348)
!621 = !DILocation(line: 49, column: 7, scope: !299, inlinedAt: !348, atomGroup: 31, atomRank: 2)
!622 = !DILocation(line: 50, column: 15, scope: !299, inlinedAt: !348)
!623 = !DILocation(line: 50, column: 7, scope: !299, inlinedAt: !348, atomGroup: 32, atomRank: 2)
!624 = !DILocation(line: 51, column: 15, scope: !299, inlinedAt: !348)
!625 = !DILocation(line: 51, column: 7, scope: !299, inlinedAt: !348, atomGroup: 33, atomRank: 2)
!626 = !DILocation(line: 52, column: 15, scope: !299, inlinedAt: !348)
!627 = !DILocation(line: 52, column: 7, scope: !299, inlinedAt: !348, atomGroup: 34, atomRank: 2)
!628 = !DILocation(line: 90, column: 9, scope: !511, inlinedAt: !345, atomGroup: 8, atomRank: 2)
!629 = !DILocation(line: 90, column: 17, scope: !511, inlinedAt: !345, atomGroup: 8, atomRank: 1)
!630 = !DILocation(line: 90, column: 20, scope: !511, inlinedAt: !345)
!631 = !DILocation(line: 90, column: 20, scope: !511, inlinedAt: !345, atomGroup: 9, atomRank: 2)
!632 = !DILocation(line: 90, column: 17, scope: !511, inlinedAt: !345, atomGroup: 9, atomRank: 1)
!633 = !DILocation(line: 91, column: 29, scope: !517, inlinedAt: !345, atomGroup: 10, atomRank: 2)
!634 = !DILocation(line: 91, column: 18, scope: !517, inlinedAt: !345, atomGroup: 10, atomRank: 1)
!635 = distinct !DIAssignID()
!636 = !DILocation(line: 92, column: 24, scope: !517, inlinedAt: !345, atomGroup: 11, atomRank: 2)
!637 = !DILocation(line: 93, column: 14, scope: !522, inlinedAt: !345, atomGroup: 12, atomRank: 2)
!638 = !DILocation(line: 93, column: 13, scope: !522, inlinedAt: !345, atomGroup: 12, atomRank: 1)
!639 = !DILocation(line: 95, column: 20, scope: !517, inlinedAt: !345, atomGroup: 14, atomRank: 2)
!640 = !DILocation(line: 95, column: 18, scope: !517, inlinedAt: !345, atomGroup: 14, atomRank: 1)
!641 = distinct !DIAssignID()
!642 = !DILocation(line: 96, column: 43, scope: !517, inlinedAt: !345)
!643 = !DILocation(line: 96, column: 16, scope: !517, inlinedAt: !345, atomGroup: 15, atomRank: 3)
!644 = !DILocation(line: 96, column: 16, scope: !517, inlinedAt: !345, atomGroup: 15, atomRank: 2)
!645 = !DILocation(line: 96, column: 9, scope: !517, inlinedAt: !345, atomGroup: 15, atomRank: 1)
!646 = !DILocation(line: 0, scope: !511, inlinedAt: !345)
!647 = !DILocation(line: 100, column: 1, scope: !335, inlinedAt: !345)
!648 = !DILocation(line: 214, column: 5, scope: !322, inlinedAt: !329, atomGroup: 6, atomRank: 1)
!649 = !DILocation(line: 0, scope: !287, inlinedAt: !294)
!650 = !DILocation(line: 219, column: 33, scope: !287, inlinedAt: !294, atomGroup: 1, atomRank: 2)
!651 = !DILocation(line: 105, column: 23, scope: !534, inlinedAt: !286)
!652 = !DILocation(line: 105, column: 28, scope: !534, inlinedAt: !286, atomGroup: 2, atomRank: 2)
!653 = !DILocation(line: 105, column: 28, scope: !534, inlinedAt: !286, atomGroup: 2, atomRank: 1)
!654 = !DILocation(line: 108, column: 5, scope: !234, inlinedAt: !286)
!655 = !DILocation(line: 108, column: 11, scope: !234, inlinedAt: !286, atomGroup: 4, atomRank: 1)
!656 = distinct !DIAssignID()
!657 = !DILocation(line: 109, column: 5, scope: !234, inlinedAt: !286)
!658 = !DILocation(line: 110, column: 22, scope: !234, inlinedAt: !286, atomGroup: 5, atomRank: 2)
!659 = !DILocation(line: 115, column: 23, scope: !234, inlinedAt: !286)
!660 = !DILocation(line: 115, column: 17, scope: !234, inlinedAt: !286)
!661 = !DILocation(line: 115, column: 50, scope: !234, inlinedAt: !286)
!662 = !DILocation(line: 115, column: 44, scope: !234, inlinedAt: !286)
!663 = !DILocation(line: 115, column: 42, scope: !234, inlinedAt: !286, atomGroup: 6, atomRank: 2)
!664 = !DILocation(line: 116, column: 17, scope: !234, inlinedAt: !286)
!665 = !DILocation(line: 116, column: 44, scope: !234, inlinedAt: !286)
!666 = !DILocation(line: 116, column: 42, scope: !234, inlinedAt: !286)
!667 = !DILocation(line: 116, column: 14, scope: !234, inlinedAt: !286, atomGroup: 7, atomRank: 2)
!668 = !DILocation(line: 117, column: 17, scope: !234, inlinedAt: !286)
!669 = !DILocation(line: 117, column: 44, scope: !234, inlinedAt: !286)
!670 = !DILocation(line: 117, column: 42, scope: !234, inlinedAt: !286)
!671 = !DILocation(line: 117, column: 14, scope: !234, inlinedAt: !286, atomGroup: 8, atomRank: 2)
!672 = !DILocation(line: 118, column: 17, scope: !234, inlinedAt: !286)
!673 = !DILocation(line: 118, column: 44, scope: !234, inlinedAt: !286)
!674 = !DILocation(line: 118, column: 42, scope: !234, inlinedAt: !286)
!675 = !DILocation(line: 118, column: 14, scope: !234, inlinedAt: !286, atomGroup: 9, atomRank: 2)
!676 = !DILocation(line: 23, column: 12, scope: !489, inlinedAt: !312)
!677 = !DILocation(line: 23, column: 9, scope: !489, inlinedAt: !312, atomGroup: 9, atomRank: 2)
!678 = !DILocation(line: 24, column: 32, scope: !489, inlinedAt: !312)
!679 = !DILocation(line: 25, column: 18, scope: !489, inlinedAt: !312)
!680 = !DILocation(line: 25, column: 25, scope: !489, inlinedAt: !312, atomGroup: 11, atomRank: 2)
!681 = !DILocation(line: 27, column: 17, scope: !489, inlinedAt: !312)
!682 = !DILocation(line: 27, column: 9, scope: !489, inlinedAt: !312, atomGroup: 13, atomRank: 2)
!683 = !DILocation(line: 47, column: 15, scope: !299, inlinedAt: !312)
!684 = !DILocation(line: 47, column: 7, scope: !299, inlinedAt: !312, atomGroup: 29, atomRank: 2)
!685 = !DILocation(line: 48, column: 15, scope: !299, inlinedAt: !312)
!686 = !DILocation(line: 48, column: 7, scope: !299, inlinedAt: !312, atomGroup: 30, atomRank: 2)
!687 = !DILocation(line: 49, column: 15, scope: !299, inlinedAt: !312)
!688 = !DILocation(line: 49, column: 7, scope: !299, inlinedAt: !312, atomGroup: 31, atomRank: 2)
!689 = !DILocation(line: 50, column: 15, scope: !299, inlinedAt: !312)
!690 = !DILocation(line: 50, column: 7, scope: !299, inlinedAt: !312, atomGroup: 32, atomRank: 2)
!691 = !DILocation(line: 51, column: 15, scope: !299, inlinedAt: !312)
!692 = !DILocation(line: 51, column: 7, scope: !299, inlinedAt: !312, atomGroup: 33, atomRank: 2)
!693 = !DILocation(line: 52, column: 15, scope: !299, inlinedAt: !312)
!694 = !DILocation(line: 52, column: 7, scope: !299, inlinedAt: !312, atomGroup: 34, atomRank: 2)
!695 = !DILocation(line: 121, column: 9, scope: !579, inlinedAt: !286, atomGroup: 11, atomRank: 2)
!696 = !DILocation(line: 121, column: 17, scope: !579, inlinedAt: !286, atomGroup: 11, atomRank: 1)
!697 = !DILocation(line: 121, column: 20, scope: !579, inlinedAt: !286)
!698 = !DILocation(line: 121, column: 20, scope: !579, inlinedAt: !286, atomGroup: 12, atomRank: 2)
!699 = !DILocation(line: 121, column: 17, scope: !579, inlinedAt: !286, atomGroup: 12, atomRank: 1)
!700 = !DILocation(line: 122, column: 29, scope: !585, inlinedAt: !286, atomGroup: 13, atomRank: 2)
!701 = !DILocation(line: 122, column: 18, scope: !585, inlinedAt: !286, atomGroup: 13, atomRank: 1)
!702 = distinct !DIAssignID()
!703 = !DILocation(line: 123, column: 24, scope: !585, inlinedAt: !286, atomGroup: 14, atomRank: 2)
!704 = !DILocation(line: 124, column: 14, scope: !590, inlinedAt: !286, atomGroup: 15, atomRank: 2)
!705 = !DILocation(line: 124, column: 13, scope: !590, inlinedAt: !286, atomGroup: 15, atomRank: 1)
!706 = !DILocation(line: 126, column: 20, scope: !585, inlinedAt: !286, atomGroup: 17, atomRank: 2)
!707 = !DILocation(line: 126, column: 18, scope: !585, inlinedAt: !286, atomGroup: 17, atomRank: 1)
!708 = distinct !DIAssignID()
!709 = !DILocation(line: 127, column: 43, scope: !585, inlinedAt: !286)
!710 = !DILocation(line: 127, column: 16, scope: !585, inlinedAt: !286, atomGroup: 18, atomRank: 3)
!711 = !DILocation(line: 127, column: 16, scope: !585, inlinedAt: !286, atomGroup: 18, atomRank: 2)
!712 = !DILocation(line: 127, column: 9, scope: !585, inlinedAt: !286, atomGroup: 18, atomRank: 1)
!713 = !DILocation(line: 0, scope: !579, inlinedAt: !286)
!714 = !DILocation(line: 133, column: 1, scope: !234, inlinedAt: !286)
!715 = !DILocation(line: 268, column: 1, scope: !216, atomGroup: 27, atomRank: 1)
