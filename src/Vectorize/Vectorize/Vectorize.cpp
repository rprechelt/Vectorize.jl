#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include <string>

using namespace llvm;

const std::string AccelerateFunctions[] = {
      // Floating-Point Arithmetic and Auxiliary Functions
        {"ceilf", "vceilf"},
        {"fabsf", "vfabsf"},
        {"llvm.fabs.f32", "vfabsf"},
        {"floorf", "vfloorf"},
        {"sqrtf", "vsqrtf"},
        {"llvm.sqrt.f32", "vsqrtf"},

        // Exponential and Logarithmic Functions
        {"expf", "vexpf"},
        {"llvm.exp.f32", "vexpf"},
        {"expm1f", "vexpm1f"},
        {"logf", "vlogf"},
        {"llvm.log.f32", "vlogf"},
        {"log1pf", "vlog1pf"},
        {"log10f", "vlog10f"},
        {"llvm.log10.f32", "vlog10f"},
        {"logbf", "vlogbf"},

        // Trigonometric Functions
        {"sinf", "vsinf"},
        {"llvm.sin.f32", "vsinf"},
        {"cosf", "vcosf"},
        {"llvm.cos.f32", "vcosf"},
        {"tanf", "vtanf"},
        {"asinf", "vasinf"},
        {"acosf", "vacosf"},
        {"atanf", "vatanf"},

        // Hyperbolic Functions
        {"sinhf", "vsinhf"},
        {"coshf", "vcoshf"},
        {"tanhf", "vtanhf"},
        {"asinhf", "vasinhf"},
        {"acoshf", "vacoshf"},
        {"atanhf", "vatanhf"},
};


namespace {
    struct Vectorize : public FunctionPass {
        static char ID;
        Vectorize() : FunctionPass(ID) {}

        bool runOnFunction(Function &F) override {
            errs() << "Vectorizing: ";
            errs().write_escaped(F.getName()) << "\n";
            return false;
        }
    };
}

// Register pass against LLVM
char Vectorize::ID = 0;
static RegisterPass<Vectorize> X("Vectorize",  "Vectorize.jl: Automatic Vectorization Pass",  false, false);


