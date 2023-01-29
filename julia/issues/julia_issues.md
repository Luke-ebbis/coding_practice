# Problems with code optimisation

The fact that R and python are quicker than julia.

# Unresolved errors

## Matrix dimension error

```
julia> a
2×3 Array{Int64,2}:
 3  3  3
 3  3  3
julia> A = Array{Float64,2}(undef, 2, 3) 
2×3 Array{Float64,2}:
 6.91961e-310  6.91961e-310  6.91961e-310
 6.91961e-310  6.91961e-310  6.91961e-310
julia> a * A
ERROR: DimensionMismatch("matrix A has dimensions (2,3), matrix B has dimensions (2,2)")
Stacktrace:
 [1] _generic_matmatmul!(::Array{Int64,2}, ::Char, ::Char, ::Array{Int64,2}, ::Array{Int64,2}, ::LinearAlgebra.MulAddMul{true,true,Bool,Bool}) at /build/julia-98cBbp/julia-1.4.1+dfsg/usr/share/julia/stdlib/v1.4/LinearAlgebra/src/matmul.jl:736
 [2] generic_matmatmul!(::Array{Int64,2}, ::Char, ::Char, ::Array{Int64,2}, ::Array{Int64,2}, ::LinearAlgebra.MulAddMul{true,true,Bool,Bool}) at /build/julia-98cBbp/julia-1.4.1+dfsg/usr/share/julia/stdlib/v1.4/LinearAlgebra/src/matmul.jl:724
 [3] mul! at /build/julia-98cBbp/julia-1.4.1+dfsg/usr/share/julia/stdlib/v1.4/LinearAlgebra/src/matmul.jl:235 [inlined]
 [4] mul! at /build/julia-98cBbp/julia-1.4.1+dfsg/usr/share/julia/stdlib/v1.4/LinearAlgebra/src/matmul.jl:208 [inlined]
 [5] *(::Array{Int64,2}, ::Array{Int64,2}) at /build/julia-98cBbp/julia-1.4.1+dfsg/usr/share/julia/stdlib/v1.4/LinearAlgebra/src/matmul.jl:153
 [6] top-level scope at REPL[51]:1

```
