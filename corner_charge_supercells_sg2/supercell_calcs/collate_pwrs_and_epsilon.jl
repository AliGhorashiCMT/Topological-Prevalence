using JLD2, HDF5

sg2_dir = "./"
dir_list = readdir(sg2_dir)
h5_files = filter(x->endswith(x, "h5") && contains(x, "dpwr"), dir_list)
h5_files = [String.(x) for x in split.(h5_files, ".")]
id_nums = [parse(Int64, split(first(filter(x -> contains(x, "b"), y)), "b")[end]) for y in h5_files]

idx_min = minimum(id_nums)
idx_max = maximum(id_nums)

collate_filename = "sg2-pwrs-and-epsilon.h5"
collate_dir = "./output/"

h5open(collate_dir * collate_filename, "w") do file
    pwr_group = create_group(file, "pwrs")
    epsilon_group = create_group(file, "epsilon")
    for id in idx_min:idx_max
	println("Collating band $(id)"); flush(stdout)
        pwr_filename = "dim2-sg2-29558-res16-te-corner-dpwr.k01.b$(id).te.h5"        
        pwr_h5 = h5open(sg2_dir * pwr_filename)
        id_group = create_group(pwr_group, "band$(id)")
        pwr_keys = keys(pwr_h5)
        for key in pwr_keys
            id_group[key] = read(pwr_h5, key)
        end
        close(pwr_h5)
    end
    epsilon_filename = "dim2-sg2-29558-res16-te-corner-epsilon.h5"
    epsilon_h5 = h5open(sg2_dir * epsilon_filename)
    epsilon_keys = keys(epsilon_h5)
    
    for key in epsilon_keys
        epsilon_group[key] = read(epsilon_h5, key)
    end
    close(epsilon_h5)
end

