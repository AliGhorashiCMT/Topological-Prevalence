using DelimitedFiles
task_id, num_tasks = parse.(Int, ARGS)
println("task_id is $task_id")
println("num_tasks is $num_tasks");
flush(stdout);
for epsidx in 1:3
	ids = 1:10000 
	for sgnum in [2, 10]
		for mode in ["te", "tm"]
			for id in task_id:num_tasks:ids[end]
				dispersion_dir = "./output/sg$sgnum/eps$(epsidx)/$mode/"
				println("\n\n")
				try
					readdlm(dispersion_dir*"dim2-sg$sgnum-$(id+10000*(epsidx-1))-res64-$mode-dispersion.out", ',')[:, 6:end]
				catch 
					println("Failure: $(id+10000*(epsidx-1)), Mode: $mode"); flush(stdout)
					run(`./runlattice.sh dim2-sg$sgnum-$(id + 10000*(epsidx-1))-res64-$mode $epsidx $sgnum`)
				end
			end
		end
	end
end
