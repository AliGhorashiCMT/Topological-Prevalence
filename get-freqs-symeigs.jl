function logs_to_dispersion(logstr::String, mode::String)
    split_log = split(logstr, "\n");
    filtered_split_log = filter(x -> startswith(x, "$(mode)freqs"), split_log)[2:end]
    filtered_split_log = replace.(filtered_split_log, "$(mode)freqs:, " => "", " " =>"")
    filtered_split_log = [x * "\n" for x in filtered_split_log]
    return prod(filtered_split_log)
end;
function logs_to_dispersion(logstr::String)
	mode = if contains(logstr, "run-type=\"te\"") 
			"te"
		elseif contains(logstr, "run-type=\"tm\"")
		 	"tm"
		else
			error("Could not determine mode")
		end
	logs_to_dispersion(logstr, mode)
end

function logs_to_symeigs(logstr::String)
    split_log = split(logstr, "\n");
    filtered_split_log = filter(x -> startswith(x, "sym-eigs:"), split_log)
    filtered_split_log = replace.(filtered_split_log, "sym-eigs:, " => "", " " =>"", "("=>"\"", ")"=>"\"")
    filtered_split_log = [x * "\n" for x in filtered_split_log]
    return prod(filtered_split_log)
end;
