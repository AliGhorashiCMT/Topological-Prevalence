sgnum = first(parse.(Int, ARGS))
using JLD2
include("../get-freqs-symeigs.jl")
println("Running Spacegroup: $sgnum")
idx_max = 10000
for mode in ["te", "tm"]
    println("mode: ", mode)
    flush(stdout)
    for epsid in [1, 2, 3, 4, 5]
	println("epsid: $(epsid)"); flush(stdout)
	log_dir = "./logs/"	
	loaded_logs = load(log_dir * "sg$(sgnum)-epsid$(epsid)-res64-$(mode)-log.jld2")["logsv"];
	symeigs_dir = "./output/sg$(sgnum)/eps$(epsid)/$(mode)"
	for idx in 1:idx_max
		io = open(symeigs_dir * "/dim2-sg$(sgnum)-$(idx + (epsid-1)*10000)-res64-$(mode)-symeigs.out")
		symeigs_string = read(io, String)
		close(io)
		io = open(symeigs_dir * "/dim2-sg$(sgnum)-$(idx + (epsid-1)*10000)-res64-$(mode)-dispersion.out")
		dispersion_string = read(io, String)
		close(io)
		@assert logs_to_symeigs(loaded_logs[idx]) == symeigs_string "Failed symeigs consistency for idx: $(idx) mode: $(mode) and plane group $(sgnum) and epsid $(epsid)"
		@assert logs_to_dispersion(loaded_logs[idx], mode) == dispersion_string "Failed dispersion consistency for idx: $(idx) mode: $(mode) and plane group $(sgnum) and epsid $(epsid)"
	end
    end
end

