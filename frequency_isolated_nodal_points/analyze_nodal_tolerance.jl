using Crystalline, MPBUtils, SymmetryBases, JLD2, PyPlot, DelimitedFiles, PyCall
sg = parse.(Int, ARGS)
sg = first(sg)
good_candidates_te  = Dict{Integer, Vector{Tuple{Integer, Integer}}}() # Dictionary for each space group
good_candidates_tm  = Dict{Integer, Vector{Tuple{Integer, Integer}}}() # Dictionary for each space group
id_eps = 3
println("Calculating for plane group $sg"); flush(stdout)
println("Calculating for id_eps: $id_eps"); flush(stdout)
for mode = ["te", "tm"];
    println("Mode: $(mode)"); flush(stdout)
    dispersion_dir = "../dispersions/output/sg$sg/eps$(id_eps)/$mode/";
    loaded_dispersion_data = load(dispersion_dir*"sg$sg-epsid$(id_eps)-res64-$mode.jld2")
    cumsummariesv = loaded_dispersion_data["cumsummariesv"];
    for (id, cumsummaries) in enumerate(cumsummariesv)
        (id % 100 == 0) && println("ID: $id")
        length(cumsummaries) < 1 && (println("id $id no cumsummaries"); continue)
        real_id = id + (10000)*(id_eps-1)
        shortened_summaries = cumsummaries[1:min(length(cumsummaries), 3)]
        shortened_summaries_mults = findall(x -> x.topology == NONTRIVIAL, shortened_summaries)
        shortened_summaries = filter(x -> x.topology == NONTRIVIAL, shortened_summaries)
        isempty(shortened_summaries) && continue
        top_bands = [x.band[end] for x in shortened_summaries]
        top_bands_and_mults = [(x, y) for (x, y) in zip(shortened_summaries_mults, top_bands)]
        mode == "te" && push!(good_candidates_te,  real_id => top_bands_and_mults)
        mode == "tm" && push!(good_candidates_tm,  real_id => top_bands_and_mults)
    end
end

println("Number of TE candidates: $(length(good_candidates_te))")
println("Number of TM candidates: $(length(good_candidates_tm))")

well_separated_nodal_points = Dict{Tuple{String, Integer}, Vector{Tuple{Integer, Integer, Float64}}}()
well_separated_nodal_points_sorted = Dict{Tuple{String, Integer}, Vector{Tuple{Integer, Integer, Float64}}}() # Check to see if MPB ordered bands
# correctly

for mode in ["te", "tm"]
    good_candidates = (mode == "te" ? good_candidates_te : good_candidates_tm)
    for (i, (real_id, top_bands_and_mults)) in enumerate(good_candidates)
        (i % 100 == 0) && println("Id: $real_id"); flush(stdout)
        multiplet_vec = Vector{Tuple{Integer, Integer, Float64}}() # Multiplet, # Top band of multiplet, # How much fails from well-separated
        multiplet_vec_sorted = Vector{Tuple{Integer, Integer, Float64}}() # Multiplet, # Top band of multiplet, # How much fails from well-separated

        full_dispersion = readdlm("./output/sg$sg/eps$(id_eps)/$mode/dim2-sg$sg-$(real_id)-res64-$mode-dispersion.out", ',')[:, 6:end]
        full_dispersion_sorted = sort(full_dispersion, dims=2)
        for (mult, top_band) in top_bands_and_mults
            bottom_band_dispersion = full_dispersion[:, top_band]
            top_band_dispersion = full_dispersion[:, top_band + 1]
            nodal_point_k = argmin(top_band_dispersion - bottom_band_dispersion)
            nodal_point = top_band_dispersion[nodal_point_k]

            bottom_band_dispersion_sorted = full_dispersion_sorted[:, top_band]
            top_band_dispersion_sorted = full_dispersion_sorted[:, top_band + 1]
            nodal_point_k_sorted = argmin(top_band_dispersion_sorted - bottom_band_dispersion_sorted)
            nodal_point_sorted = top_band_dispersion_sorted[nodal_point_k_sorted]
            
            how_bad = min(minimum(top_band_dispersion) - nodal_point, nodal_point - maximum(bottom_band_dispersion))
            how_bad_sorted = min(minimum(top_band_dispersion_sorted) - nodal_point_sorted, nodal_point_sorted - maximum(bottom_band_dispersion_sorted))

            push!(multiplet_vec, (mult, top_band, how_bad))
            push!(multiplet_vec_sorted, (mult, top_band, how_bad_sorted))

        end
        push!(well_separated_nodal_points, (mode, real_id) => multiplet_vec)
        push!(well_separated_nodal_points_sorted, (mode, real_id) => multiplet_vec_sorted)
    end
end

filename = "./sg$(sg)_tolerance.jld2"
jldopen(filename, "w") do fid
        fid["well_separated_nodal_points"] = well_separated_nodal_points
        fid["well_separated_nodal_points_sorted"] = well_separated_nodal_points_sorted
end
