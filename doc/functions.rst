Functions
==========

.. function:: sin(X)

	      Computes the element-wise sine of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: sin!(result, X)

	      Computes the element-wise sine of a vector and stores it in result::

		VML(result::Array{Float32}, X::Array{Float32})
		VML(result::Array{Float64}, X::Array{Float64})
		VML(result::Array{Float32}, X::Array{Complex{Float32}})
		VML(result::Array{Float64}, X::Array{Complex{Float64}})
		Yeppp(result::Array{Float64}, X::Array{Float64})
		Accelerate(result::Array{Float32}, X::Array{Float32})
		Accelerate(result::Array{Float64}, X::Array{Float64})


.. function:: cos(X)

	      Computes the element-wise cosine of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: cos!(result, X)

	      Computes the element-wise cosine of a vector and stores it in result::

		VML(result::Array{Float32}, X::Array{Float32})
		VML(result::Array{Float64}, X::Array{Float64})
		VML(result::Array{Complex{Float32}}}, X::Array{Complex{Float32}})
		VML(result::Array{Complex{Float64}}}, X::Array{Complex{Float64}})
		Yeppp(result::Array{Float64}, X::Array{Float64})
		Accelerate(result::Array{Float32}, X::Array{Float32})
		Accelerate(result::Array{Float64}, X::Array{Float64})

.. function:: tan(X)

	      Computes the element-wise tangent of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: tan!(result, X)

	      Computes the element-wise tangent of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})


.. function:: asin(X)

	      Computes the element-wise inverse sine of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: asin!(result, X)

	      Computes the element-wise inverse sine of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})



.. function:: acos(X)

	      Computes the element-wise inverse cosine of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: acos!(result, X)

	      Computes the element-wise inverse cosine of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: atan(X)

	      Computes the element-wise inverse tangent of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: atan!(result, X)

	      Computes the element-wise inverse tangent of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: sinh(X)

	      Computes the element-wise hyperbolic sine of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: sinh!(result, X)

	      Computes the element-wise hyperbolic sine of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: cosh(X)

	      Computes the element-wise hyperbolic cosine of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: cosh!(result, X)

	      Computes the element-wise cosine of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: tanh(X)

	      Computes the element-wise hyperbolic tangent of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: tanh!(result, X)

	      Computes the element-wise hyperbolic tangent of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: asinh(X)

	      Computes the element-wise inverse hyperbolic sine of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: asinh!(result, X)

	      Computes the element-wise inverse hyperbolic sine of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: acosh(X)

	      Computes the element-wise inverse hyperbolic cosine of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: acosh!(result, X)

	      Computes the element-wise inverse hyperbolic cosine of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: atanh(X)

	      Computes the element-wise inverse hyperbolic tangent of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float64})

.. function:: atanh!(result, X)

	      Computes the element-wise inverse hyperbolic tangent of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})


.. function:: sinpi(X)

	      Computes the element-wise sine of `pi` times a vector::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: sinpi!(result, X)

	      Computes the element-wise sine of `pi` times a vector and stores it in result::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})


.. function:: cospi(X)

	      Computes the element-wise cosine of `pi` times a vector::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: cospi!(result, X)

	      Computes the element-wise cosine of `pi` times a vector and stores it in result::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: tanpi(X)

	      Computes the element-wise tangent of `pi` times a vector::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: tanpi!(result, X)

	      Computes the element-wise tangent of `pi` times a vector and stores it in result::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: atan2(X, Y)

	      Computes the element-wise arctangent two vectors::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})

.. function:: atan2!(result, X, Y)

	      Computes the element-wise arctangent two vectors and stores it in result::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})

.. function:: log(X)

	      Computes the element-wise logarithm of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: log!(result, X)

	      Computes the element-wise logarithm of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})


.. function:: log10(X)

	      Computes the element-wise logarithm to base-10 of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: log10!(result, X)

	      Computes the element-wise logarithm to base-10 of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: log1p(X)

	      Computes the element-wise natural logarithm to one plus a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: log1p!(result, X)

	      Computes the element-wise natural logarithm of one plus a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})


.. function:: log2(X)

	      Computes the element-wise logarithm to base-2 of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: log2!(result, X)

	      Computes the element-wise logarithm to base-2 of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: exp(X)

	      Computes the element-wise base-e exponent of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: exp!(result, X)

	      Computes the element-wise base-e exponent of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: exp2(X)

	      Computes the element-wise base-2 exponent of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: exp2!(result, X)

	      Computes the element-wise base-2 exponent of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: expm1(X)

	      Computes the element-wise natural exponent of a vector minus one::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: expm1!(result, X)

	      Computes the element-wise natural exponent of a vector minus one and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: pow(X, Y)

	      Calculates a vector raised element-wise to the power of another vector, or to a scalar::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		VML(X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		VML(X::Array{Float32}, Y::Float32)
		VML(X::Array{Float64}, Y::Float64)
		VML(X::Array{Complex{Float32}}, Y::Complex{Float32})
		VML(X::Array{Complex{Float64}}, Y::Complex{Float64})

.. function:: pow!(result, X, Y)

	      Calculates a vector raised element-wise to the power of another vector and stores it in result::

		VML(result::Array{Float32}, X::Array{Float32}, Y::Array{Float32})
		VML(result::Array{Float64}, X::Array{Float64}, Y::Array{Float64})
		VML(result::Array{Complex{Float32}}, X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(result::Array{Complex{Float64}}, X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		VML(result::Array{Float32}, X::Array{Float32}, Y::Float32)
		VML(result::Array{Float64}, X::Array{Float64}, Y::Float64)
		VML(result::Array{Complex{Float32}}, X::Array{Complex{Float32}}, Y::Complex{Float32})
		VML(result::Array{Complex{Float64}}, X::Array{Complex{Float64}}, Y::Complex{Float64})

.. function:: pow2o3(X)

	      Raises each element of a vector to the `2/3` power::

		VML(X::Array{Float32})
		VML(X::Array{Float64})

.. function:: pow2o3!(result, X)

	      Raises each element of a vector to the `2/3` power stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})

.. function:: pow3o2(X)

	      Raises each element of a vector to the `3/3` power::

		VML(X::Array{Float32})
		VML(X::Array{Float64})

.. function:: pow3o2!(result, X)

	      Raises each element of a vector to the `3/2` power stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})

.. function:: exponent(X)

	      Computes the element-wise exponent of a vector::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: exponent!(result, X)

	      Computes element-wise exponent of a vector and stores it in result::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: sqrt(X)

	      Computes the element-wise square root of a vector minus one::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: sqrt!(result, X)

	      Computes the element-wise square root of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Yeppp(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: invsqrt(X)

	      Computes the element-wise square root of a vector minus one::

		VML(X::Array{Float32})
		VML(X::Array{Float64})

.. function:: invsqrt!(result, X)

	      Computes the element-wise square root of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})

.. function:: invsqrt(X)

	      Computes the element-wise square root of a vector minus one::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})

.. function:: invsqrt!(result, X)

	      Computes the element-wise square root of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})

.. function:: add(X, Y)

	      Computes the element-wise addition two vectors::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		VML(X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		Yeppp(X::Int8, Y::Int8)
		Yeppp(X::UInt8, Y::UInt8)
		Yeppp(X::Int16, Y::Int16)
		Yeppp(X::UInt16, Y::UInt16)
		Yeppp(X::Int32, Y::Int32)
		Yeppp(X::UInt32, Y::UInt32)
		Yeppp(X::Int64, Y::Int64)
		Yeppp(X::Array{Float32}, Y::Array{Float32})
		Yeppp(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})

.. function:: add!(result, X, Y)

	      Computes the element-wise addition of two vectors and stores it in result::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		VML(X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		Yeppp(X::Int8, Y::Int8)
		Yeppp(X::UInt8, Y::UInt8)
		Yeppp(X::Int16, Y::Int16)
		Yeppp(X::UInt16, Y::UInt16)
		Yeppp(X::Int32, Y::Int32)
		Yeppp(X::UInt32, Y::UInt32)
		Yeppp(X::Int64, Y::Int64)
		Yeppp(X::Array{Float32}, Y::Array{Float32})
		Yeppp(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})


.. function:: sub(X, Y)

	      Computes the element-wise subtraction two vectors::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		VML(X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		Yeppp(X::Int8, Y::Int8)
		Yeppp(X::UInt8, Y::UInt8)
		Yeppp(X::Int16, Y::Int16)
		Yeppp(X::UInt16, Y::UInt16)
		Yeppp(X::Int32, Y::Int32)
		Yeppp(X::UInt32, Y::UInt32)
		Yeppp(X::Int64, Y::Int64)
		Yeppp(X::Array{Float32}, Y::Array{Float32})
		Yeppp(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})

.. function:: sub!(result, X, Y)

	      Computes the element-wise subtraction of two vectors and stores it in result::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		VML(X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		Yeppp(X::Int8, Y::Int8)
		Yeppp(X::UInt8, Y::UInt8)
		Yeppp(X::Int16, Y::Int16)
		Yeppp(X::UInt16, Y::UInt16)
		Yeppp(X::Int32, Y::Int32)
		Yeppp(X::UInt32, Y::UInt32)
		Yeppp(X::Int64, Y::Int64)
		Yeppp(X::Array{Float32}, Y::Array{Float32})
		Yeppp(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})


.. function:: mul(X, Y)

	      Computes the element-wise multiplication two vectors::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		VML(X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		Yeppp(X::Int8, Y::Int8)
		Yeppp(X::UInt8, Y::UInt8)
		Yeppp(X::Int16, Y::Int16)
		Yeppp(X::UInt16, Y::UInt16)
		Yeppp(X::Int32, Y::Int32)
		Yeppp(X::UInt32, Y::UInt32)
		Yeppp(X::Int64, Y::Int64)
		Yeppp(X::Array{Float32}, Y::Array{Float32})
		Yeppp(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})

.. function:: mul!(result, X, Y)

	      Computes the element-wise multiplication of two vectors and stores it in result::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		VML(X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		Yeppp(X::Int8, Y::Int8)
		Yeppp(X::UInt8, Y::UInt8)
		Yeppp(X::Int16, Y::Int16)
		Yeppp(X::UInt16, Y::UInt16)
		Yeppp(X::Int32, Y::Int32)
		Yeppp(X::UInt32, Y::UInt32)
		Yeppp(X::Int64, Y::Int64)
		Yeppp(X::Array{Float32}, Y::Array{Float32})
		Yeppp(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})


.. function:: div(X, Y)

	      Computes the element-wise division two vectors::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		VML(X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})

.. function:: div!(result, X, Y)

	      Computes the element-wise division of two vectors and stores it in result::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		VML(X::Array{Complex{Float32}}, Y::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}}, Y::Array{Complex{Float64}})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})

.. function:: abs(X)

	      Computes the element-wise absolute value of a vector::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: abs!(result, X)

	      Computes the element-wise absolute value of a vector and stores it in result::

		VML(X::Array{Float32})
		VML(X::Array{Float64})
		VML(X::Array{Complex{Float32}})
		VML(X::Array{Complex{Float64}})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: max(X, Y)

	      Computes the element-wise maximum value of two vectors::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})
		Yeppp(X::Array{Float64}, Y::Array{Float64})

.. function:: max!(result, X, Y)

	      Computes the element-wise maximum value of two vectors and stores it in result::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})
	      	Yeppp(X::Array{Float64}, Y::Array{Float64})

.. function:: min(X, Y)

	      Computes the element-wise minimum value of two vectors::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})
		Yeppp(X::Array{Float64}, Y::Array{Float64})

.. function:: min!(result, X, Y)

	      Computes the element-wise minimum value of two vectors and stores it in result::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})
		Accelerate(X::Array{Float32}, Y::Array{Float32})
		Accelerate(X::Array{Float64}, Y::Array{Float64})
		Yeppp(X::Array{Float64}, Y::Array{Float64})


.. function:: maximum(X)

	      Returns the maximum value contained within a vector::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: mininum(X)

	      Returns the minimum value contained within a vector::

		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})



.. function:: hypot(X, Y)

	      Computes the element-wise hypotenuse of a triangle with sides given by two vectors::

		VML(X::Array{Float32}, Y::Array{Float32})
		VML(X::Array{Float64}, Y::Array{Float64})

.. function:: hypot!(result, X, Y)

	      Computes the element-wise hypotenuse of a triangle with sides given by two vectors and stores it in result::
		VML(result::Array{Float32}, X::Array{Float32}, Y::Array{Float32})
		VML(result::Array{Float64}, X::Array{Float64}, Y::Array{Float64})

.. function:: cis(X)
				Computes the element-wise cosine-imaginary-sin of the vector X
		VML(X::Array{Float32})
		VML(X::Array{Float64})
		Accelerate(X::Array{Float32})
		Accelerate(X::Array{Float64})

.. function:: cis!(result, X)
				Computes the element-wise cosine-imaginary-sin of the vector Xand stores it in results::
		VML(result::Array{Complex{Float32}}, X::Array{Float32})
		VML(result::Array{Complex{Float64}}, X::Array{Float64})
		Accelerate(result::Array{Complex{Float32}}, X::Array{Float32})
		Accelerate(result::Array{Complex{Float64}}, X::Array{Float64})
