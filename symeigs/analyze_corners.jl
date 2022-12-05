sg = first(parse.(Int, ARGS))

using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

include("corner_charges.jl")
include("wyckoffs_dict.jl")
JLD2_DATA = Dict{Tuple{Integer, Integer, String}, Dict{String, Any}}()

for mode in ["te", "tm"]
    println("Analyzing mode: $mode\n")
    flush(stdout)
    for id_eps in 1:5
        println("Analyzing id_eps : ", id_eps)
        flush(stdout)
        dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/"
        filename = dir*"sg$(sg)-epsid$(id_eps)-res64-$(mode).jld2"
        loaded_data = load(filename)
        JLD2_DATA[(sg, id_eps, mode)] = loaded_data
    end
end

cum_corner_charge_num_bands = Dict{Tuple{Integer, Integer, String, WyckoffPosition{2}}, Vector{Vector{Integer}}}();
cum_corner_charge_vals = Dict{Tuple{Integer, Integer, String, WyckoffPosition{2}}, Vector{Vector{Integer}}}();
cum_corner_charges = Dict{Tuple{Integer, Integer, String, WyckoffPosition{2}}, Vector{Integer}}();

sg_wyckoffs = sg_wyckoffs_dict[sg]


for (key, val) in JLD2_DATA
        for wyckoff in sg_wyckoffs
                cum_corner_charge_vals[key..., wyckoff] =  [[count(x -> (isapprox(corners(x[i], wyckoff)*12, j) &&
                    isapprox(polarizations(x[i], wyckoff), zeros(2))) && x[i].topology == TRIVIAL, filter(x -> length(x) >= i, val["cumsummariesv"])) for j in 1:11 ] for i in 1:5]
        end
end

for (key, val) in JLD2_DATA
        for wyckoff in sg_wyckoffs
                cum_corner_charge_num_bands[key..., wyckoff] =  [[count(x -> ( (x[i].n[end] == j) && !isapprox(corners(x[i], wyckoff), 0) &&
                    isapprox(polarizations(x[i], wyckoff), zeros(2))) && x[i].topology == TRIVIAL, filter(x -> length(x) >= i, val["cumsummariesv"])) for j in 1:40 ] for i in 1:5]
        end
end

for (key, val) in JLD2_DATA
        for wyckoff in sg_wyckoffs
                cum_corner_charges[key..., wyckoff] =  [count(x -> (!isapprox(corners(x[i], wyckoff), 0) &&
                    isapprox(polarizations(x[i], wyckoff), zeros(2))) && x[i].topology == TRIVIAL, filter(x -> length(x) >= i, val["cumsummariesv"])) for i in 1:5]
        end
end

filename = "./sg$(sg)-corner-data.jld2"
jldopen(filename, "w") do fid
	fid["cum_corner_charges"] = cum_corner_charges
	fid["cum_corner_charge_vals"] = cum_corner_charge_vals
	fid["cum_corner_charge_num_bands"] = cum_corner_charge_num_bands
end
