sg = first(parse.(Int, ARGS))
using JLD2

println("Running Spacegroup: $sg")

idx_max = 10000
for mode in ["te", "tm"]
    println("mode: ", mode)
    flush(stdout)
    for id_eps in [1, 2, 3, 4, 5]
        println("id_eps: ", id_eps)
	flush(stdout)
        dir = "./logs/"
	logsv = String[]

        for id in 1:idx_max
            true_id  = id + (id_eps-1)*10000 # actual id
	    io = open(dir*"dim2-sg$sg-$(true_id)-res64-$(mode).log")
	    push!(logsv, read(io, String))
	    close(io)
	end
        filename = dir*"sg$(sg)-epsid$(id_eps)-res64-$(mode)-log.jld2"                
        jldopen(filename, "w") do fid
            fid["logsv"] = logsv
	end
    end
end

