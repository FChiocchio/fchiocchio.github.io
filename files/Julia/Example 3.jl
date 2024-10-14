""" 

Example 3: Functions 

Examples taken or adapted from QuantEcon Lecture 1, 2, 3 and 4 and Joel Marbet's Lecture

"""

"""
# Part 1: Some examples of functions and how to create new ones

"""

# For and while loop! 

for i = 1:5 
    println("Francesco $i")
end

attributes= ["Nice", "Funny", "Wonderful", "lying"]
for x in attributes
    println("Francesco is $x")
end

countries = ("Japan", "Korea", "China")
cities = ("Tokyo", "Seoul", "Beijing")
for (country, city) in zip(countries, cities)
    println("The capital of $country is $city")
end

countries = ("Japan", "Korea", "China")
cities = ("Tokyo", "Seoul", "Beijing")
for (i, country) in enumerate(countries)
    city = cities[i]
    println("The capital of $country is $city")
end

####################################
# Exercise on loops, conditional statements and  
####################################
# What will be the output of this? 
# Does stringvar exist as a variable?
# Be careful of whiles, you simple mistake might lead you to never ending loop
# I like to use two conditions one on what I am interested in (ii in this case, or distance between Value Functions) and an maxIteration
ii = 0
iter = 0
while ii < 10 && iter < 100
    ii += 1
    iter = iter +1
    stringvar = "is Even"
	if ii == 3
		continue 
    elseif mod(ii,2) == 1
        stringvar = "is Odd"
	end
	if ii == 5
		break
	end
	println("$ii $stringvar")
end

# How do you name functions 
function myfirstfunction(A)
    return X = A^2
end

@show myfirstfunction(5)


####################################
# Exercise on functions variables. 
####################################
#What is happening here? Elaborate on the issue and what can be the problem of this when working in a large dataset?
# How do optional_1 and optional_2 solve this issue? What is the difference between them?
# What is another way that we have seen of solving this issue?
function secondfunction(A)
    return X = A^2 + Constant
end

@show secondfunction(5)
Constant = 5
@show secondfunction(5)

function optional_1(A,Constant = 2)
    return X = A^2 + Constant
end
function optional_2(A;Constant = 2)
    return X = A^2 + Constant
end
@show optional_1(5)
@show optional_1(5,3)
@show optional_2(5,Constant = 3)



# Returns 
function functionWithReturn(x)
	a = x^2
	b = x
	return a, b
end

function functionWithoutReturn(x)
	a = x^2
	b = x
end

@show functionWithReturn(5)
@show functionWithoutReturn(5)

a,b = functionWithReturn(5)
_, c =functionWithReturn(5)

# One liners and anonymous function
function square(x)
    x^2
end

@show map(square,[2,3,4])

square(a,b=2) = a^2+b
@show map(square,[2,3,4])

@show map( a -> a^2 ,[2,3,4])
@show map( a,b -> a^2 + b ,[2,3,4])
@show map( (a, b) -> a^2 + b ,(2,3,4),(2,2,2))



# Examples of useful functions for strings
s = "Charlie don't surf"
split(s)
replace(s, "surf" => "ski")
strip(" foobar ")

join(uppercasefirst.(split("How_are_you",'_')))
parse.(Int64,split("10 20 30"))
reduce(*,1:5)



"""
# Part 2: Broadcasting and Comprehensions

"""
xs = 1:10000
f(x) = x^2
f_x = f.(xs)
sum(f_x)

f_x2 = [f(x) for x in xs]
@show sum(f_x2)
@show sum([f(x) for x in xs]); # still allocates temporary

sum(f(x) for x in xs)

####################################
# Exercise on broadcasting and comprehensions
####################################
# What is the difference between all these codes? 
using BenchmarkTools
@btime sum([f(x) for x in $xs])
@btime sum(f.($xs))
@btime sum(f(x) for x in $xs);

"""
# Part 3: Some rules and multiple-dispatch

"""

#Famous example of in place functions
a = [1, 2, 3]
b = push!(a,1)
a = [ 1 2 3; 4 5 6]
b = push!(a,[1 1 1])
b = vcat(a,[1 1 1])


#import function (need to update my CD)
pwd()
cd("C:\\Users\\f-chio33\\Dropbox\\CEMFI\\Fourth Year\\QuantMacro Julia\\Julia 2022\\Codes")

include("Function_file.jl")

@show inadifferentfile_1(5)
@show inadifferentfile_2(5)

####################################
# Exercise of functions with types
####################################
# What does  this simple function do? 
# Why is there an error? 
# What does this hard function do? Why does it solve the error?
function simple_function(x,y)
    x* " " * y 
end

@show simple_function("hello", "Bue")
@show simple_function(123, "Bue")


function hard_function(x,y)
    a = isa(x,AbstractString) ? x : string(x)
    b = isa(y,AbstractString) ? y : string(y)

    a * " " * b 

end

@show hard_function("hello", "Bue")
@show hard_function(123, "Bue")

# Multiple Dispatch: Taken from here if you are more itnerested https://www.educative.io/answers/definition-multiple-dispatch
function concat_this(a::AbstractString, b::AbstractString)
    return a*" "*b
end

function concat_this(a::Real, b::AbstractString)
    return string(a)*" "*b
end

function concat_this(a::AbstractString, b::Real)
    return a*" "*string(b)
end

function concat_this(a::Real, b::Real)
    return string(a)*" "*string(b)
end

using BenchmarkTools
function main() 
    concat_this("abra", "kadabra")
    concat_this("123", "kadabra")
    concat_this("abra", 456)
    concat_this(123, 456)
end

function main2() 
    hard_function("abra", "kadabra")
    hard_function("123", "kadabra")
    hard_function("abra", 456)
    hard_function(123, 456)
end

# Similar times! This is not a representative problem, but the idea is to show that multiple dispatch is not slower! 
@btime main()
@btime main2()

# Encapsulating all the function 

const Ndim = 100000000;


# Code without function 

@time begin
    global j = 0;
    for i in 1:Ndim
        global j += i; 
    end
end 
println("Value is $j")

function main!(N)
    j = 0
    for i in 1:N
        j += i; 
    end
    println("Value is $j")
end

@time main!(Ndim)
@btime main!(Ndim) # Don t wanna do this, as in the output there is a print, and btime runs this function many times! 

# Everything is in local environment! Can be a lot faster! But why? What are the probelms? Does j exist? 