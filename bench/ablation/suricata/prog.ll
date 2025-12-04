; ModuleID = 'prog.c'
source_filename = "prog.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }

@map = dso_local global %struct.bpf_map_def { i32 1, i32 6, i32 4, i32 256, i32 0 }, section "maps", align 4
@dyn_inst_cnt = dso_local local_unnamed_addr global i32 0, align 4
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @map, ptr @toy_example], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local range(i32 1, 3) i32 @toy_example(ptr noundef readonly captures(none) %ctx) #0 section "xdp" {
entry:
  %key = alloca [6 x i8], align 1
  %X.sroa.0 = alloca i8, align 1
  %X.sroa.3 = alloca i8, align 1
  %X.sroa.4 = alloca i8, align 1
  %X.sroa.5 = alloca i8, align 1
  %data_end1 = getelementptr inbounds nuw i8, ptr %ctx, i64 4
  %0 = load i32, ptr %data_end1, align 4, !tbaa !7
  %conv = zext i32 %0 to i64
  %1 = inttoptr i64 %conv to ptr
  %2 = load i32, ptr %ctx, align 4, !tbaa !9
  %conv3 = zext i32 %2 to i64
  %3 = inttoptr i64 %conv3 to ptr
  call void @llvm.lifetime.start.p0(ptr nonnull %key) #3
  %add.ptr = getelementptr inbounds nuw i8, ptr %3, i64 14
  %cmp = icmp samesign ugt ptr %add.ptr, %1
  br i1 %cmp, label %cleanup19, label %if.end

if.end:                                           ; preds = %entry
  call void @llvm.lifetime.start.p0(ptr nonnull %X.sroa.0)
  call void @llvm.lifetime.start.p0(ptr nonnull %X.sroa.3)
  call void @llvm.lifetime.start.p0(ptr nonnull %X.sroa.4)
  call void @llvm.lifetime.start.p0(ptr nonnull %X.sroa.5)
  store volatile i8 1, ptr %X.sroa.0, align 1, !tbaa !10
  store volatile i8 2, ptr %X.sroa.3, align 1, !tbaa !10
  store volatile i8 3, ptr %X.sroa.4, align 1, !tbaa !10
  store volatile i8 4, ptr %X.sroa.5, align 1, !tbaa !10
  %h_proto = getelementptr inbounds nuw i8, ptr %3, i64 12
  %4 = load i16, ptr %h_proto, align 1, !tbaa !11
  switch i16 %4, label %if.else18 [
    i16 8, label %if.then11
    i16 -8826, label %cleanup
  ]

if.then11:                                        ; preds = %if.end
  %h_source = getelementptr inbounds nuw i8, ptr %3, i64 6
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %key, ptr noundef nonnull align 1 dereferenceable(6) %h_source, i64 6, i1 false)
  %call = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @map, ptr noundef nonnull %key) #3
  %tobool.not = icmp eq ptr %call, null
  %. = select i1 %tobool.not, i32 1, i32 2
  br label %cleanup

if.else18:                                        ; preds = %if.end
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.then11, %if.else18
  %retval.0 = phi i32 [ 2, %if.else18 ], [ %., %if.then11 ], [ 1, %if.end ]
  call void @llvm.lifetime.end.p0(ptr nonnull %X.sroa.0)
  call void @llvm.lifetime.end.p0(ptr nonnull %X.sroa.3)
  call void @llvm.lifetime.end.p0(ptr nonnull %X.sroa.4)
  call void @llvm.lifetime.end.p0(ptr nonnull %X.sroa.5)
  br label %cleanup19

cleanup19:                                        ; preds = %entry, %cleanup
  %retval.1 = phi i32 [ %retval.0, %cleanup ], [ 1, %entry ]
  call void @llvm.lifetime.end.p0(ptr nonnull %key) #3
  ret i32 %retval.1
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

!llvm.module.flags = !{!0, !1}
!llvm.ident = !{!2}
!llvm.errno.tbaa = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"frame-pointer", i32 2}
!2 = !{!"clang version 22.0.0git (git@github.com:zachary-kent/llvm-project.git 61f5544a1abc81abfa952166cfd0464f8ed14e8a)"}
!3 = !{!4, !4, i64 0}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !4, i64 4}
!8 = !{!"xdp_md", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!9 = !{!8, !4, i64 0}
!10 = !{!5, !5, i64 0}
!11 = !{!12, !13, i64 12}
!12 = !{!"ethhdr", !5, i64 0, !5, i64 6, !13, i64 12}
!13 = !{!"short", !5, i64 0}
