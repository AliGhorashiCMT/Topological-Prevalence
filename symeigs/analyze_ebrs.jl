sg = first(parse.(Int, ARGS))

using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

include("corner_charges.jl")

sg_wyckoffs = [filter(x -> x.mult == 1, wyckoffs(i, 2)) for i in (2, 6, (9:17)...)]
sg_wyckoffs[3] = wyckoffs(9, 2)[end-1:end];
sg_wyckoffs[6] = [wyckoffs(12, 2)[end]];
sg_wyckoffs[9] = [WyckoffPosition(1, 'a', RVec([0, 0])), WyckoffPosition(2, 'b', RVec([1/3, 2/3])), WyckoffPosition(2, 'c', RVec([2/3, 1/3]))]

sg_wyckoffs_dict = Dict(([2, 6, 9:17...])[i] => sg_wyckoffs[i] for i in 1:11)

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

unique_ebrs_dict = Dict{Tuple{Integer, Integer, String}, Vector{Vector{Vector{Integer}}}}();
ebr_frequency_dict = Dict{Tuple{Integer, Integer, String}, Vector{Vector{Integer}}}();

sg_wyckoffs = sg_wyckoffs_dict[sg]
brs = bandreps(sg, 2)

for (key, val) in JLD2_DATA
	filtered_summaries = [filter(x -> length(x) >=i && x[i].topology == TRIVIAL && any(wp -> isapprox(polarizations(x[i], wp), zeros(2)) &&
         !isapprox(corners(x[i], wp), 0), sg_wyckoffs), val["cumsummariesv"]) for i in 1:3];
	unique_ebrs = Vector{Vector{Integer}}[]
	ebr_frequency = Vector{Integer}[]
	for i in 1:3
		isempty(filtered_summaries[i]) && (push!(unique_ebrs, [[0]]); push!(ebr_frequency, [0]); continue)
		decomposed = [decompose(x[i].n, brs) for x in filtered_summaries[i]];
		unique_decomposed = unique(decomposed)
		frequency = [count(x -> x == u, decomposed) for u in unique_decomposed]
		push!(unique_ebrs, [Int.(u) for u in (unique_decomposed)])
		push!(ebr_frequency, frequency)
	end
	unique_ebrs_dict[key] = unique_ebrs
	ebr_frequency_dict = ebr_frequency
end

filename = "./sg$(sg)-ebr-data.jld2"
jldopen(filename, "w") do fid
	fid["unique_ebrs_dict"] = unique_ebrs_dict
	fid["ebr_frequency"] = ebr_frequency
end
