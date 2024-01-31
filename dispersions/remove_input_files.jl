sg = first(parse.(Int, ARGS))
using JLD2
println("Running Spacegroup: $sg")
idx_max = 10000
for mode in ["te", "tm"]
    println("mode: ", mode)
    flush(stdout)
    for id_eps in [2, 3]
        println("id_eps: ", id_eps, "\n")
	flush(stdout)
        dir = "./input/"
        for id in 1:idx_max
            true_id  = id + (id_eps-1)*10000 # actual id
	    println("Removing id: $true_id"); flush(stdout);
	    rm(dir*"dim2-sg$sg-$(true_id)-res64-$(mode).sh")
	end
    end
end

