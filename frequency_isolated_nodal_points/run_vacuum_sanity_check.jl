using Crystalline, MPBUtils, SymmetryBases, JLD2, DelimitedFiles, PyCall

loaded_data_sg2_lightline = load("sg2_lightline.jld2")["well_separated_nodal_points"];
loaded_data_sg10_lightline = load("sg10_lightline.jld2")["well_separated_nodal_points"];
loaded_data_sg16_lightline = load("sg16_lightline.jld2")["well_separated_nodal_points"];

loaded_data_lightlinev = [loaded_data_sg2_lightline, loaded_data_sg10_lightline, loaded_data_sg16_lightline]
sgnums = [2, 10, 16]

for (sgnum, loaded_data_lightline_sg) in zip(sgnums, loaded_data_lightlinev)
	(sgnum == 2) || continue
	has_nodal_point = filter(x -> !isempty(x[2]), loaded_data_lightline_sg);
	ids = [key[2] for (key, _) in has_nodal_point]
	ids = filter(x -> length(findall(y -> y == x, ids)) == 1, ids)
	rand_ids = rand(ids, 10);
	for (key, val) in has_nodal_point
		id = key[2]
		id in rand_ids || continue
		calcname = "dim2-sg$(sgnum)-$(id-20000)-res64-te"
		_, kidx, _ = val[1]
		kidx_zerobased = kidx - 1
		run(`./runlattice_lightline.sh $(calcname) $(sgnum) 10 $(kidx_zerobased)`)
		mv("./output/$calcname-dispersion-lightline.out", "./output/lightline/$calcname-dispersion.out", force=true)
	end
end

