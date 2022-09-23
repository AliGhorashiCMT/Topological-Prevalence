sg = first(parse.(Int, ARGS))

using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

include("corner_charges.jl")

sg_wyckoffs = [filter(x -> x.mult == 1, wyckoffs(i, 2)) for i in (2, 6, (9:17)...)]
sg_wyckoffs[3] = wyckoffs(9, 2)[end-1:end];
sg_wyckoffs[6] = [wyckoffs(12, 2)[end]];
sg_wyckoffs[9] = [WyckoffPosition(1, 'a', RVec([0, 0])), WyckoffPosition(2, 'b', RVec([1/3, 2/3])), WyckoffPosition(2, 'c', RVec([2/3, 1/3]))]

sg_wyckoffs_dict = Dict(([2, 6, 9:17...])[i] => sg_wyckoffs[i] for i in 1:11)
sg_wyckoffs = sg_wyckoffs_dict[sg]

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

function has_corner(summaries::Vector{BandSummary}, num_groupings::Integer=3)
    any(summary->summary.topology == TRIVIAL && any(wyckoff -> !isapprox(corners(summary, wyckoff), 0)  && 
            isapprox(polarizations(summary, wyckoff), zeros(2), atol=1e-2), sg_wyckoffs), summaries[1:min(num_groupings, length(summaries))])
end

corner_data = Dict{Tuple{Integer, Integer, String}, Integer}();

for (key, val) in JLD2_DATA
        corner_data[key...] = count(has_corner.(val["cumsummariesv"], Ref(3)))
end

filename = "./sg$(sg)-corner-data-in-groups.jld2"
jldopen(filename, "w") do fid
        fid["corner_data"] = corner_data
end
