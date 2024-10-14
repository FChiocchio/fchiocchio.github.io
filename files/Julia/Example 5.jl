""" 

Example 5: Debugging

Some tips!
"""

# Learn to read error
a = min(myarray)
# myarray not defined - obvious this far...

myarray = [1,3,4,4]

a = min(myarray)
# MethodError - an issue with Types! 
# no method matching min(::Vector{Int64}) -> min function does NOT accept an array
@show min(-5,0)
@show min(1,3,4,4)

# ?min ... Read See also the minimum function to take the minimum element from a collection.
# ?minimum .. Good

a = minimum(myarray)

# Or you could have asked on google: julia how to obtain minimum of array? Julia methoderror min(array)?


# press control c to end running 
# To be honest, sometimes it does not work, so try to always run while loops with some max iterations!
# You can always stop julia by pressing the bin button! but it iwll delete all your work 
for i = 1:1000000
    println("hello $i")
end

# Check for all cases 
# Named Tuples
using Parameters
using BenchmarkTools

myparameters = @with_kw (beta = 0.94, sigma = 2)
myparams = myparameters() #

function utility(cons,parameters)
    @unpack beta, sigma = parameters  # good style, less sensitive to errors, unpack is part of Parameters package
    return beta * (cons^(1-sigma))/(1-sigma)
end

# You might test the function once, and it works
@show utility(100.0,myparams)

#but then in your code, consumption can take very different values! 
utility(100,myparams) # Cannot raise an integer x to a negative power -1 - This is weird!!!

# This is a weird example, as the issue is quite strange! 

# I can do the following:
@show 100^(-1)
@show 100^(-2)

# But not these: 
@show 100^(1-2)
@show 100^(1-3)

# Or even if I create a new variable that is -1 it does not work! 
p = 1-2
-1 == p
@show 100^(p)
p = -1 
@show 100^(p)

# Where is the problem??? 
# This macro tells us the functions that are being used! 
@show @code_lowered 100^(-1)
@show @code_lowered 100^(p)



# Seems the same function no? Let us check the method (i.e. the functions for different arguments)
@show methods(Base.power_by_squaring)

# This is the function used! is the same...
@which 100^(-1)
@which 100^(p)

# This enables us to open a function 
@edit 100^(p)

# Useless for me 
@show @code_native 100^(-1)
@show @code_native 100^(p)

@show @code_llvm 100^(-1)
@show @code_llvm 100^(-2)
@show @code_llvm 100^(p)


# Why is there a problem with this function? 100 is Int, -1 is Integer...
# Around 2 hours of googling later... 
# https://discourse.julialang.org/t/confusing-difference-literal-vs-variable/13515/3
# https://github.com/JuliaLang/julia/pull/24240
# https://github.com/JuliaLang/julia/issues/28685
 
# What am i doing here? what is the name of this . notation? 
Base.literal_pow(^,100, Val(-1))
Base.literal_pow(^,100, Val(1-2))
Base.literal_pow(^,100, Val(p))

# But how do we implement this our function? 
# Remember Code clarity vs performance! 
# if you use all consumption integers all the time and you want to use 1-sigma as interers use Base.literaral_pow... 
# else just do 1.0 - sigma or  make sure you that consumption is always an float! 
function utility_2(cons,parameters)
    @unpack beta, sigma = parameters  # good style, less sensitive to errors, unpack is part of Parameters package
    return beta * Base.literal_pow(^,cons, Val(1-sigma)) /(1-sigma)
end

# Should we call the function utility_3! as we change one of the argument? 
function utility_3(cons,parameters)
    @unpack beta, sigma = parameters  # good style, less sensitive to errors, unpack is part of Parameters package
    cons = float(cons)
    return beta * cons^(1-sigma) /(1-sigma)
end

function utility_4(cons,parameters)
    @unpack beta, sigma = parameters  # good style, less sensitive to errors, unpack is part of Parameters package
    return beta * cons^(1.0-sigma) /(1-sigma)
end

# In this case the answer is obvious... 
@btime utility_2(100,myparams) 
@btime utility_3(100,myparams) 
@btime utility_4(100,myparams) 


function utility(cons,parameters)
    @unpack beta, sigma = parameters  # good style, less sensitive to errors, unpack is part of Parameters package
    cons = float(cons)
    return beta * cons^(1-sigma) /(1-sigma)
end

# further checks
# can consumption be 0 or negative? - no 
# what if sigma is = 1 ? No - log utility 
# what if consumption is missing?
utility(-1,myparams)
utility(-1,myparams) > utility(1,myparams) 
utility(0,myparams)

utility(1,myparameters(sigma = 1))


utility(nothing,myparams)
utility(missing,myparams)



function utility_1(cons,parameters)
    @unpack beta, sigma = parameters  # good style, less sensitive to errors, unpack is part of Parameters package
    if !isa(cons,Number)
        error("Not a Number")
    end

    cons = float(cons) 
    if cons <= 0
        return  -1e10
    else
        if sigma == 1 
            return beta * log(cons)
        else
            return beta * cons^(1-sigma) /(1-sigma)
        end 
    end
end

function utility_2(cons,parameters)
    @unpack beta, sigma = parameters  # good style, less sensitive to errors, unpack is part of Parameters package
    if !isa(cons,Number)
        error("Not a Number")
    end
    cons = float(cons) 

    if sigma == 1 
        return cons > 0 ? beta * log(cons) : -1e10
    else 
        return cons > 0 ? beta * cons^(1-sigma) /(1-sigma) : -1e10
    end 
end

utility_1(nothing,myparams)

# They work and Similar speed
@show map(x-> utility_1(x,myparams),[Inf,-Inf,0,-1,10])
@show map(x-> utility_2(x,myparams),[Inf,-Inf,0,-1,10])

@btime map(x-> utility_1(x,myparams),[Inf,-Inf,0,-1,10])
@btime map(x-> utility_2(x,myparams),[Inf,-Inf,0,-1,10])

# Does it work with a matrix? 2 state variable (grid of 1000 and grid of 100...)
cons_array = rand(1000,100)
# Not like this
utility = utility_1(cons_array,myparams)
# This is a solution, you can check out more! create your own one! 
utility = [utility_1(cons_array[i,j],myparams) for i in 1:size(cons_array,1), j in 1:size(cons_array,2)]







