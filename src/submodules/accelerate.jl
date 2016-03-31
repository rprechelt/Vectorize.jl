module accelerate

if typeof(Pkg.installed("AppleAccelerate")) != Void
    eval(parse("import AppleAccelerate"))

    #= This is used to map Vectorize names to Accelerate names. Each
    tuple consists of the Vectorize name and the Accelerate name i.e.
    (:vadd, :add). This allows Accelerate functions to be called via
    Vectorize.accelerate.vadd which allows the same function name to be
    used to access Accelerate, VML or Yeppp. =#

    mappings = Dict{Symbol, Symbol}(:acos => :acos, :asin => :asin, :atan => :atan,
                                    :cos => :cos, :sin => :sin, :tan => :tan, :acosh => :acosh,
                                    :asinh => :asinh, :atanh => :atanh,  :cosh => :cosh, :sinh => :sinh,
                                    :tanh => :tanh,  :sqrt => :sqrt, :exp => :exp, :log => :log,
                                    :log10 => :log10,  :log1p => :log1p,  :abs => :abs,  :abs2 => :abs2,
                                    :ceil => :ceil, :floor => :floor,  :round => :round, :trunc => :trunc,
                                    :vadd => :vadd, :vsub => :vsub, :vmul => :vmul, :vdiv => :vdiv, :mean => :mean,
                                    :sum => :sum, :meanmag => :meanmag,  :meansqr => :meansqr, :minimum => :minimum,
                                    :maximum => :maximum, :findmin => :findmin, :findmax => :findmax)

    for f in keys(mappings)
        @eval $f = AppleAccelerate.$(mappings[f])
    end

else
    mappings = Dict{Symbol, Symbol}()
end


"""
Checks whether a given Vectorize function name `symbol` has a
corresponding Accelerate implementation.

*Returns:* **Bool**
"""
function isavailable(fn::Symbol)
    haskey(mappings, fn)
end

end
