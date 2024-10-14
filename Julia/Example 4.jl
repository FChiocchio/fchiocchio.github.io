""" 

Example 4: Scope of variables 

What you type in the script on in the repl outside of function is a global variable! 

"""
using Random
using BenchmarkTools
Random.seed!(123)
Dim = 1000
@allocated globvariable = rand(Dim ,Dim)
@isdefined(globvariable)

# global variable can enter loops or functions 
@btime begin
    for j = 1:Dim, i = 1:Dim
        globvariable[i,j] = i + j + globvariable[i,j]
    end
end

function fun_glob(x)
    x + Dim
end

@show fun_glob(5)
# Global can be very slow as we have seen previously! 
# Run this in MATLAB! EVEN faster

"""
Matlab code: 
    N = 100000000; 
    j = 0;
    tic
        for i = 1:N
            j = j + i;
        end
    toc
"""
const N = 100000000;

@time begin
    global j = 0;
    for i in 1:N
        global j += i; 
    end
end 
println("Value is $j")

# Constants can make the code sligly faster. 
# For instance, if you input your parameters as constant, then you will not suffer a lot of performance loss when you use them in functions
# But it can be hard to debug and changing the code! 

const Dim_cons = 1000

@btime begin
    for j = 1:Dim_cons, i = 1:Dim_cons
        globvariable[i,j] = i + j + globvariable[i,j]
    end
end

# But the gains of using a constant depend on where you use it! 
@btime begin
    for j = 1:Dim_cons, i = 1:Dim_cons
        globvariable[i,j] = i + j + globvariable[i,j] + Dim_cons
    end
end

@btime begin
    for j = 1:Dim, i = 1:Dim
        globvariable[i,j] = i + j + globvariable[i,j] + Dim
    end
end



# Same loop as before but in a local environment Loop with r local 
# let blocks are similar to begin blocks, but everything inside is local! 
@time begin
    let 
        local r = 0 
        for i in 1:N
            r += i; 
        end
        global hello = r
    end
end 
println("Value is $hello")

@isdefined(r)
@isdefined(hello)


# #####################################
# # While
# #####################################


""" 
Matlab codes 
    s= 1;
    t = 0;
    while s < 10
        t = t + 1/s;
        s = s + 1;
    end 

    variable t will exist also later! 
    in Julia it is not the case!!!!
"""

s = 1;
t = 0
while s < 10
    println("$s")
    t = t + 1/s
    s = s+1;
end 
println(t)

#####################################
# While with Iteration 
#####################################

# Define a distance function 
function my_function(δ,α)
    dist = abs(δ-α) 
    return dist
end 

# Run the while loop 
s=1; 
iter = 1;
while s > 0.1   
    new_iter = iter + ( 1 /iter)  
    s = my_function(iter,new_iter)
    println("The distance is  $(round(s,digits = 3)). The value of iter is  $(round(iter,digits = 2))")
    iter = new_iter
end