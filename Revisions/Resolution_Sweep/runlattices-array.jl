task_id, num_tasks = parse.(Int, ARGS)
println("task_id is $task_id")
println("num_tasks $num_tasks")

flush(stdout)

using JLD2
ids = 1:10000
epses = [8, 12, 16, 24, 32]
eps_id = 3
resolutionv = [8, 12, 16, 24, 32, 48, 128, 256]
#resolutionv = [8, 12, 16, 24, 32, 48, 128]
eps = epses[eps_id]
for sgnum in [2, 10, 13, 16]
	for mode in ["te", "tm"]
		dir = "../../symeigs/input/"
		loaded_datav = load(dir*"sg$sgnum-epsid1-res64-$mode-input.jld2")["inputsv"]
		for id in task_id:num_tasks:ids[end]
			loaded_data = loaded_datav[id]
			for (res_idx, resolution) in enumerate(resolutionv)
				println("\n\n")
				real_id = id + (eps_id - 1)*10000
				symeigs_dispersions_dir = "./output/sg$(sgnum)/eps$(eps_id)/$(mode)/res$(res_idx)/"
				savename = "dim2-sg$(sgnum)-$(real_id)-res$(resolution)-$(mode)"
				symeigs_filename = symeigs_dispersions_dir*savename*"-symeigs.out"; dispersions_filename = symeigs_dispersions_dir*savename*"-dispersion.out"
				if (isfile(symeigs_filename) && isfile(dispersions_filename))
					println("Detected that calculation for spacegroup $(sgnum) for id: $(real_id), mode $(mode) and resolution $(resolution) exists. Skipping...");
					flush(stdout)
					continue
				end
				println("Running calculation for spacegroup $(sgnum) for id: $(real_id), mode $(mode) and resolution $(resolution): ")
				#resolution > 100 || continue # Run the new resolutions
				run(`./runlattice.sh $(loaded_data) $(sgnum) $(eps_id) $(eps) $(mode) $(res_idx) $(resolution) $(savename)`)
				#run(`./runlattice.sh dim2-sg$sgnum-$(real_id)-res64-$mode
				 #$(sgnum) $(eps_id) $(res_idx) $(resolution) dim2-sg$sgnum-$(real_id)-res$(resolution)-$mode`)
			end 
		end
	end
end
