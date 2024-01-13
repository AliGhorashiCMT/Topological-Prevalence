task_id, num_tasks = parse.(Int, ARGS)
println("task_id is $task_id")
println("num_tasks $num_tasks")
ids = 1:1000
eps_id = 3
for sgnum in [2, 10, 13, 16]
	for mode in ["te", "tm"]
		for id in task_id:num_tasks:ids[end]
			for (res_idx, resolution) in enumerate([8, 12, 16, 24, 32, 48])
				real_id = id + (eps_id - 1)*10000
				println("\n\n")
				run(`./runlattice.sh dim2-sg$sgnum-$(real_id)-res64-$mode $(sgnum) $(eps_id) $(res_idx) $(resolution) dim2-sg$sgnum-$(real_id)-res$(resolution)-$mode`)
			end 
		end
	end
end
