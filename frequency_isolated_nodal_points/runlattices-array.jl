task_id, num_tasks, sgnum = parse.(Int, ARGS)
using Crystalline, MPBUtils, SymmetryBases, JLD2
println("task_id is $task_id")
println("num_tasks $num_tasks")
sg = sgnum

good_candidates_te  = Dict{Integer, Integer}() # Dictionary for each space group
good_candidates_tm  = Dict{Integer, Integer}() # Dictionary for each space group
id_eps = 3
    println("Calculating for id_eps: $id_eps"); flush(stdout)
    for mode = ["te", "tm"];
        dispersion_dir = "../dispersions/output/sg$sg/eps$(id_eps)/$mode/";
        loaded_dispersion_data = load(dispersion_dir*"sg$sg-epsid$(id_eps)-res64-$mode.jld2")
        cumsummariesv = loaded_dispersion_data["cumsummariesv"];
        for (id, cumsummaries) in enumerate(cumsummariesv)
            length(cumsummaries) < 1 && (println("id $id no cumsummaries"); continue)
            real_id = id + (10000)*(id_eps-1)
            shortened_summaries = cumsummaries[1:min(length(cumsummaries), 3)]
            shortened_summaries = filter(x -> x.topology == NONTRIVIAL, shortened_summaries)
            isempty(shortened_summaries) && continue
            top_band = maximum([x.band[end] for x in shortened_summaries])
            mode == "te" && push!(good_candidates_te,  real_id => top_band)
            mode == "tm" && push!(good_candidates_tm,  real_id => top_band)
        end
    end

sorted_good_candidates_te = sort(collect(good_candidates_te), by=x->x[1]);
sorted_good_candidates_tm = sort(collect(good_candidates_tm), by=x->x[1]);

num_samples_te = length(sorted_good_candidates_te)
num_samples_tm = length(sorted_good_candidates_tm)

println("Num samples te: $num_samples_te")
println("Num samples tm: $num_samples_tm")

for i in task_id:num_tasks:num_samples_te
	id, top_band = sorted_good_candidates_te[i]
	calcname = "dim2-sg$(sgnum)-$id-res64-te"
	#(isfile("./output/sg$sgnum/eps3/te/$calcname-dispersion.out") && !isempty(readlines("./output/sg$sgnum/eps3/te/$calcname-dispersion.out"))) && continue
	run(`./runlattice.sh $(calcname) $(sgnum) $(top_band+2)`)
	mv("./output/$calcname-dispersion.out", "./output/sg$sgnum/eps3/te/$calcname-dispersion.out", force=true)
end

for i in task_id:num_tasks:num_samples_tm
        id, top_band = sorted_good_candidates_tm[i]
        calcname = "dim2-sg$(sgnum)-$id-res64-tm"
	#(isfile("./output/sg$sgnum/eps3/tm/$calcname-dispersion.out") && !isempty(readlines("./output/sg$sgnum/eps3/tm/$calcname-dispersion.out"))) && continue
        run(`./runlattice.sh $(calcname) $(sgnum) $(top_band+2)`)
	mv("./output/$calcname-dispersion.out", "./output/sg$sgnum/eps3/tm/$calcname-dispersion.out", force=true)
end
