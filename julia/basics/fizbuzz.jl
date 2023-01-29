# A fizzbuzz example for julia 
# Running times; sys; 425 ms, real 183 ms
for i in 1:1000
    if i % 15 == 0
        println("FizzBuzz")
    elseif i % 3 == 0
        println("Fizz")
    elseif i % 5 == 0
        println("Buzz")
    else
        println(i)
    end
end
error()
