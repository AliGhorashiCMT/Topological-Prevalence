sg = first(parse.(Int, ARGS))
using JLD2, HDF5
println("Running Spacegroup: $sg")
idx_max = 10000

for mode in ["te"]
    println("mode: ", mode)
    flush(stdout)
    for id_eps in [1]
        dir = "./output/sg$sg/eps$(id_eps)/$mode/"
        println("id_eps: ", id_eps)
        flush(stdout)
        h5open("sg$sg-eps$(id_eps)-epsilon.h5", "w") do file
            for id in 1:idx_max
                true_id  = id + (id_eps-1)*10000 # actual id
		(id % 20 == 0) && (println("true_id: $(true_id)"); flush(stdout))
                epsilon = h5read(dir*"dim2-sg$(sg)-$(true_id)-res64-$(mode)-epsilon.h5", "data")
                sg_group = create_group(file, "sg$sg/$id")
                sg_group["epsilon"] = epsilon
            end
        end
    end
end

