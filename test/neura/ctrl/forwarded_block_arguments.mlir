// RUN: mlir-neura-opt %s --transform-ctrl-to-data-flow | FileCheck %s

// The merge is followed by multiple forwarding blocks. Their arguments must
// resolve to the merge phi before the CFG blocks are erased.
func.func @forwarded_arguments(%condition: i1, %lhs: i32, %rhs: i32) {
  neura.kernel inputs(%condition, %lhs, %rhs : i1, i32, i32) attributes {accelerator = "neura"} {
  ^bb0(%cond: !neura.data<i1, i1>, %a: !neura.data<i32, i1>, %b: !neura.data<i32, i1>):
    %c = "neura.constant"() <{value = "%input0"}> : () -> !neura.data<i1, i1>
    %x = "neura.constant"() <{value = "%input1"}> : () -> !neura.data<i32, i1>
    %y = "neura.constant"() <{value = "%input2"}> : () -> !neura.data<i32, i1>
    neura.cond_br %c : !neura.data<i1, i1>
      then %x : !neura.data<i32, i1> to ^merge
      else %y : !neura.data<i32, i1> to ^merge
  ^merge(%value: !neura.data<i32, i1>):
    neura.br %value : !neura.data<i32, i1> to ^forward
  ^forward(%next: !neura.data<i32, i1>):
    neura.br %next : !neura.data<i32, i1> to ^exit
  ^exit(%result: !neura.data<i32, i1>):
    "neura.return"(%result) {return_type = "value"} : (!neura.data<i32, i1>) -> ()
  }
  return
}

// CHECK-LABEL: func.func @forwarded_arguments
// CHECK: %[[PHI:.*]] = "neura.phi"
// CHECK-NOT: neura.br
// CHECK-NOT: ^bb
// CHECK: neura.return_value %[[PHI]]
// CHECK: neura.yield
