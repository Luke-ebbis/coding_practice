#! /usr/bin/env julia
#=Commandline implementation of the hypergeometric test for GO analysis
usage
    usage Comand line usage is as follows.
    hypergeometric_function.jl
=#

function factorial(n::Int)
    #= Factorial function
    @param n::Real A real number for which the factorial must be determined.
    @return Real The factorial.
    TODO Make sure that this function can also function on a real array.
    Check whether the types make sense.
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
    @depends factorial()
    =#
    if ~(0 <= k <= n)
        throw("k must be between 0 and n (0 <= $k <= $n is false!)")
    end
    C = factorial(n) / (factorial(k) * factorial(n-k))
    return C
end

function hypergeometric(; x::Int, n::Int, M::Int, N::Int)
    #=Probability mass function
    @param x::Int Successes in the sample.
    @param n::Int Sample size.
    @param M::Int Number of successes in lot.
    @param N::Int Size of the lot.
    @depends binomial.
    =#
    P = (binomial(M, x) * binomial(N-M, n-x)) / (binomial(N, n)) 
    return P
end

# function hypergeometric_test(X::Int, N::Int, M::Int, K::Int)

# end

function main()
    #= The main procedure
    :return: To standard out.
    =#
    print(binomial(100, 20))
    print((binomial(30, 5) * binomial(10, 15)) / binomial(100, 20))
    # print(hypergeometric(x = 5, n = 20, M=30, N = 100))

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
