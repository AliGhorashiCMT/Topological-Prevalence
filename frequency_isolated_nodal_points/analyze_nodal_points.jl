using Crystalline, MPBUtils, SymmetryBases, JLD2, PyPlot, DelimitedFiles, PyCall

for sgnum in [2]
	well_separated_nodal_points = Dict{Tuple{String, Integer}, Vector{Integer}}()
	for mode in ["te", "tm"]
		dispersion_dir = "../dispersions/output/sg$sgnum/eps3/$mode/";
		loaded_dispersion_data = load(dispersion_dir*"sg$sgnum-epsid3-res64-$mode.jld2")
		cumsummariesv = loaded_dispersion_data["cumsummariesv"];
		tot_count = 0
		for id in 1:10000
			real_id = id + (3-1)*10000
			(id % 100 == 0) && println("Id: $real_id. Count: $tot_count"); flush(stdout)
			multiplet_vec = zeros(3)
			cumsummaries = cumsummariesv[id]
			try
				full_dispersion = readdlm("./output/sg$sgnum/eps3/$mode/dim2-sg$sgnum-$(real_id)-res64-$mode-dispersion.out", ',')[:, 6:end]
				for (multiplet, cumsummary) in enumerate(cumsummaries[1:min(length(cumsummaries), 3)])
				        cumsummary.topology == NONTRIVIAL || continue
					bottom_band_idx = cumsummary.band[end]
					top_band_idx = bottom_band_idx + 1
					bottom_band_dispersion = full_dispersion[:, bottom_band_idx]
					top_band_dispersion = full_dispersion[:, top_band_idx]
					nodal_point = top_band_dispersion[argmin(top_band_dispersion - bottom_band_dispersion)]
					minimum(top_band_dispersion) >= nodal_point || continue
					maximum(bottom_band_dispersion) <= nodal_point || continue
					multiplet_vec[multiplet] +=1
				end
				tot_count += 1
			catch e
				println(e)
			end
			push!(well_separated_nodal_points, (mode, real_id) => multiplet_vec)
		end
	end

filename = "./sg$(sgnum)_nodal_data.jld2"
jldopen(filename, "w") do fid
        fid["well_separated_nodal_points"] = well_separated_nodal_points
end
end
