sg = first(parse.(Int, ARGS))
using Crystalline, MPBUtils, HDF5, PyPlot, JLD2, StaticArrays;

println("Running Spacegroup: $sg")
brs = bandreps(sg, 2)
lgirsd = lgirreps(sg, Val(2))

N = 10000

#resolutionv = [8, 12, 16, 24, 32, 48, 128, 256]
resolutionv = [8, 12, 16, 24, 32, 48, 128, 256, 64] #Look at the 64 resolution as well (in different directory)
atolv = [2e-2, 4e-2, 6e-2, 8e-2, 1e-1]

for mode in ["te", "tm"]
    println("mode: ", mode)
    flush(stdout)
    id_eps = 3
    for (res_idx, res) in enumerate(resolutionv)
	res > 40 || continue # Only look at new resolutions 
        println("res_idx: ", res_idx)
	flush(stdout)
        dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/res$(res_idx)/"

	load_dir =
	if (res == 64)
	    "../../symeigs/output/sg$(sg)/eps$(id_eps)/$(mode)/"
	else
	    dir 
	end

        symeigsdv = Vector{Dict{String, Vector{Vector{ComplexF64}}}}(undef, N)
        summariesvd = Dict{Tuple{Integer, Float64}, Vector{Vector{BandSummary}}}()
	cum_summariesvd = Dict{Tuple{Integer, Float64}, Vector{Vector{BandSummary}}}()

	# For each resolution, loop through all the calculations and store the symmetry data. 
        for id in eachindex(symeigsdv)
            id′ = id + (id_eps-1)*10000 # actual id

            symeigsd, lgd = read_symdata("dim2-sg$sg-$(id′)-res$(res)-$mode", dir = load_dir)
            fixup_gamma_symmetry!(symeigsd, lgd, Symbol(uppercase(mode)))
            id == 1 && (global lgirsd = pick_lgirreps(lgd))

            symeigsdv[id] = symeigsd
	end
	# Loop through all the stored symmetry data, and calculate the summaries and cumsummaries with different levels of tolerance
	for (atol_idx, atol) in enumerate(atolv)
	    println("Calculating with tolerance: $atol\n"); flush(stdout)
	    summariesv = Vector{Vector{BandSummary}}(undef, N)
            cum_summariesv = Vector{Vector{BandSummary}}(undef, N)	
	    for (id, symeigsd) in enumerate(symeigsdv)	
	        summaries = analyze_symmetry_data(symeigsd, lgirsd, brs, atol=atol)            
                summariesv[id] = summaries
	        cum_summariesv[id] = cumsum(summaries)
	    end
	    summariesvd[(atol_idx, atol)] = summariesv
	    cum_summariesvd[(atol_idx, atol)] = cum_summariesv
        end
        filename = dir*"sg$(sg)-epsid$(id_eps)-res$(res)-$(mode)-atolsweep.jld2"                
        jldopen(filename, "w") do fid
            fid["lgirsd"] = lgirsd
            fid["brs"] = brs
            fid["symeigsdv"] = symeigsdv
            fid["summariesvd"] = summariesvd
            fid["cumsummariesvd"] = cum_summariesvd
	end
    end
end

