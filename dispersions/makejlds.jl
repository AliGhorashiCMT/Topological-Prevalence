sg = first(parse.(Int, ARGS))
using JLD2, DelimitedFiles

println("Running Spacegroup: $sg")
for mode in ["te", "tm"]
    println("mode: ", mode)
    flush(stdout)
    for id_eps in 1:3
        println("id_eps: ", id_eps)
	flush(stdout)
        dispersion_dir = "./output/sg$(sg)/eps$(id_eps)/$(mode)/"
	dispersionsv = Vector{Matrix{Float64}}(undef, 10000)	
        for id in eachindex(dispersionsv)
            real_id = id + (id_eps-1)*10000 # actual id
	    #println("ID: $real_id, epsilon: $id_eps, mode: $mode"); flush(stdout) 
	    dispersions = readdlm(dispersion_dir*"dim2-sg$sg-$(real_id)-res64-$mode-dispersion.out", ',', Float64)[:, 6:end]
	    dispersionsv[id] = dispersions
        end
        filename = dispersion_dir*"sg$(sg)-epsid$(id_eps)-res64-$(mode).jld2"                
        jldopen(filename, "w") do fid
            fid["dispersionsv"] = dispersionsv
	end
    end
end

