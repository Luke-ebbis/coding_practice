#! /usr/bin/env julia
#=Commandline implementation of the hypergeometric test for GO analysis
usage
    usage Comand line usage is as follows.
    hypergeometric_function.jl
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
    @param bound::String A string of either "upper" or "lower" indicating which
     side of the distribution is to be summed.
    @depends hypergeometric.
    =#

    if bound == "lower"
        # calculate the lower bound
        p_value = 0 
        for i in 0:x
            # calculate
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
    else
        throw("error: $bound is not an option for bound. " *
              "Please select upper or lower")
   end 
   return p_value
end

function main()
    #= The main procedure
    :return: To standard out.
    =#
    # print(binomial(100, 20))
    print(hypergeometric_test(5, 20, 30, 100, bound="lower"), "\n")
    print(hypergeometric_test(5, 20, 30, 100, bound="upper"))

    # if length(ARGS) != 4
    #     println("usage: $PROGRAM_FILE  <n> <k> \n"*
    #             "n \t The number of generations. \n"*
    #             "k \t The breeding rate of the recursive rabbits.")
    #     exit(1)
    # end

    # input_strings = ARGS
    # n, k = map((x) -> parse(Int, x), input_strings)

    # population = recursive_rabbits_population(n = n, k = k)
    # println(population)
    # exit(0)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
