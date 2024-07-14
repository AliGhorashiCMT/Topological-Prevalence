sgnum = first(parse.(Int, ARGS))

using JLD2, HDF5

sg_dir = "./output/sg$(sgnum)/"
collate_filename = "sg$(sgnum)-pwrs-and-epsilon.h5"
collate_dir = sg_dir
#Remove h5 file if already exists
isfile(collate_dir * collate_filename) && rm(collate_dir * collate_filename)

dir_list = readdir(sg_dir)
h5_files = filter(x -> endswith(x, "h5") && contains(x, "dpwr"), dir_list)
h5_files_split = [String.(x) for x in split.(h5_files, ".")]
id_nums = [parse(Int64, split(first(filter(x -> contains(x, "b"), y)), "b")[end]) for y in h5_files_split]

idx_min = minimum(id_nums)
idx_max = maximum(id_nums)

epsilon_filenames = filter(x -> endswith(x, "h5") && contains(x, "epsilon"), dir_list)
@assert length(epsilon_filenames) == 1
epsilon_filename = first(epsilon_filenames)

h5open(collate_dir * collate_filename, "w") do file
    pwr_group = create_group(file, "pwrs")
    epsilon_group = create_group(file, "epsilon")
    for (id, pwr_filename) in zip(id_nums, h5_files)
	println("Collating band $(id)"); flush(stdout)
	println("pwr_filename: $(pwr_filename)")
        pwr_h5 = h5open(sg_dir * pwr_filename)
        id_group = create_group(pwr_group, "band$(id)")
        pwr_keys = keys(pwr_h5)
        for key in pwr_keys
            id_group[key] = read(pwr_h5, key)
        end
        close(pwr_h5)
    end
    epsilon_h5 = h5open(sg_dir * epsilon_filename)
    epsilon_keys = keys(epsilon_h5)
    
    for key in epsilon_keys
        epsilon_group[key] = read(epsilon_h5, key)
    end
    close(epsilon_h5)
end

