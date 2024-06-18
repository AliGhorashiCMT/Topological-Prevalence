sg = first(parse.(Int, ARGS))
using Crystalline, MPBUtils, HDF5, PyPlot, JLD2, StaticArrays;

println("Running Spacegroup: $sg")
brs = bandreps(sg, 2)
lgirsd = lgirreps(sg, Val(2))

N = 10000

resolutionv = [8, 12, 16, 24, 32, 48, 128, 256]

for mode in ["te", "tm"]
    println("mode: ", mode)
    flush(stdout)
    id_eps = 3
    for (res_idx, res) in enumerate(resolutionv)
	res > 200 || continue # Only look at new resolutions 
        println("res_idx: ", res_idx)
	flush(stdout)
        dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/res$(res_idx)/"

        symeigsdv = Vector{Dict{String, Vector{Vector{ComplexF64}}}}(undef, N)
        summariesv = Vector{Vector{BandSummary}}(undef, N)
	cum_summariesv = Vector{Vector{BandSummary}}(undef, N)

        for id in eachindex(symeigsdv)
            id′ = id + (id_eps-1)*10000 # actual id

            symeigsd, lgd = read_symdata("dim2-sg$sg-$(id′)-res$(res)-$mode", dir = dir)
            fixup_gamma_symmetry!(symeigsd, lgd, Symbol(uppercase(mode)))
            id == 1 && (global lgirsd = pick_lgirreps(lgd))

            symeigsdv[id] = symeigsd
            summaries = analyze_symmetry_data(symeigsd, lgirsd, brs)            
            summariesv[id] = summaries
	    cum_summariesv[id] = cumsum(summaries)
        end
        filename = dir*"sg$(sg)-epsid$(id_eps)-res$(res)-$(mode).jld2"                
        jldopen(filename, "w") do fid
            fid["lgirsd"] = lgirsd
            fid["brs"] = brs
            fid["symeigsdv"] = symeigsdv
            fid["summariesv"] = summariesv
            fid["cumsummariesv"] = cum_summariesv
	end
    end
end

