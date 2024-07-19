sgnum = first(parse.(Int, ARGS))
using JLD2, HDF5
sg_dir = "./"
collate_filename = "sg$(sgnum)-pwrs-and-epsilon.h5"
collate_dir = sg_dir
#Remove h5 file if already exists
isfile(collate_dir * collate_filename) && rm(collate_dir * collate_filename)

dir_list = readdir(sg_dir)
h5_files = filter(x -> endswith(x, "h5") && contains(x, "dpwr"), dir_list)
h5_files_split = [String.(x) for x in split.(h5_files, ".")]

id_nums_b = [parse(Int64, split(first(filter(x -> contains(x, "b"), y)), "b")[end]) for y in h5_files_split];
id_nums_k = [parse(Int64, split(first(filter(x -> contains(x, "k"), y)), "k")[end]) for y in h5_files_split];

epsilon_filenames = filter(x -> endswith(x, "h5") && contains(x, "epsilon"), dir_list)

h5open(collate_dir * collate_filename, "w") do file
    pwr_group = create_group(file, "pwrs")
    epsilon_group = create_group(file, "epsilon")
    for (k_id, band_id, pwr_filename) in zip(id_nums_k, id_nums_b, h5_files)
	println("Collating band $(band_id) and k $(k_id)"); flush(stdout)
	println("pwr_filename: $(pwr_filename)")
        pwr_h5 = h5open(sg_dir * pwr_filename)
	k_id_group = create_group(pwr_group, "band$(band_id)/k$(k_id)")
        pwr_keys = keys(pwr_h5)
        for key in pwr_keys
            k_id_group[key] = read(pwr_h5, key)
	    attributes(k_id_group[key])["filename"] = pwr_filename
        end
        close(pwr_h5)
    end
    for epsilon_filename in epsilon_filenames
        epsilon_h5 = h5open(sg_dir * epsilon_filename)
        epsilon_keys = keys(epsilon_h5)
    	epsilon_group_filename = create_group(epsilon_group, epsilon_filename)
        for key in epsilon_keys
            epsilon_group_filename[key] = read(epsilon_h5, key)
        end
	close(epsilon_h5)
    end
end

