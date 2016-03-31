module vml

if typeof(Pkg.installed("VML")) != Void
    eval(parse("import VML"))

    #= This is used to map Vectorize names to VML names. Each
    tuple consists of the Vectorize name and the VML name i.e.
    (:vadd, :add). This allows VML functions to be called via
    Vectorize.vml.vadd which allows the same function name to be
    used to access Accelerate, VML or Yeppp. =#

    mappings = Dict{Symbol, Symbol}(:acos => :acos, :asin => :asin, :atan => :atan,
                                    :cos => :cos, :sin => :sin, :tan => :tan, :acosh => :acosh,
                                    :asinh => :asinh, :atanh => :atanh,  :cosh => :cosh, :sinh => :sinh,
                                    :tanh => :tanh,  :sqrt => :sqrt, :exp => :exp, :log => :log,
                                    :log10 => :log10,  :log1p => :log1p,  :abs => :abs,  :abs2 => :abs2,
                                    :ceil => :ceil, :floor => :floor,  :round => :round, :trunc => :trunc)

    for f in keys(mappings)
        @eval $f = VML.$(mappings[f])
    end

else
    mappings = Dict{Symbol, Symbol}()
end


"""
Checks whether a given Vectorize function name `symbol` has a
corresponding VML implementation.

*Returns:* **Bool**
"""
function isavailable(fn::Symbol)
    haskey(mappings, fn)
end

end
