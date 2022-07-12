sg = first(parse.(Int, ARGS))

using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

include("corner_charges.jl")

sg_wyckoffs = [filter(x -> x.mult == 1, wyckoffs(i, 2)) for i in (2, 6, (9:17)...)]
sg_wyckoffs[3] = wyckoffs(9, 2)[end-1:end];
sg_wyckoffs[6] = [wyckoffs(12, 2)[end]];

sg_wyckoffs_dict = Dict(([2, 6, 9:17...])[i] => sg_wyckoffs[i] for i in 1:11)

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

corner_charges = Dict{Tuple{Integer, Integer, String, WyckoffPosition{2}}, Vector{Vector{Integer}}}();
cum_corner_charges = Dict{Tuple{Integer, Integer, String, WyckoffPosition{2}}, Vector{Vector{Integer}}}();
wyckoff_degeneracy = Dict{Tuple{Integer, Integer, String}, Vector{Vector{Integer}}}();

sg_wyckoffs = sg_wyckoffs_dict[sg]

for (key, val) in JLD2_DATA
        for wyckoff in sg_wyckoffs
                corner_charges[key..., wyckoff] =  [[count(x -> (isapprox(corners(x[i], wyckoff)*12, j) && 
                    isapprox(polarizations(x[i], wyckoff), zeros(2))), filter(x -> length(x) >= i, val["summariesv"])) for j in 1:11 ] for i in 1:5] 
        end
end

for (key, val) in JLD2_DATA
        for wyckoff in sg_wyckoffs
                cum_corner_charges[key..., wyckoff] =  [[count(x -> (isapprox(corners(x[i], wyckoff)*12, j) &&
                    isapprox(polarizations(x[i], wyckoff), zeros(2))), filter(x -> length(x) >= i, val["cumsummariesv"])) for j in 1:11 ] for i in 1:5]
        end
end

for (key, val) in JLD2_DATA
	wyckoff_degeneracy[key...] =  [[count(x -> (count(wyckoff -> !isapprox(corners(x[i], wyckoff), 0, atol=1e-2) &&
		isapprox(polarizations(x[i], wyckoff), zeros(2), atol=1e-2), sg_wyckoffs)) >= j, filter(x -> length(x) >= i, val["summariesv"])) for j in 1:6] for i in 1:5]
end


filename = "./sg$(sg)-corner-data.jld2"
jldopen(filename, "w") do fid
	fid["corner_charges"] = corner_charges
	fid["cum_corner_charges"] = cum_corner_charges
	fid["wyckoff_degeneracy"] = wyckoff_degeneracy
end
