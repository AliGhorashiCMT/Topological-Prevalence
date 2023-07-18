sg = first(parse.(Int, ARGS))
using Crystalline, MPBUtils, HDF5, PyPlot, JLD2, StaticArrays;

println("Running Spacegroup: $sg")
for mode in ["te", "tm"]

    println("mode: ", mode)
    flush(stdout)

    for id_eps in 1:3

        println("id_eps: ", id_eps)
	flush(stdout)
        input_dir = "./input/"
	output_dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/"
	
	Rsv = DirectBasis{2}[] # Vector of lattice vectors
	isovalv = Float64[] # Vector of isovalues- which determine the fillings of the Fourier lattices
	flatv = ModulatedFourierLattice{2}[] # Vector of fourier lattices, which provide compatible coefficients for G vectors of the underlying plane group

	for id in 1:10000
		Rs, flat, isoval, _  = lattice_from_mpbparams(input_dir*"dim2-sg$sg-$(id+(id_eps-1)*10000)-res64-$mode.sh")
		push!(Rsv, Rs)
		push!(flatv, flat)
		push!(isovalv, isoval)
        end

        filename = output_dir*"sg$(sg)-epsid$(id_eps)-res64-$(mode)-input.jld2"                
        jldopen(filename, "w") do fid
            fid["Rsv"] = Rsv
            fid["isovalv"] = isovalv
            fid["flatv"] = flatv
	end
    end
end

