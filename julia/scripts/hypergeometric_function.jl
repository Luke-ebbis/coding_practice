#! /usr/bin/env julia
#= Commandline implementation of the hypergeometric test for GO analysis
usage
    usage Command line usage is as follows.
    hypergeometric_function.jl

TODO - add exact functionality.
     - Add explanation on how the hypergeometric test is derived.

theory
        The hyper geometric test determines whether there is a x enriched the
    given sample x. The formula below calculates the chance of obtaining
    exactly x successes out of a lot of N with M successes using a sample size of
    n. The denominator is the number of ways that a sample can be taken from a
    population with N members. The numerator consist of a product of two
    binomial values, the first being the number of ways a success can be
    selected, the second being the number of ways a failure is selected.

                        ⎛M⎞   ⎛N - M⎞
                        ⎜ ⎟ ⋅ ⎜     ⎟
                        ⎝x⎠   ⎝n - x⎠
        f(x, n, M, M) = ─────────────
                             ⎛N⎞     
                             ⎜ ⎟     
                             ⎝n⎠     
        with

        ⎛n⎞        n!      
        ⎜ ⎟ = ─────────────
        ⎝k⎠   k! ⋅ (n - k)!

=#

function _factorial(n)
    #= Factorial function
    @param n::Real A real number for which the factorial must be determined.
    @return Real The factorial.
    TODO Make sure that this function can also function on a real array.
    Check whether the types make sense. TODO implement a table lookup for small
    numbers. 
    =#
    if n == 0
        factorial_value = 1
    else
        factorial_value = 1
        for i in 1:n
            factorial_value *= i
        end
    end
    return factorial_value
end

function binomial(n::Int, k::Int)
    #= Determining the binomial coefficient.
    @param n::Int 
    @param k::Int
    @return Int The calculated binomial coefficient.
    @depends _factorial()
    =#
    if ~(0 <= k <= n)
        throw("k must be between 0 and n (0 <= $k <= $n is false!)")
    end
    C = _factorial(BigInt(n)) / 
     (_factorial(BigInt(k)) * _factorial(BigInt(n-k)))
    return C
end

function hypergeometric(x::Int, n::Int, M::Int, N::Int)
    #=Probability mass function
    @param x::Int Successes in the sample.
    @param n::Int Sample size.
    @param M::Int Number of successes in lot.
    @param N::Int Size of the lot.
    @depends binomial.
    =#
    f = (binomial(M, x) * binomial(N-M, n-x)) / (binomial(N, n)) 
    return f
end

function hypergeometric_test(x::Int, n::Int, M::Int, N::Int;
         bound::String="lower")
    #= Determine the p value of a hyper geometric distribution.
    @param x::Int Successes in the sample.
    @param n::Int Sample size.
    @param M::Int Number of successes in lot.
    @param N::Int Size of the lot.
    @param bound::String A string of either "upper", "lower" or exact. 
        Indicating which side of the distribution is to be summed.
    @depends hypergeometric.
    =#

    if bound == "lower"
        # calculate the lower bound
        p_value = 0 
        for i in 0:x
            p_value += hypergeometric(i, n, M, N)
        end
    elseif bound == "upper"
        # calculate the upper bound
        p_value = 0
        for i in x:M
            if n - i > 0
                p_value += hypergeometric(i, n, M, N)
            end
        end
    elseif bound == "exact"
            p_value = hypergeometric(x, n, M, N)
    else
        throw("error: $bound is not an option for bound. " *
              "Please select upper, lower or exact")
   end 
   return p_value
end

function main()
    #= The main procedure
    :return: To standard out.
    =#

    if length(ARGS) != 5
        println("usage: $PROGRAM_FILE  <x> <n> <M> <N> bound\n"*
                "x \t The number of sucesses in the sample. \n"*
                "n \t The sample size. \n" *
                "M \t The number of sucesses in lot\n" *
                "N \t The lot size\n"*
                "bound\t The bound for which the p value should be "*
                "determined.\n")
        exit(1)
    end

    bound = ARGS[5]
    x, n, M, N = map((x) -> parse(Int, x), ARGS[1:4])


    p_value =  hypergeometric_test(x, n, M, N, bound=bound)

    println(p_value)
    exit(0)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
