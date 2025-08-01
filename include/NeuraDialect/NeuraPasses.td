// NeuraPasses.td - Passes for the Neura dialect

#ifndef NEURA_PASSES_TD
#define NEURA_PASSES_TD

include "mlir/Pass/PassBase.td"

//=========================================================//
// Passes for the Neura dialect
//=========================================================//
def AssignAccelerator : Pass<"assign-accelerator", "ModuleOp"> {
  let summary = "Assigns accelerators to operations in the Neura dialect";
  let description = [{Tags non - main functions as neura.kernel.}];
  let constructor = "neura::createAssignAcceleratorPass()";
}

def FusePatterns : Pass<"fuse-patterns", "ModuleOp"> {
  let summary = "Fuses patterns in the Neura dialect";
  let description = [{Apply Neura fusion patterns.}];
  let constructor = "neura::createFusePatternsPass()";
}

def InsertDataMov : Pass<"insert-data-mov", "ModuleOp"> {
  let summary = "Inserts data move operations in the Neura dialect";
  let description =
      [{Insert neura.data_mov before all neura dialect operations.}];
  let constructor = "neura::createInsertDataMovPass()";
}

def InsertCtrlMov : Pass<"insert-ctrl-mov", "ModuleOp"> {
  let summary = "Inserts ctrl move operations in the Neura dialect";
  let description =
      [{Insert neura.ctrl_mov before all neura dialect operations.}];
  let constructor = "neura::createInsertCtrlMovPass()";
}

def TransformCtrlToDataFlow : Pass<"transform-ctrl-to-data-flow", "ModuleOp"> {
  let summary = "Inserts ctrl move operations in the Neura dialect";
  let description =
      [{Transform ctrl to predicate-based data flow.}];
  let constructor = "neura::createTransformCtrlToDataFlowPass()";
}

def LeveragePredicatedValue : Pass<"leverage-predicated-value", "ModuleOp"> {
  let summary = "Convert values to predicated values in Neura dialect";
  let description = [{
    This pass converts regular values to predicated values in Neura dialect operations.
    Each value is wrapped in a predicated value type with a default true predicate.
  }];
  let constructor = "neura::createLeveragePredicatedValuePass()";
}

def MapToAccelerator : Pass<"map-to-accelerator", "ModuleOp"> {
  let summary = "Map Neura operations onto a given accelerator";
  let description = [{
    This pass performs mapping from Neura operations to accelerator.
  }];
  let constructor = "neura::createMapToAcceleratorPass()";
}

def GenerateCode : Pass<"generate-code", "ModuleOp"> {
  let summary = "Generate JSON-formatted instructions from mapped Neura IR";
  let description = [{
    This pass generates JSON file containing the instructions.
    The instructions can be encoded into configuration signals.
  }];
  let constructor = "neura::createGenerateCodePass()";
}

#endif // NEURA_PASSES_TD