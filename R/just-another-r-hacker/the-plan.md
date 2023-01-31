# The plan to make a just another R hacker script

(golfing tips)[https://codegolf.stackexchange.com/questions/4024/tips-for-golfing-in-r]

Obtain a random string using:

```r
n<-1:20;
set.seed(n);
paste(letters[round((runif(n = 26, min = 0, max = 26)))], collapse="");
n

# generating random sequence
v <- runif(5e2,0, 128); intToUtf8(round(v))
v <- runif(5e2,0, 128); sapply(round(v), function(x) paste0("\\", x) |> print())
> print(paste0(bquote("\44")))

("19":1)[1] #Shorter version using force coercion.
paste(19) #Shorter version using force coercion.

x%/%1 # floor
seq(3.5) $ makes 1 2 3
get(ls(9)[501]) # same as getDLLRegisteredRoutines, see https://codegolf.stackexchange.com/a/90666/55516.
`%p%`=paste # works.


if(x)y else z # 13 bytes
ifelse(x,y,z) # 13 bytes
`if`(x,y,z)   # 11 bytes

if(x)"foo"else"bar"   # 19 bytes
ifelse(x,"foo","bar") # 21 bytes
`if`(x,"foo","bar")   # 19 bytes

if(x){z=f(y);a=g(y)}        # 20 bytes
ifelse(x,{z=f(y);a=g(y)},0) # 27 bytes
`if`(x,{z=f(y);a=g(y)})     # 23 bytes

sum(x <- 4, y <- 5) # You can assign a variable to the current environment while simultaneously supplying it as an argument to a function:
x
y

y <- if (a==1) 1 else 
     if (a==2) 2 else 3

while({some_code;condition})0

n=scan();(x=1:n)[abs(x-n/2)<4] # reads from stdin, creates a variable x=1:n, then indexes into x using that value of x. This can sometimes save bytes.

# using [:https://codegolf.stackexchange.com/a/185021/80010
```

Keep generating random numbers until you have the letters to generate the sentence 'just another r hacker' (1j 1u 1s 2t 4\_ 2a 1n 1o 2h 2e 2r 1k). All the letters that do not match this set you do not use. When 

Obfuscation with

<-; -> and assign() and =

Reduce(paste0,letters) for -5 bytes from paste0(letters,collapse="")

`\(arglist) expr`:
so use
```r
\(x,y)x+y
function(x,y)x+y
```

remove braces:

```r
cat('hello')

# can be written as
`+`=cat;+'hello'

```
