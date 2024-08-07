sg = first(parse.(Int, ARGS))

using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

symeigs_dir="../../symeigs/"

include(symeigs_dir*"corner_charges.jl")
include(symeigs_dir*"wyckoffs_dict.jl")
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

cum_corner_charge_num_bands = Dict{Tuple{Integer, Integer, Integer, String, WyckoffPosition{2}, Integer}, Vector{Vector{Integer}}}();
cum_corner_charge_vals = Dict{Tuple{Integer, Integer, Integer, String, WyckoffPosition{2}, Integer}, Vector{Vector{Integer}}}();
cum_corner_charges = Dict{Tuple{Integer, Integer, Integer, String, WyckoffPosition{2}, Integer}, Vector{Integer}}();

sg_wyckoffs = sg_wyckoffs_dict[sg]

for (key, val) in JLD2_DATA
	for (atol_idx, atol) in enumerate(atolv) 
        	for wyckoff in sg_wyckoffs
                	cum_corner_charge_vals[key..., wyckoff, atol_idx] =  [[count(x -> (isapprox(corners(x[i], wyckoff)*12, j) &&
             		isapprox(polarizations(x[i], wyckoff), zeros(2))) && x[i].topology == TRIVIAL, filter(x -> length(x) >= i, val["cumsummariesvd"][(atol_idx, atol)])) for j in 1:11 ] for i in 1:5]
        	end
	end
end

for (key, val) in JLD2_DATA
	for (atol_idx, atol) in enumerate(atolv)      
  		for wyckoff in sg_wyckoffs
                	cum_corner_charge_num_bands[key..., wyckoff, atol_idx] =  [[count(x -> ( (x[i].n[end] == j) && !isapprox(corners(x[i], wyckoff), 0) &&
                    isapprox(polarizations(x[i], wyckoff), zeros(2))) && x[i].topology == TRIVIAL, filter(x -> length(x) >= i, val["cumsummariesvd"][(atol_idx, atol)])) for j in 1:40 ] for i in 1:5]
        	end
	end
end

for (key, val) in JLD2_DATA
	for (atol_idx, atol) in enumerate(atolv)
        	for wyckoff in sg_wyckoffs
                	cum_corner_charges[key..., wyckoff, atol_idx] =  [count(x -> (!isapprox(corners(x[i], wyckoff), 0) &&
                    	isapprox(polarizations(x[i], wyckoff), zeros(2))) && x[i].topology == TRIVIAL, filter(x -> length(x) >= i, val["cumsummariesvd"][(atol_idx, atol)])) for i in 1:5]
        	end
	end
end

filename = "./sg$(sg)-corner-data-atolsweep.jld2"
jldopen(filename, "w") do fid
	fid["cum_corner_charges"] = cum_corner_charges
	fid["cum_corner_charge_vals"] = cum_corner_charge_vals
	fid["cum_corner_charge_num_bands"] = cum_corner_charge_num_bands
end
