""" 

Example 2: Variables and Types

Examples taken or adapted from QuantEcon Lecture 1, 2, 3 and 4 and Joel's Lecture

"""

"""
# Part 1: Create variables, check the type, basic calculations
Read Lecture 2 and Lecture 3 of QuantEcon

"""
# Julia convention: use all lower case for variables and functions
myinteger = 1
myfloat = 1.0 
mystring = "Hello"
mybool = false 

# Interesting names. Should you do them? Clarity of codes comes first! 
β = 0.95 # Useful to match with model of your paper, but can become annoying! \beta + tab
😄 = false # No idea why you should do this


# Check the type of your variable 
typeof(myinteger)
# Use the macro @show to see the expression to be evaluated and its result
@show typeof(myinteger)
@show typeof(mystring)
@show typeof(mybool)

# Mathematical operations - Like Matlab, Google if needed

# Comparisons and logical operators- like matlab - just make sure to NOT use bitwise comparison 
A = true 
B = false 
A || B
A && B 
comp = (A == B)
≈ # This should be used for floats, as sometimes == might not work due to precision errors



# More interesting aspects:
# Concatenation of strings
@show "Hello" * " " * "World"
# Concatenation of strings and integer using Broadcasting (talk about it later)
@show  mystring = "Section: " .* string.(1:1:3)
@show typeof(mystring)
# Interpolation of strings or variables
string_1 = "Francesco"
string_2 = "is the best"
@show string_inter = "$string_1 $string_2" 
@show "Who is the best = $(string_1 * " " * string_2)"

# Ranges 
x = 1:10 	# Numbers from 1 to 10
x = 10:-1:1 # Numbers from 10 to 1
x = range(1.1, stop=3, step=0.1)

# To create a grid variable (that is a vector) use collect
mygrid = collect(range(1.1, stop=3, step=0.1))


####################################
# Exercise on type stability: 
####################################

# What does this code do? 
# How do we check the type? 
# Why is this a problem? 

function f(x)
    if x > 0
        return 1.0
    else
        return 0  
    end
end

@show f(1)
@show f(-1);

####################################
# Exercise on Type nothing and ternary operator
####################################

# Check that the functions are the same
# What does this code do? 
# Why would we want to have nothing type

function f(x)
    if x > 0.0
        return sqrt(x)
    else
        return nothing
    end
end

function f_1(x)
    x > 0.0 ? sqrt(x) : nothing  
end

function f_2(x)
    @assert x > 0
    sqrt(x)
end


@show f(1.0)
@show f(-1.0);

# Benchmarking 
using BenchmarkTools

@btime map(f,[1,2])
@btime map(f_1,[1,2])
@btime map(f_2,[1,2])

"""
# Part 2: Arrays

Read Lecture 4 of QuantEcon

Array is a Parametric type: Array{Float64, 2}. The Parameters are Float64 (The concetre type of the data stored) and 2 (Number of dimensions)

"""

# Understanding arrays as vectors
# But note, many times we use arrays not as vectors! 
@show x = [1, 2, 3] 	# vector - 1 Dimensional Array
@show y = [1 2 3] 	# 1x3 matrix - 2 Dimensional Array
@show z = [1 2 3]' 	# 3x1 matrix - Transposed - 2 Dimensional Array
 
typeof(x)
@show typeof(y)
@show typeof(z)

@show  ndims(x)
@show  ndims(z)

x==z

#Some basic functions and  calculations
# There is all the section of Linear Algebra that I am omitting! 
@show a = y * x 
b = 14 
@show a == b

A = rand(3,3)
B = rand(3,3)
A \ B # For inverse use and not inv() function


a = [-1, 0, 1]
@show length(a)
@show sum(a)
@show mean(a)
@show std(a)      # standard deviation
@show var(a)      # variance
@show maximum(a)
@show minimum(a)
@show extrema(a) 

b = sort(a, rev = true)  # returns new array, original not modified
a = [10, 20, 30, 40]
b = reshape(a, 2, 2) 
a = [1 2 3 4] 
dropdims(a, dims = 1)

a = [10, 20, 30]
b = [-100, 0, 100]
a .== b # element wise operations like in Matlab with the . 


# Create matrices Manually, Functionally and from Exisiting! 
A = [10 20; 30 40] 
B = [1 0]
C = [false; true]

@show B * A * C

# Functionally
A = zeros(3)
ones(2, 2)
B = fill(5.0, 2, 2)

####################################
# Exercise type of A and B, and it s alias 
####################################

# Exisiting!
x = [1, 2, 3]
y = x
z = copy(x)
y[1] = 2

@show x
@show y
@show z

# Why? Exercise at the end! 

# If you want to initialize an array of the same type (even of differnt size)
s = similar(x)
@show s


# Indexing - similar to MatLab 
X = [1 2; 3 4]
@show X[1,2]
@show X[1,1:end]
@show X[3]


# Slicing and viewing 
# Slice: copy the sub-array to a new array with a similar type.
a = [1 2; 3 4]
b = a[:, 2]
@show b
a[:, 2] = [4, 5] # modify a
@show a
@show b;

# A view on the other hand does not copy the value
# Less number of allocation, can make code faster! 
# But maybe less clear! 
a = [1 2; 3 4]
@views b = a[:, 2]
@show b
a[:, 2] = [4, 5]
@show a
@show b;

# Special matrixes
using LinearAlgebra
d = [1.0, 2.0]
@show a = Diagonal(d)

b = [1.0 2.0; 3.0 4.0]
@show b - I 


####################################
# Exercise on binding: 
####################################
# This is very important! I wasted a lot of time because of this! 
# Play around with the x y z arrays. What changes what? 
# What happens if I try to copy by slicing? 

x = [1, 2, 3]
y = x
z = copy(x)
y[1] = 2



# The pointer function tells you the location of the variable. Use it to understand what is happening
pointer(x)
pointer(y)
pointer(z)

x === y  # tests if arrays are identical (i.e share same memory)




####################################
# Note on speed: Looping first on Columns then on row is faster 
# Taken from Jeol's 
####################################
function fastloop(X)
	for j = 1:size(X, 2), i = 1:size(X, 1)
  		X[i, j] = i + j
	end
end


function slowloop(X)
	for i = 1:size(X, 1), j = 1:size(X, 2)
		X[i, j] = i + j
	end
end

# using Pkg
# 
using BenchmarkTools

N = 100 # Note you might need to increase N to 1000 or more to see substantial differences
x = zeros(N, N)
A = fastloop(x)

A == B

@btime fastloop($x)
@btime slowloop($x)

"""
# Part 3: Tuples

Read QuantEcon Lecture 4 and 5

Tuples are a type of Containers (storing collection of data). Other types of containers are dictionary and structures. 
The latter are fairly similar for the way we will use them. 

Use Tuples to insert your parameters. 

"""

# Basic Tuples
x = ("foo", "bar")
y = ("foo", 2)


@show typeof(x), typeof(y) # different types



word, val = x
println("word = $word, val = $val")

@show x[1] 


# Named Tuples
using Parameters
using BenchmarkTools

myparameters = (beta = 0.94, sigma = 2)
@show myparameters.beta      # access by index

function utility(cons,parameters)
    @unpack beta, sigma = parameters  # good style, less sensitive to errors, unpack is part of Parameters package
    return beta * cons^(1-sigma)/(1-sigma)
end

utility(100.0,myparameters)


# Named Tuples with default variables 
# More similar to structures, in some sense, and for my understanding
# create a generator function 
myparameters = @with_kw (beta = 0.94, sigma = 2)

@show myparameters()  # calling without arguments gives all defaults
@show myparameters( beta = 0.2)
@show myparameters( beta = "hello")

myparams = myparameters() #
utility(100.0,myparameters)
@btime utility(100.0,myparameters())
@btime utility(100.0,myparams)
