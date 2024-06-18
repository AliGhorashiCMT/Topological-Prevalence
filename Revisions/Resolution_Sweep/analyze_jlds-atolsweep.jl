sg = first(parse.(Int, ARGS))

using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

JLD2_DATA = Dict{Tuple{Integer, Integer, Integer, String}, Dict{String, Any}}()

resolutionv = [8, 12, 16, 24, 32, 48, 128, 256, 64]
atolv = [2e-2, 4e-2, 6e-2, 8e-2, 1e-1]

for mode in ["te", "tm"]
    println("Analyzing mode: $mode\n")
    flush(stdout)
    id_eps = 3
    for (res_idx, res) in enumerate(resolutionv)
	res > 40 || continue
        println("Analyzing id_eps : ", id_eps)
        println("Analyzing res_idx: ", res_idx)
	flush(stdout)
        dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/res$(res_idx)/" # Directory of the jld2 data file for the particular mode and contrast
        filename = dir*"sg$(sg)-epsid$(id_eps)-res$(res)-$(mode)-atolsweep.jld2" 
        loaded_data = load(filename)
        JLD2_DATA[(sg, id_eps, res_idx, mode)] = loaded_data
    end
end

topologies = Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Vector{TopologyKind}}}(); # Topologies for each compatible set of band
cum_topologies = Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Vector{TopologyKind}}}(); # Topologies from the first band up
num_bands = Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Vector{Integer}}}(); # Number of bands in each compatible set of bands

for (key, val) in JLD2_DATA
    for (atol_idx, atol) in enumerate(atolv)
        topologies[(key..., atol_idx)] = [[summary.topology for summary in summaryvecd] for summaryvecd in val["summariesvd"][(atol_idx, atol)]]; # Vector of Vector of topologies
        cum_topologies[(key..., atol_idx)] = [[summary.topology for summary in summaryvecd] for summaryvecd in val["cumsummariesvd"][(atol_idx, atol)]]; # Vector of Vector of cumulative topologies
        num_bands[(key..., atol_idx)] = [[last(summary.n) for summary in summaryvecd] for summaryvecd in val["summariesvd"][(atol_idx, atol)]]; # Vector of vector of numbers of bands in each compatible set
    end
end

trivial_count =  Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Integer}}();
cum_trivial_count = Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Integer}}();
cum_stable_count = Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Integer}}();

stable_count =  Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Integer}}();
fragile_count =  Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Integer}}();
cum_fragile_count = Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Integer}}();

num_bands_count = Dict{Tuple{Integer, Integer, Integer, String, Integer}, Vector{Vector{Integer}}}();

for (key, val) in num_bands
	num_bands_count[key] = [[ (j < 5 ? count(x -> x[i] == j, filter(x -> length(x) >= i, val)) : count(x -> x[i] >= j,
		 filter(x -> length(x) >= i, val))) for j in 1:5] for i in 1:5]
	# (filter x -> length(x) >= i) is so we don't get errors if we try to index a vector of summaries with length less than i. 
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

filename = "./sg$(sg)-data-atolsweep.jld2"
jldopen(filename, "w") do fid
	fid["trivial_count"] = trivial_count
	fid["fragile_count"] = fragile_count
	fid["stable_count"] = stable_count

	fid["cum_fragile_count"] = cum_fragile_count	
	fid["cum_trivial_count"] = cum_trivial_count
	fid["cum_stable_count"] = cum_stable_count

	fid["num_bands"] = num_bands_count
end
