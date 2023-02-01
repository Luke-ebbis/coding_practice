#! /usr/bin/env julia
#=Commandline implementation of the hypergeometric test for GO analysis
usage
    usage Comand line usage is as follows.
    hypergeometric_function.jl
=#

function factorial(;n::Real)
    #= Factorial function
    @param n::Real A real number for which the factorial must be determined.
    @return Real The factorial.
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

# function binomial(n::Real, k::Real)

# end

# function hypergeometric_test(X::Int, N::Int, M::Int, K::Int)

# end

function main()
    #= The main procedure
    :return: To standard out.
    =#
    print(factorial(n = 5))

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
