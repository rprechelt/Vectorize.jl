module yeppp

if typeof(Pkg.installed("Yeppp")) != Void
    eval(parse("import Yeppp"))

    #= This is used to map Vectorize names to Yeppp names. Each
    tuple consists of the Vectorize name and the Yeppp name i.e.
    (:vadd, :add). This allows Yeppp functions to be called via
    Vectorize.yeppp.vadd which allows the same function name to be
    used to access Accelerate, VML or Yeppp. =#

    mappings = Dict{Symbol, Symbol}(:vadd => :add, :vsub => :subtract,
                                    :vmul => :multiply, :max => :max,
                                    :min => :min,  :log => :log, :exp => :exp,
                                    :sin => :sin, :cos => :cos, :tan => :tan,
                                    :sum => :sum, :sumabs => :sumabs, :sumsqr => :sumabs2)

    for f in keys(mappings)
        @eval $f = Yeppp.$(mappings[f])
    end

else
    mappings = Dict{Symbol, Symbol}()
end

"""
Checks whether a given Vectorize function name `symbol` has a
corresponding Yeppp implementation.

*Returns:* **Bool**
"""
function isavailable(fn::Symbol)
    haskey(mappings, fn)
end

end
