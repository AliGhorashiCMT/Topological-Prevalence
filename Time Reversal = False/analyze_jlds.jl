sg = first(parse.(Int, ARGS))

using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

JLD2_DATA = Dict{Tuple{Integer, Integer, String}, Dict{String, Any}}()

for mode in ["te", "tm"]
    println("Analyzing mode: $mode\n")
    flush(stdout)
    for gidx in 1:4
        println("Analyzing gidx : ", gidx)
        flush(stdout)
        dir = "./output/sg$(sg)/$(mode)/g$(gidx)/" # Directory of the jld2 data file for the particular mode and contrast
        filename = dir*"sg$(sg)-g$(gidx)-res64-$(mode).jld2" 
        loaded_data = load(filename)
        JLD2_DATA[(sg, gidx, mode)] = loaded_data
    end
end

topologies = Dict{Tuple{Integer, Integer, String}, Vector{Vector{Int64}}}(); # Topologies for each compatible set of band
cum_topologies = Dict{Tuple{Integer, Integer, String}, Vector{Vector{Int64}}}(); # Topologies from the first band up

for (key, val) in JLD2_DATA
    topologies[key] = [[summary.indicators[1] for summary in summaryvec] for summaryvec in val["summariesv"]]; # Vector of Vector of topologies
    cum_topologies[key] = [[summary.indicators[1] for summary in summaryvec] for summaryvec in val["cumsummariesv"]]; # Vector of Vector of cumulative topologies
end

cum_stable_count = Dict{Tuple{Integer, Integer, String}, Vector{Vector{Integer}}}();
stable_count =  Dict{Tuple{Integer, Integer, String}, Vector{Vector{Integer}}}();

for (key, val) in topologies
    stable_count[key] = [[ 
                count(x -> x[i] == j, filter(x -> length(x) >= i, val))
                for i in 1:5] for j in 0:5]
end

for (key, val) in cum_topologies
	cum_stable_count[key] = [[
            count(x -> x[i] == j, filter(x -> length(x) >= i, val))
            for i in 1:5 ] for j in 0:5]
end

filename = "./sg$(sg)-data.jld2"
jldopen(filename, "w") do fid
	fid["stable_count"] = stable_count
	fid["cum_stable_count"] = cum_stable_count
end
