task_id, num_tasks = parse.(Int, ARGS)
println("task_id is $task_id")
println("num_tasks $num_tasks")
epsidx=4
eps=24
ids = 1:10000
for sgnum in [2, 6, 9, 10, 11, 12, 13, 14, 15, 16, 17]
	for mode in ["te", "tm"]
		for id in task_id:num_tasks:ids[end]
			println("\n\n")
			run(`./runlattice-eps4and5.sh dim2-sg$sgnum-$id-res64-$mode dim2-sg$sgnum-$((epsidx-1)*10000+id)-res64-$mode $epsidx $eps $sgnum`)
		end
	end
end
