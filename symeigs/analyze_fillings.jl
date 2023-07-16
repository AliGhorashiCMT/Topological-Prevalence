sg = first(parse.(Int, ARGS))

using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

JLD2_DATA = Dict{String, Dict{String, Any}}()

id_eps = 3 # Only consider contrast of 16
possible_fillings = 0.2:0.05:0.8 # These are the fillings for which we created fourier lattices (13 possible total choices)

for mode in ["te", "tm"]
    println("Analyzing mode: $mode\n")
    flush(stdout)
    println("Analyzing id_eps : ", id_eps)
    flush(stdout)
    dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/" # Directory of the jld2 data file for the particular mode and contrast
    filename = dir*"sg$(sg)-epsid$(id_eps)-res64-$(mode).jld2"
    loaded_data = load(filename)
    JLD2_DATA[mode] = loaded_data
end

topologies = Dict{Tuple{String, Integer}, Vector{Vector{TopologyKind}}}(); # Topologies for each compatible set of band the key is a tuple (mode, filling_idx)
fillings_dict = Dict{String, Vector{Integer}}(); # String is the polarization and the vector is a vector of filling indices

for mode in ["te", "tm"]
	println("Analyzing fillings for mode: $(mode)"); flush(stdout)
	fillings_vec = zeros(10000)
	output_dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/"
	filename = output_dir*"sg$(sg)-epsid$(id_eps)-res64-$(mode)-input.jld2"
	loaded_data = load(filename)
	flatv = loaded_data["flatv"]
	isovalv = loaded_data["isovalv"]
	for (id, (flat, isoval)) in enumerate(zip(flatv, isovalv))
		filling = isoval2filling(flat, isoval, 100) # 100 is the mesh on which we evaluate the fourier lattice
		filling_idx = argmin(abs.(possible_fillings .- filling)) # Find index of possible fillings most appropriate for the fourier lattice
		fillings_vec[id] = filling_idx 
	end
	fillings_dict[mode] = fillings_vec
end

for (key, val) in JLD2_DATA
    fillings_vec = fillings_dict[key]
    for filling_idx in 1:13
         ids_at_filling = findall(x -> x == filling_idx, fillings_vec) # Find all fourier lattices with relevant filling
         topologies[(key, filling_idx)] = [[summary.topology for summary in summaryvec] for summaryvec in val["summariesv"][ids_at_filling]]; # Vector of Vector of topologies
    end
end

stable_count = Dict{Tuple{String, Integer}, Vector{Integer}}(); # key is a tuple (mode, filling_idx)
total_count = Dict{Tuple{String, Integer}, Integer}(); # key is a tuple (mode, filling_idx)
for (key, val) in topologies
	stable_count[key] = [
                count(x -> x[i] == TopologyKind(1), filter(x -> length(x) >= i, val))
                for i in 1:5] # We have a vector indexed by bands.
	total_count[key] = length(val) # total number of lattices with specified filling. 
end

filename = "./sg$(sg)-fillings-data.jld2"
jldopen(filename, "w") do fid
        fid["stable_count"] = stable_count
	fid["total_count"] = total_count
end
