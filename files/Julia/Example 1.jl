""" 

Example 1: Introduction and Packages

Examples taken or adapted from QuantEcon Lecture 1, 2, 3 and 4 and Joel's Lecture

Learn:  Open repl, open file in VScode, run a code, run a section, install packages  

"""

#####################################
# Introduction 
#####################################

# Set CD
#cd("C:\Users\***\Dropbox\***\Quant Macro") ## Will not work 
#cd("C:/Users/***/Dropbox/***Quant Macro") ## will work 
#cd("C:\\Users\\***\\Dropbox\\***\\Quant Macro") ## Also work 

#pwd() ## Check the CD

#####################################
# Packages 
#####################################

# Activate the Package Manager: 
# in REPL the package manager is called with ]
using Pkg

# Add the packages needed: 
# # You should comment them out after the first time, as it can be time consuming CONTROL + /
# Pkg.add("BenchmarkTools") # Timing and benchmarking package
# Pkg.add("LinearAlgebra") # You might want to comment what the package does
# Pkg.add("Statistics")
# Pkg.add("Plots") # This is the standard Plotting package, there are nicer and more advanced ones! You need to invest some time in it though!! PGFPlotsX.jl or https://plotly.com/julia/
# Pkg.add("Random")
# Pkg.add("QuantEcon") #This will be very useful for Transition matrices and so on! 
# Pkg.add("Distributions")
# Pkg.add("DelimitedFiles")
# Pkg.add("Interpolations)
# Pkg.add("Optim)
# Pkg.add("LaTeXStrings")


# If a package is not in a registry, it can be added by specifying a URL to the repository:
Pkg.add(url = "https://github.com/JuliaLang/Example.jl")

# Check version, Update
Pkg.status("QuantEcon")
# Usually - does this match the version match the one in Github? - Google it
Pkg.update("QuantEcon")

# You can check out further package commands. Note that many of them relate
# to project and manifest TOML which you can read about here: https://pkgdocs.julialang.org/v1/toml-files/
# but I would not know about it.

#####################################
# Plotting
#####################################

# Activate them
using(Plots)
using(Random)
using(Distributions)

# Create some random data using a seed that comes in the Random Package
# Notice that here we use the import function We put the Name of the package . name of the function
Random.seed!(1234)

N = 100
data_1 = rand(N)
data_2 = similar(data_1)
for i in 1:N
    data_2[i] = rand()
end

# We use the plot function to make an ugly graph: 
# Takes a while the first time you run it
plot(data_1)
# Use ! to add to the plot a second line 
plot!(data_2)


# Plot from different distribution   
δ = rand(Laplace(), N)

using LaTeXStrings
plot(1:N, data_1,label = "Uniform", titlefontsize = 16,xlabel = L"1 + \alpha^2",ylabel = "∇") # Plot 
plot!(1:N, δ,label = "δ", titlefontsize = 16) # Plot 



title!("Random distribution")
png("Random distribution")



#####################################
# Exercise of first problem set 
# Plot: 15 / (3x + 1)
#####################################

#####################################
# Function
#####################################

# Function assigned to our group: f_5
function f_5(x)
    15 / (3x + 1)
end

#####################################
# Grid
#####################################

# Create the grid of values in a vector
grid_min = 0
grid_max = 6
grid_points = 1000

xgrid = collect(range(grid_min, length = grid_points, stop =grid_max))


#####################################
# Fill
#####################################

# Fill a vector with the image of the f_5 function and plot the result
y = zeros(length(xgrid))
for r = 1:length(xgrid)
    y[r] = f_5(xgrid[r])
end

#####################################
# Plotting 
#####################################

plot(xgrid, y, label = "f(x)", titlefontsize = 16)
title!("Function assigned: f_5")
png("Assigned_Function")

