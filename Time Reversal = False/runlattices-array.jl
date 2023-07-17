task_id, num_tasks = parse.(Int, ARGS)
println("task_id is $task_id")
println("num_tasks $num_tasks")
ids = 1:10000
for sgnum in [2, 10, 13, 16]
	for mode in ["te", "tm"]
		for id in task_id:num_tasks:ids[end]
			for (g_idx, g) in enumerate([0.1*16, 0.4*16, 0.7*16, 0.01*16])
				g_idx == 4 || continue
				exx = eyy = sqrt(g^2+16^2)
				ezz = 16
				println("\n\n")
				# We parameterize the output filename such that the different magnetic fields are batched in groups of size 10000
				run(`./runlattice.sh dim2-sg$sgnum-$id-res64-$mode dim2-sg$sgnum-$(id+(g_idx-1)*10000)-res64-$mode $sgnum $mode $exx $eyy $ezz $g $g_idx`)
			end 
		end
	end
end
