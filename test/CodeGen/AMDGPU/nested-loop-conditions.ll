; RUN: opt -mtriple=amdgcn-- -S -structurizecfg -si-annotate-control-flow %s | FileCheck -check-prefix=IR %s
; RUN: llc -march=amdgcn -mcpu=hawaii -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

; After structurizing, there are 3 levels of loops. The i1 phi
; conditions mutually depend on each other, so it isn't safe to delete
; the condition that appears to have no uses until the loop is
; completely processed.


; IR-LABEL: @reduced_nested_loop_conditions(

; IR: bb5:
; IR-NEXT: %phi.broken = phi i64 [ %loop.phi, %bb10 ], [ 0, %bb ]
; IR-NEXT: %tmp6 = phi i32 [ 0, %bb ], [ %tmp11, %bb10 ]
; IR-NEXT: %tmp7 = icmp eq i32 %tmp6, 1
; IR-NEXT: %0 = call { i1, i64 } @llvm.amdgcn.if(i1 %tmp7)
; IR-NEXT: %1 = extractvalue { i1, i64 } %0, 0
; IR-NEXT: %2 = extractvalue { i1, i64 } %0, 1
; IR-NEXT: br i1 %1, label %bb8, label %Flow

; IR: bb8:
; IR-NEXT: %3 = call i64 @llvm.amdgcn.break(i64 %phi.broken)
; IR-NEXT: br label %bb13

; IR: bb10:
; IR-NEXT: %loop.phi = phi i64 [ %6, %Flow ]
; IR-NEXT: %tmp11 = phi i32 [ %5, %Flow ]
; IR-NEXT: %4 = call i1 @llvm.amdgcn.loop(i64 %loop.phi)
; IR-NEXT: br i1 %4, label %bb23, label %bb5

; IR: Flow:
; IR-NEXT: %loop.phi1 = phi i64 [ %loop.phi2, %bb4 ], [ %phi.broken, %bb5 ]
; IR-NEXT: %5 = phi i32 [ %tmp21, %bb4 ], [ undef, %bb5 ]
; IR-NEXT: %6 = call i64 @llvm.amdgcn.else.break(i64 %2, i64 %loop.phi1)
; IR-NEXT: call void @llvm.amdgcn.end.cf(i64 %2)
; IR-NEXT: br label %bb10

; IR: bb13:
; IR-NEXT: %loop.phi3 = phi i64 [ %loop.phi4, %bb3 ], [ %3, %bb8 ]
; IR-NEXT: %tmp14 = phi i1 [ false, %bb3 ], [ true, %bb8 ]
; IR-NEXT: %tmp15 = bitcast i64 %tmp2 to <2 x i32>
; IR-NEXT: br i1 %tmp14, label %bb16, label %bb20

; IR: bb16:
; IR-NEXT: %tmp17 = extractelement <2 x i32> %tmp15, i64 1
; IR-NEXT: %tmp18 = getelementptr inbounds i32, i32 addrspace(3)* undef, i32 %tmp17
; IR-NEXT: %tmp19 = load volatile i32, i32 addrspace(3)* %tmp18
; IR-NEXT: br label %bb20

; IR: bb20:
; IR-NEXT: %loop.phi4 = phi i64 [ %phi.broken, %bb16 ], [ %phi.broken, %bb13 ]
; IR-NEXT: %loop.phi2 = phi i64 [ %phi.broken, %bb16 ], [ %loop.phi3, %bb13 ]
; IR-NEXT: %tmp21 = phi i32 [ %tmp19, %bb16 ], [ 0, %bb13 ]
; IR-NEXT: br label %bb9

; IR: bb23:
; IR-NEXT: call void @llvm.amdgcn.end.cf(i64 %loop.phi)
; IR-NEXT: ret void

; GCN-LABEL: {{^}}reduced_nested_loop_conditions:

; GCN: s_cmp_eq_u32 s{{[0-9]+}}, 1
; GCN-NEXT: s_cbranch_scc1

; FIXME: Should fold to unconditional branch?
; GCN: ; implicit-def
; GCN: s_cbranch_vccz

; GCN: ds_read_b32

; GCN: [[BB9:BB[0-9]+_[0-9]+]]: ; %bb9
; GCN-NEXT: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT: s_branch [[BB9]]
define amdgpu_kernel void @reduced_nested_loop_conditions(i64 addrspace(3)* nocapture %arg) #0 {
bb:
  %tmp = tail call i32 @llvm.amdgcn.workitem.id.x() #1
  %tmp1 = getelementptr inbounds i64, i64 addrspace(3)* %arg, i32 %tmp
  %tmp2 = load volatile i64, i64 addrspace(3)* %tmp1
  br label %bb5

bb3:                                              ; preds = %bb9
  br i1 true, label %bb4, label %bb13

bb4:                                              ; preds = %bb3
  br label %bb10

bb5:                                              ; preds = %bb10, %bb
  %tmp6 = phi i32 [ 0, %bb ], [ %tmp11, %bb10 ]
  %tmp7 = icmp eq i32 %tmp6, 1
  br i1 %tmp7, label %bb8, label %bb10

bb8:                                              ; preds = %bb5
  br label %bb13

bb9:                                              ; preds = %bb20, %bb9
  br i1 false, label %bb3, label %bb9

bb10:                                             ; preds = %bb5, %bb4
  %tmp11 = phi i32 [ %tmp21, %bb4 ], [ undef, %bb5 ]
  %tmp12 = phi i1 [ %tmp22, %bb4 ], [ true, %bb5 ]
  br i1 %tmp12, label %bb23, label %bb5

bb13:                                             ; preds = %bb8, %bb3
  %tmp14 = phi i1 [ %tmp22, %bb3 ], [ true, %bb8 ]
  %tmp15 = bitcast i64 %tmp2 to <2 x i32>
  br i1 %tmp14, label %bb16, label %bb20

bb16:                                             ; preds = %bb13
  %tmp17 = extractelement <2 x i32> %tmp15, i64 1
  %tmp18 = getelementptr inbounds i32, i32 addrspace(3)* undef, i32 %tmp17
  %tmp19 = load volatile i32, i32 addrspace(3)* %tmp18
  br label %bb20

bb20:                                             ; preds = %bb16, %bb13
  %tmp21 = phi i32 [ %tmp19, %bb16 ], [ 0, %bb13 ]
  %tmp22 = phi i1 [ false, %bb16 ], [ %tmp14, %bb13 ]
  br label %bb9

bb23:                                             ; preds = %bb10
  ret void
}

; Earlier version of above, before a run of the structurizer.
; IR-LABEL: @nested_loop_conditions(

; IR: %tmp1235 = icmp slt i32 %tmp1134, 9
; IR:   br i1 %tmp1235, label %bb14.lr.ph, label %Flow

; IR: bb14.lr.ph:
; IR: br label %bb14

; IR: Flow3:
; IR:   call void @llvm.amdgcn.end.cf(i64 %18)
; IR:   %0 = call { i1, i64 } @llvm.amdgcn.if(i1 %17)
; IR:   %1 = extractvalue { i1, i64 } %0, 0
; IR:   %2 = extractvalue { i1, i64 } %0, 1
; IR:   br i1 %1, label %bb4.bb13_crit_edge, label %Flow4

; IR: bb4.bb13_crit_edge:
; IR:   br label %Flow4

; IR: Flow4:
; IR:   %3 = phi i1 [ true, %bb4.bb13_crit_edge ], [ false, %Flow3 ]
; IR:   call void @llvm.amdgcn.end.cf(i64 %2)
; IR:   br label %Flow

; IR: bb13:
; IR:   br label %bb31

; IR: Flow:
; IR:   %4 = phi i1 [ %3, %Flow4 ], [ true, %bb ]
; IR:   %5 = call { i1, i64 } @llvm.amdgcn.if(i1 %4)
; IR:   %6 = extractvalue { i1, i64 } %5, 0
; IR:   %7 = extractvalue { i1, i64 } %5, 1
; IR:   br i1 %6, label %bb13, label %bb31

; IR: bb14:
; IR:   %phi.broken = phi i64 [ %18, %Flow2 ], [ 0, %bb14.lr.ph ]
; IR:   %tmp1037 = phi i32 [ %tmp1033, %bb14.lr.ph ], [ %16, %Flow2 ]
; IR:   %tmp936 = phi <4 x i32> [ %tmp932, %bb14.lr.ph ], [ %15, %Flow2 ]
; IR:   %tmp15 = icmp eq i32 %tmp1037, 1
; IR:   %8 = xor i1 %tmp15, true
; IR:   %9 = call { i1, i64 } @llvm.amdgcn.if(i1 %8)
; IR:   %10 = extractvalue { i1, i64 } %9, 0
; IR:   %11 = extractvalue { i1, i64 } %9, 1
; IR:   br i1 %10, label %bb31.loopexit, label %Flow1

; IR: Flow1:
; IR:   %12 = call { i1, i64 } @llvm.amdgcn.else(i64 %11)
; IR:   %13 = extractvalue { i1, i64 } %12, 0
; IR:   %14 = extractvalue { i1, i64 } %12, 1
; IR:   br i1 %13, label %bb16, label %Flow2

; IR: bb16:
; IR:   %tmp17 = bitcast i64 %tmp3 to <2 x i32>
; IR:   br label %bb18

; IR: Flow2:
; IR:   %loop.phi = phi i64 [ %21, %bb21 ], [ %phi.broken, %Flow1 ]
; IR:   %15 = phi <4 x i32> [ %tmp9, %bb21 ], [ undef, %Flow1 ]
; IR:   %16 = phi i32 [ %tmp10, %bb21 ], [ undef, %Flow1 ]
; IR:   %17 = phi i1 [ %20, %bb21 ], [ false, %Flow1 ]
; IR:   %18 = call i64 @llvm.amdgcn.else.break(i64 %14, i64 %loop.phi)
; IR:   call void @llvm.amdgcn.end.cf(i64 %14)
; IR:   %19 = call i1 @llvm.amdgcn.loop(i64 %18)
; IR:   br i1 %19, label %Flow3, label %bb14

; IR: bb18:
; IR:   %tmp19 = load volatile i32, i32 addrspace(1)* undef
; IR:   %tmp20 = icmp slt i32 %tmp19, 9
; IR:   br i1 %tmp20, label %bb21, label %bb18

; IR: bb21:
; IR:   %tmp22 = extractelement <2 x i32> %tmp17, i64 1
; IR:   %tmp23 = lshr i32 %tmp22, 16
; IR:   %tmp24 = select i1 undef, i32 undef, i32 %tmp23
; IR:   %tmp25 = uitofp i32 %tmp24 to float
; IR:   %tmp26 = fmul float %tmp25, 0x3EF0001000000000
; IR:   %tmp27 = fsub float %tmp26, undef
; IR:   %tmp28 = fcmp olt float %tmp27, 5.000000e-01
; IR:   %tmp29 = select i1 %tmp28, i64 1, i64 2
; IR:   %tmp30 = extractelement <4 x i32> %tmp936, i64 %tmp29
; IR:   %tmp7 = zext i32 %tmp30 to i64
; IR:   %tmp8 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* undef, i64 %tmp7
; IR:   %tmp9 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp8, align 16
; IR:   %tmp10 = extractelement <4 x i32> %tmp9, i64 0
; IR:   %tmp11 = load volatile i32, i32 addrspace(1)* undef
; IR:   %tmp12 = icmp slt i32 %tmp11, 9
; IR:   %20 = xor i1 %tmp12, true
; IR:   %21 = call i64 @llvm.amdgcn.if.break(i1 %20, i64 %phi.broken)
; IR:   br label %Flow2

; IR: bb31.loopexit:
; IR:   br label %Flow1

; IR: bb31:
; IR:   call void @llvm.amdgcn.end.cf(i64 %7)
; IR:   store volatile i32 0, i32 addrspace(1)* undef
; IR:   ret void


; GCN-LABEL: {{^}}nested_loop_conditions:

; GCN: v_cmp_lt_i32_e32 vcc, 8, v
; GCN: s_and_b64 vcc, exec, vcc
; GCN: s_cbranch_vccnz [[BB31:BB[0-9]+_[0-9]+]]

; GCN: [[BB14:BB[0-9]+_[0-9]+]]: ; %bb14
; GCN: v_cmp_ne_u32_e32 vcc, 1, v
; GCN-NEXT: s_and_b64 vcc, exec, vcc
; GCN-NEXT: s_cbranch_vccnz [[BB31]]

; GCN: [[BB18:BB[0-9]+_[0-9]+]]: ; %bb18
; GCN: buffer_load_dword
; GCN: v_cmp_lt_i32_e32 vcc, 8, v
; GCN-NEXT: s_and_b64 vcc, exec, vcc
; GCN-NEXT: s_cbranch_vccnz [[BB18]]

; GCN: buffer_load_dword
; GCN: buffer_load_dword
; GCN: v_cmp_gt_i32_e32 vcc, 9
; GCN-NEXT: s_and_b64 vcc, exec, vcc
; GCN-NEXT: s_cbranch_vccnz [[BB14]]

; GCN: [[BB31]]:
; GCN: buffer_store_dword
; GCN: s_endpgm
define amdgpu_kernel void @nested_loop_conditions(i64 addrspace(1)* nocapture %arg) #0 {
bb:
  %tmp = tail call i32 @llvm.amdgcn.workitem.id.x() #1
  %tmp1 = zext i32 %tmp to i64
  %tmp2 = getelementptr inbounds i64, i64 addrspace(1)* %arg, i64 %tmp1
  %tmp3 = load i64, i64 addrspace(1)* %tmp2, align 16
  %tmp932 = load <4 x i32>, <4 x i32> addrspace(1)* undef, align 16
  %tmp1033 = extractelement <4 x i32> %tmp932, i64 0
  %tmp1134 = load volatile i32, i32 addrspace(1)* undef
  %tmp1235 = icmp slt i32 %tmp1134, 9
  br i1 %tmp1235, label %bb14.lr.ph, label %bb13

bb14.lr.ph:                                       ; preds = %bb
  br label %bb14

bb4.bb13_crit_edge:                               ; preds = %bb21
  br label %bb13

bb13:                                             ; preds = %bb4.bb13_crit_edge, %bb
  br label %bb31

bb14:                                             ; preds = %bb21, %bb14.lr.ph
  %tmp1037 = phi i32 [ %tmp1033, %bb14.lr.ph ], [ %tmp10, %bb21 ]
  %tmp936 = phi <4 x i32> [ %tmp932, %bb14.lr.ph ], [ %tmp9, %bb21 ]
  %tmp15 = icmp eq i32 %tmp1037, 1
  br i1 %tmp15, label %bb16, label %bb31.loopexit

bb16:                                             ; preds = %bb14
  %tmp17 = bitcast i64 %tmp3 to <2 x i32>
  br label %bb18

bb18:                                             ; preds = %bb18, %bb16
  %tmp19 = load volatile i32, i32 addrspace(1)* undef
  %tmp20 = icmp slt i32 %tmp19, 9
  br i1 %tmp20, label %bb21, label %bb18

bb21:                                             ; preds = %bb18
  %tmp22 = extractelement <2 x i32> %tmp17, i64 1
  %tmp23 = lshr i32 %tmp22, 16
  %tmp24 = select i1 undef, i32 undef, i32 %tmp23
  %tmp25 = uitofp i32 %tmp24 to float
  %tmp26 = fmul float %tmp25, 0x3EF0001000000000
  %tmp27 = fsub float %tmp26, undef
  %tmp28 = fcmp olt float %tmp27, 5.000000e-01
  %tmp29 = select i1 %tmp28, i64 1, i64 2
  %tmp30 = extractelement <4 x i32> %tmp936, i64 %tmp29
  %tmp7 = zext i32 %tmp30 to i64
  %tmp8 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* undef, i64 %tmp7
  %tmp9 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp8, align 16
  %tmp10 = extractelement <4 x i32> %tmp9, i64 0
  %tmp11 = load volatile i32, i32 addrspace(1)* undef
  %tmp12 = icmp slt i32 %tmp11, 9
  br i1 %tmp12, label %bb14, label %bb4.bb13_crit_edge

bb31.loopexit:                                    ; preds = %bb14
  br label %bb31

bb31:                                             ; preds = %bb31.loopexit, %bb13
  store volatile i32 0, i32 addrspace(1)* undef
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
