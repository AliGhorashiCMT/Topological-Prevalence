sg = first(parse.(Int, ARGS))

using JLD2, DelimitedFiles
using Crystalline, MPBUtils, SymmetryBases

println("Running Spacegroup: $sg")
for mode in ["te", "tm"]
    println("mode: ", mode)
    flush(stdout)
    for id_eps in 1:3
        println("id_eps: ", id_eps)
	flush(stdout)
        dispersion_dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/"
	
	symeigs_dir = "../symeigs/output/sg$(sg)/eps$(id_eps)/$(mode)/"
	symeigs_filename = symeigs_dir*"sg$(sg)-epsid$(id_eps)-res64-$(mode).jld2"
	loaded_data = load(symeigs_filename)
	cumsummariesv = loaded_data["cumsummariesv"];

	dispersionsv = Vector{Matrix{Float64}}(undef, 10000)	
	marginsv = Vector{Vector{Float64}}(undef, 10000)

        for id in eachindex(dispersionsv)
            real_id = id + (id_eps-1)*10000 # actual id
	    dispersions = sort(readdlm(dispersion_dir*"dim2-sg$sg-$(real_id)-res64-$mode-dispersion.out", ',', Float64)[:, 6:end], dims=2)
	    dispersionsv[id] = dispersions
	    margins = Float64[]
	    cumsummaries = cumsummariesv[id]
	    for cumsummary in cumsummaries
		top_band = cumsummary.band[end]
		top_band >= 40 && continue
		margin = minimum(dispersions[:, top_band+1] - dispersions[:, top_band])
	    	push!(margins, margin)
	    end
	    marginsv[id] = margins
        end
        filename = dispersion_dir*"sg$(sg)-epsid$(id_eps)-res64-$(mode).jld2"                
        jldopen(filename, "w") do fid
            fid["dispersionsv"] = dispersionsv
	    fid["marginsv"] = marginsv
	end
    end
end

