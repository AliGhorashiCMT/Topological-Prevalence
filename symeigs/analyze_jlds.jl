sg = first(parse.(Int, ARGS))

using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

JLD2_DATA = Dict{Tuple{Integer, Integer, String}, Dict{String, Any}}()

for mode in ["te", "tm"]
    println("Analyzing mode: $mode\n")
    flush(stdout)
    for id_eps in 1:3
        println("Analyzing id_eps : ", id_eps)
        flush(stdout)
        dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/"
        filename = dir*"sg$(sg)-epsid$(id_eps)-res64-$(mode).jld2"
        loaded_data = load(filename)
        JLD2_DATA[(sg, id_eps, mode)] = loaded_data
    end
end

topologies = Dict{Tuple{Integer, Integer, String}, Vector{Vector{TopologyKind}}}();
cum_topologies = Dict{Tuple{Integer, Integer, String}, Vector{Vector{TopologyKind}}}();
num_bands = Dict{Tuple{Integer, Integer, String}, Vector{Vector{Integer}}}();

for (key, val) in JLD2_DATA
    topologies[key] = [[summary.topology for summary in summaryvec] for summaryvec in val["summariesv"]];
    cum_topologies[key] = [[summary.topology for summary in summaryvec] for summaryvec in val["cumsummariesv"]];
    num_bands[key] = [[last(summary.n) for summary in summaryvec] for summaryvec in val["summariesv"]];
end

trivial_count =  Dict{Tuple{Integer, Integer, String}, Vector{Integer}}();
cum_trivial_count = Dict{Tuple{Integer, Integer, String}, Vector{Integer}}();
cum_stable_count = Dict{Tuple{Integer, Integer, String}, Vector{Integer}}();

stable_count =  Dict{Tuple{Integer, Integer, String}, Vector{Integer}}();
fragile_count =  Dict{Tuple{Integer, Integer, String}, Vector{Integer}}();
cum_fragile_count = Dict{Tuple{Integer, Integer, String}, Vector{Integer}}();

num_bands_count = Dict{Tuple{Integer, Integer, String}, Vector{Vector{Integer}}}();

for (key, val) in num_bands
	num_bands_count[key] = [[count(x -> x[i] == j, filter(x -> length(x) >= i, val)) for j in 1:4] for i in 1:5]
end

for (key, val) in topologies
    trivial_count[key] = [ 
                count(x -> x[i] == TopologyKind(0), filter(x -> length(x) >= i, val))
                for i in 1:5]
    stable_count[key] = [ 
                count(x -> x[i] == TopologyKind(1), filter(x -> length(x) >= i, val))
                for i in 1:5]
    fragile_count[key] = [ 
                count(x -> x[i] == TopologyKind(2), filter(x -> length(x) >= i, val))
                for i in 1:5]
end

for (key, val) in cum_topologies
        cum_trivial_count[key] = [
            count(x -> x[i] == TopologyKind(0), filter(x -> length(x) >= i, val))
            for i in 1:5 ]
    	cum_stable_count[key] = [
            count(x -> x[i] == TopologyKind(1), filter(x -> length(x) >= i, val))
            for i in 1:5 ]
	cum_fragile_count[key] = [ 
            count(x -> x[i] == TopologyKind(2), filter(x -> length(x) >= i, val))
            for i in 1:5 ]
end

filename = "./sg$(sg)-data.jld2"
jldopen(filename, "w") do fid
	fid["trivial_count"] = trivial_count
	fid["fragile_count"] = fragile_count
	fid["stable_count"] = stable_count

	fid["cum_fragile_count"] = cum_fragile_count	
	fid["cum_trivial_count"] = cum_trivial_count
	fid["cum_stable_count"] = cum_stable_count

	fid["num_bands"] = num_bands_count
end
