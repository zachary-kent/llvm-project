; ModuleID = 'samples/bpf/xdp_tx_iptunnel_kern.c'
source_filename = "samples/bpf/xdp_tx_iptunnel_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.vip = type { %union.anon, i16, i16, i8 }
%union.anon = type { [4 x i32] }

@rxcnt = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 256, i32 0, i32 0, i32 0 }, section "maps", align 4
@vip2tnl = dso_local global %struct.bpf_map_def { i32 1, i32 24, i32 40, i32 256, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1
@llvm.compiler.used = appending global [4 x ptr] [ptr @_license, ptr @_xdp_tx_iptunnel, ptr @rxcnt, ptr @vip2tnl], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define dso_local range(i32 1, 4) i32 @_xdp_tx_iptunnel(ptr noundef %0) #0 section "xdp_tx_iptunnel" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca %struct.vip, align 4
  %5 = alloca %struct.vip, align 4
  %6 = getelementptr inbounds nuw i8, ptr %0, i64 4
  %7 = load i32, ptr %6, align 4, !tbaa !5
  %8 = zext i32 %7 to i64
  %9 = inttoptr i64 %8 to ptr
  %10 = load i32, ptr %0, align 4, !tbaa !10
  %11 = zext i32 %10 to i64
  %12 = inttoptr i64 %11 to ptr
  %13 = getelementptr inbounds nuw i8, ptr %12, i64 14
  %14 = icmp samesign ugt ptr %13, %9
  br i1 %14, label %194, label %15

15:                                               ; preds = %1
  %16 = getelementptr inbounds nuw i8, ptr %12, i64 12
  %17 = load i16, ptr %16, align 1, !tbaa !11
  switch i16 %17, label %194 [
    i16 8, label %18
    i16 -8826, label %124
  ]

18:                                               ; preds = %15
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %5) #5
  %19 = getelementptr inbounds nuw i8, ptr %5, i64 4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(24) %19, i8 0, i64 20, i1 false)
  %20 = getelementptr inbounds nuw i8, ptr %12, i64 34
  %21 = icmp samesign ugt ptr %20, %9
  br i1 %21, label %122, label %22

22:                                               ; preds = %18
  %23 = getelementptr inbounds nuw i8, ptr %12, i64 23
  %24 = load i8, ptr %23, align 1, !tbaa !14
  switch i8 %24, label %34 [
    i8 6, label %25
    i8 17, label %28
  ]

25:                                               ; preds = %22
  %26 = getelementptr inbounds nuw i8, ptr %12, i64 54
  %27 = icmp samesign ugt ptr %26, %9
  br i1 %27, label %122, label %31

28:                                               ; preds = %22
  %29 = getelementptr inbounds nuw i8, ptr %12, i64 42
  %30 = icmp samesign ugt ptr %29, %9
  br i1 %30, label %122, label %31

31:                                               ; preds = %28, %25
  %32 = getelementptr inbounds nuw i8, ptr %12, i64 36
  %33 = load i16, ptr %32, align 2, !tbaa !16
  br label %34

34:                                               ; preds = %31, %22
  %35 = phi i16 [ 0, %22 ], [ %33, %31 ]
  %36 = getelementptr inbounds nuw i8, ptr %5, i64 20
  store i8 %24, ptr %36, align 4, !tbaa !17
  %37 = getelementptr inbounds nuw i8, ptr %5, i64 18
  store i16 2, ptr %37, align 2, !tbaa !19
  %38 = getelementptr inbounds nuw i8, ptr %12, i64 30
  %39 = load i32, ptr %38, align 4, !tbaa !20
  store i32 %39, ptr %5, align 4, !tbaa !21
  %40 = getelementptr inbounds nuw i8, ptr %5, i64 16
  store i16 %35, ptr %40, align 4, !tbaa !22
  %41 = getelementptr inbounds nuw i8, ptr %12, i64 16
  %42 = load i16, ptr %41, align 2, !tbaa !23
  %43 = tail call i16 @llvm.bswap.i16(i16 %42)
  %44 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @vip2tnl, ptr noundef nonnull %5) #5
  %45 = icmp eq ptr %44, null
  br i1 %45, label %122, label %46

46:                                               ; preds = %34
  %47 = getelementptr inbounds nuw i8, ptr %44, i64 32
  %48 = load i16, ptr %47, align 4, !tbaa !24
  %49 = icmp eq i16 %48, 2
  br i1 %49, label %50, label %122

50:                                               ; preds = %46
  %51 = call i32 inttoptr (i64 44 to ptr)(ptr noundef nonnull %0, i32 noundef -20) #5
  %52 = icmp eq i32 %51, 0
  br i1 %52, label %53, label %122

53:                                               ; preds = %50
  %54 = load i32, ptr %0, align 4, !tbaa !10
  %55 = zext i32 %54 to i64
  %56 = inttoptr i64 %55 to ptr
  %57 = load i32, ptr %6, align 4, !tbaa !5
  %58 = zext i32 %57 to i64
  %59 = inttoptr i64 %58 to ptr
  %60 = getelementptr inbounds nuw i8, ptr %56, i64 14
  %61 = icmp samesign ugt ptr %60, %59
  %62 = getelementptr inbounds nuw i8, ptr %56, i64 34
  %63 = icmp samesign ugt ptr %62, %59
  %64 = select i1 %61, i1 true, i1 %63
  br i1 %64, label %122, label %65

65:                                               ; preds = %53
  %66 = getelementptr inbounds nuw i8, ptr %56, i64 20
  %67 = getelementptr inbounds nuw i8, ptr %56, i64 6
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %67, ptr noundef nonnull align 1 dereferenceable(6) %66, i64 6, i1 false)
  %68 = getelementptr inbounds nuw i8, ptr %44, i64 34
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %56, ptr noundef nonnull align 2 dereferenceable(6) %68, i64 6, i1 false)
  %69 = getelementptr inbounds nuw i8, ptr %56, i64 12
  store i16 8, ptr %69, align 1, !tbaa !11
  store i8 69, ptr %60, align 4
  store i16 0, ptr %66, align 2, !tbaa !26
  %70 = getelementptr inbounds nuw i8, ptr %56, i64 23
  store i8 4, ptr %70, align 1, !tbaa !14
  %71 = getelementptr inbounds nuw i8, ptr %56, i64 24
  store i16 0, ptr %71, align 2, !tbaa !27
  %72 = getelementptr inbounds nuw i8, ptr %56, i64 15
  store i8 0, ptr %72, align 1, !tbaa !28
  %73 = add i16 %43, 20
  %74 = call i16 @llvm.bswap.i16(i16 %73)
  %75 = getelementptr inbounds nuw i8, ptr %56, i64 16
  store i16 %74, ptr %75, align 2, !tbaa !23
  %76 = getelementptr inbounds nuw i8, ptr %44, i64 16
  %77 = load i32, ptr %76, align 4, !tbaa !21
  %78 = getelementptr inbounds nuw i8, ptr %56, i64 30
  store i32 %77, ptr %78, align 4, !tbaa !20
  %79 = load i32, ptr %44, align 4, !tbaa !21
  %80 = getelementptr inbounds nuw i8, ptr %56, i64 26
  store i32 %79, ptr %80, align 4, !tbaa !29
  %81 = getelementptr inbounds nuw i8, ptr %56, i64 22
  store i8 8, ptr %81, align 4, !tbaa !30
  %82 = load i16, ptr %60, align 2, !tbaa !16
  %83 = zext i16 %82 to i32
  %84 = getelementptr inbounds nuw i8, ptr %56, i64 18
  %85 = zext i16 %74 to i32
  %86 = add nuw nsw i32 %83, %85
  %87 = load i16, ptr %84, align 2, !tbaa !16
  %88 = zext i16 %87 to i32
  %89 = add nuw nsw i32 %86, %88
  %90 = getelementptr inbounds nuw i8, ptr %56, i64 22
  %91 = load i16, ptr %90, align 2, !tbaa !16
  %92 = zext i16 %91 to i32
  %93 = add nuw nsw i32 %89, %92
  %94 = getelementptr inbounds nuw i8, ptr %56, i64 26
  %95 = getelementptr inbounds nuw i8, ptr %56, i64 28
  %96 = load i16, ptr %94, align 2, !tbaa !16
  %97 = zext i16 %96 to i32
  %98 = add nuw nsw i32 %93, %97
  %99 = getelementptr inbounds nuw i8, ptr %56, i64 30
  %100 = load i16, ptr %95, align 2, !tbaa !16
  %101 = zext i16 %100 to i32
  %102 = add nuw nsw i32 %98, %101
  %103 = getelementptr inbounds nuw i8, ptr %56, i64 32
  %104 = load i16, ptr %99, align 2, !tbaa !16
  %105 = zext i16 %104 to i32
  %106 = add nuw nsw i32 %102, %105
  %107 = load i16, ptr %103, align 2, !tbaa !16
  %108 = zext i16 %107 to i32
  %109 = add nuw nsw i32 %106, %108
  %110 = lshr i32 %109, 16
  %111 = add nuw nsw i32 %110, %109
  %112 = trunc i32 %111 to i16
  %113 = xor i16 %112, -1
  store i16 %113, ptr %71, align 2, !tbaa !27
  %114 = load i8, ptr %36, align 4, !tbaa !17
  %115 = zext i8 %114 to i32
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2)
  store i32 %115, ptr %2, align 4, !tbaa !31
  %116 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @rxcnt, ptr noundef nonnull %2) #5
  %117 = icmp eq ptr %116, null
  br i1 %117, label %121, label %118

118:                                              ; preds = %65
  %119 = load i64, ptr %116, align 8, !tbaa !32
  %120 = add i64 %119, 1
  store i64 %120, ptr %116, align 8, !tbaa !32
  br label %121

121:                                              ; preds = %65, %118
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2)
  br label %122

122:                                              ; preds = %28, %25, %18, %34, %46, %50, %53, %121
  %123 = phi i32 [ 3, %121 ], [ 1, %18 ], [ 2, %46 ], [ 2, %34 ], [ 1, %50 ], [ 1, %53 ], [ 1, %25 ], [ 1, %28 ]
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %5) #5
  br label %194

124:                                              ; preds = %15
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %4) #5
  %125 = getelementptr inbounds nuw i8, ptr %4, i64 20
  store i32 0, ptr %125, align 4
  %126 = getelementptr inbounds nuw i8, ptr %12, i64 54
  %127 = icmp samesign ugt ptr %126, %9
  br i1 %127, label %192, label %128

128:                                              ; preds = %124
  %129 = getelementptr inbounds nuw i8, ptr %12, i64 20
  %130 = load i8, ptr %129, align 2, !tbaa !34
  switch i8 %130, label %140 [
    i8 6, label %131
    i8 17, label %134
  ]

131:                                              ; preds = %128
  %132 = getelementptr inbounds nuw i8, ptr %12, i64 74
  %133 = icmp samesign ugt ptr %132, %9
  br i1 %133, label %192, label %137

134:                                              ; preds = %128
  %135 = getelementptr inbounds nuw i8, ptr %12, i64 62
  %136 = icmp samesign ugt ptr %135, %9
  br i1 %136, label %192, label %137

137:                                              ; preds = %134, %131
  %138 = getelementptr inbounds nuw i8, ptr %12, i64 56
  %139 = load i16, ptr %138, align 2, !tbaa !16
  br label %140

140:                                              ; preds = %137, %128
  %141 = phi i16 [ 0, %128 ], [ %139, %137 ]
  %142 = getelementptr inbounds nuw i8, ptr %4, i64 20
  store i8 %130, ptr %142, align 4, !tbaa !17
  %143 = getelementptr inbounds nuw i8, ptr %4, i64 18
  store i16 10, ptr %143, align 2, !tbaa !19
  %144 = getelementptr inbounds nuw i8, ptr %12, i64 38
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %4, ptr noundef nonnull align 4 dereferenceable(16) %144, i64 16, i1 false)
  %145 = getelementptr inbounds nuw i8, ptr %4, i64 16
  store i16 %141, ptr %145, align 4, !tbaa !22
  %146 = getelementptr inbounds nuw i8, ptr %12, i64 18
  %147 = load i16, ptr %146, align 4, !tbaa !37
  %148 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @vip2tnl, ptr noundef nonnull %4) #5
  %149 = icmp eq ptr %148, null
  br i1 %149, label %192, label %150

150:                                              ; preds = %140
  %151 = getelementptr inbounds nuw i8, ptr %148, i64 32
  %152 = load i16, ptr %151, align 4, !tbaa !24
  %153 = icmp eq i16 %152, 10
  br i1 %153, label %154, label %192

154:                                              ; preds = %150
  %155 = call i32 inttoptr (i64 44 to ptr)(ptr noundef nonnull %0, i32 noundef -40) #5
  %156 = icmp eq i32 %155, 0
  br i1 %156, label %157, label %192

157:                                              ; preds = %154
  %158 = load i32, ptr %0, align 4, !tbaa !10
  %159 = zext i32 %158 to i64
  %160 = inttoptr i64 %159 to ptr
  %161 = load i32, ptr %6, align 4, !tbaa !5
  %162 = zext i32 %161 to i64
  %163 = inttoptr i64 %162 to ptr
  %164 = getelementptr inbounds nuw i8, ptr %160, i64 14
  %165 = icmp samesign ugt ptr %164, %163
  %166 = getelementptr inbounds nuw i8, ptr %160, i64 54
  %167 = icmp samesign ugt ptr %166, %163
  %168 = select i1 %165, i1 true, i1 %167
  br i1 %168, label %192, label %169

169:                                              ; preds = %157
  %170 = getelementptr inbounds nuw i8, ptr %160, i64 40
  %171 = getelementptr inbounds nuw i8, ptr %160, i64 6
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %171, ptr noundef nonnull align 1 dereferenceable(6) %170, i64 6, i1 false)
  %172 = getelementptr inbounds nuw i8, ptr %148, i64 34
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %160, ptr noundef nonnull align 2 dereferenceable(6) %172, i64 6, i1 false)
  %173 = getelementptr inbounds nuw i8, ptr %160, i64 12
  store i16 -8826, ptr %173, align 1, !tbaa !11
  store i8 96, ptr %164, align 4
  %174 = getelementptr inbounds nuw i8, ptr %160, i64 15
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %174, i8 0, i64 3, i1 false)
  %175 = call i16 @llvm.bswap.i16(i16 %147)
  %176 = add i16 %175, 40
  %177 = call noundef i16 @llvm.bswap.i16(i16 %176)
  %178 = getelementptr inbounds nuw i8, ptr %160, i64 18
  store i16 %177, ptr %178, align 4, !tbaa !37
  %179 = getelementptr inbounds nuw i8, ptr %160, i64 20
  store i8 41, ptr %179, align 2, !tbaa !34
  %180 = getelementptr inbounds nuw i8, ptr %160, i64 21
  store i8 8, ptr %180, align 1, !tbaa !38
  %181 = getelementptr inbounds nuw i8, ptr %160, i64 22
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %181, ptr noundef nonnull align 4 dereferenceable(16) %148, i64 16, i1 false)
  %182 = getelementptr inbounds nuw i8, ptr %160, i64 38
  %183 = getelementptr inbounds nuw i8, ptr %148, i64 16
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(16) %182, ptr noundef nonnull align 4 dereferenceable(16) %183, i64 16, i1 false)
  %184 = load i8, ptr %142, align 4, !tbaa !17
  %185 = zext i8 %184 to i32
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3)
  store i32 %185, ptr %3, align 4, !tbaa !31
  %186 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @rxcnt, ptr noundef nonnull %3) #5
  %187 = icmp eq ptr %186, null
  br i1 %187, label %191, label %188

188:                                              ; preds = %169
  %189 = load i64, ptr %186, align 8, !tbaa !32
  %190 = add i64 %189, 1
  store i64 %190, ptr %186, align 8, !tbaa !32
  br label %191

191:                                              ; preds = %169, %188
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3)
  br label %192

192:                                              ; preds = %134, %131, %124, %140, %150, %154, %157, %191
  %193 = phi i32 [ 3, %191 ], [ 1, %124 ], [ 2, %150 ], [ 2, %140 ], [ 1, %154 ], [ 1, %157 ], [ 1, %131 ], [ 1, %134 ]
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %4) #5
  br label %194

194:                                              ; preds = %15, %1, %192, %122
  %195 = phi i32 [ %123, %122 ], [ %193, %192 ], [ 1, %1 ], [ 2, %15 ]
  ret i32 %195
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i16 @llvm.bswap.i16(i16) #4

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #3 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 20.1.8 (0ubuntu4)"}
!5 = !{!6, !7, i64 4}
!6 = !{!"xdp_md", !7, i64 0, !7, i64 4}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!6, !7, i64 0}
!11 = !{!12, !13, i64 12}
!12 = !{!"ethhdr", !8, i64 0, !8, i64 6, !13, i64 12}
!13 = !{!"short", !8, i64 0}
!14 = !{!15, !8, i64 9}
!15 = !{!"iphdr", !8, i64 0, !8, i64 0, !8, i64 1, !13, i64 2, !13, i64 4, !13, i64 6, !8, i64 8, !8, i64 9, !13, i64 10, !7, i64 12, !7, i64 16}
!16 = !{!13, !13, i64 0}
!17 = !{!18, !8, i64 20}
!18 = !{!"vip", !8, i64 0, !13, i64 16, !13, i64 18, !8, i64 20}
!19 = !{!18, !13, i64 18}
!20 = !{!15, !7, i64 16}
!21 = !{!8, !8, i64 0}
!22 = !{!18, !13, i64 16}
!23 = !{!15, !13, i64 2}
!24 = !{!25, !13, i64 32}
!25 = !{!"iptnl_info", !8, i64 0, !8, i64 16, !13, i64 32, !8, i64 34}
!26 = !{!15, !13, i64 6}
!27 = !{!15, !13, i64 10}
!28 = !{!15, !8, i64 1}
!29 = !{!15, !7, i64 12}
!30 = !{!15, !8, i64 8}
!31 = !{!7, !7, i64 0}
!32 = !{!33, !33, i64 0}
!33 = !{!"long long", !8, i64 0}
!34 = !{!35, !8, i64 6}
!35 = !{!"ipv6hdr", !8, i64 0, !8, i64 0, !8, i64 1, !13, i64 4, !8, i64 6, !8, i64 7, !36, i64 8, !36, i64 24}
!36 = !{!"in6_addr", !8, i64 0}
!37 = !{!35, !13, i64 4}
!38 = !{!35, !8, i64 7}
