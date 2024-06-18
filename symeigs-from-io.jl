# We recreate _read_symdata from MPBUtils such that it does not have to rely on a particular format of file output. In particular, in the below, one can send 
# an io of the total log output (stored in jld2 files in our case) 
import MPBUtils: _read_symdata

function _read_symdata(io::IOBuffer, sgnum::Int, Dᵛ::Val{D},
        αβγ::AbstractVector{<:Real},
            isprimitive::Bool, flip_ksign::Bool) where D

    logstr = String(take!(io))

    disp_str = logs_to_dispersion(logstr)
    symeigs_str = logs_to_symeigs(logstr)

    disp_str_io = IOBuffer(disp_str)
    symeigs_str_io = IOBuffer(symeigs_str)

    # prepare default little groups of associated space group
    lgs⁰  = littlegroups(sgnum, Dᵛ)
    isprimitive && map!(g -> primitivize(g, #=modw=# false), values(lgs⁰)) # primitivize

    # read mpb dispersion data; use to guarantee frequency sorting at each k-point
    dispersion_data = readdlm(disp_str_io, ',', Float64)::Matrix{Float64}
    kvs = collect(eachrow(@view dispersion_data[:,2:2+(D-1)]))
    Nk = length(kvs)
    freqs = dispersion_data[:,6:end]
    Nbands = size(freqs, 2)
    sortidxs = [sortperm(freqs_at_fixed_k) for freqs_at_fixed_k in eachrow(freqs)]

    # read mpb symmetry data, mostly as Strings (first column is Int)
    untyped_data = readdlm(symeigs_str_io, ',', String; quotes=true)::Matrix{String}
    close(symeigs_str_io)
    close(disp_str_io)
    Nrows = size(untyped_data, 1)
    # process raw symmetry & operator data
    lgopsd   = Dict{String, Vector{SymOperation{D}}}()    # indexing: [klabel][op]
    symeigsd = Dict{String, Vector{Vector{ComplexF64}}}() # indexing: [klabel][band][op]
    rowidx = 1
    for kidx in 1:Nk
        kv = flip_ksign ? -kvs[kidx] : kvs[kidx] # `flip_ksign` is a hack to work around 
                                                 # phase convention issues; there be dragons
        klab = findfirst(lg->isapprox(position(lg)(αβγ), kv, atol=1e-6), lgs⁰)
        klab === nothing && error("could not find matching KVec for loaded kv = $kv")
        lgopsd[klab]   = Vector{SymOperation{D}}()
        symeigsd[klab] = [Vector{ComplexF64}() for _ in 1:Nbands]
        while rowidx ≤ Nrows && parse(Int, untyped_data[rowidx, 1])::Int == kidx
            op = SymOperation{D}(strip(untyped_data[rowidx, 2], '"'))
            push!(lgopsd[klab], op)
            # symmetry eigenvalues at `op` (and `klab`) across all bands (frequency sorted)
            symeigs = parse.(ComplexF64, @view untyped_data[rowidx, 3:end][sortidxs[kidx]])
            push!.(symeigsd[klab], symeigs) # broadcast over band indices
            rowidx += 1
        end
    end

    # build little groups
    lgd = Dict(klab => LittleGroup{D}(sgnum, position(lgs⁰[klab]), klab, ops)
               for (klab, ops) in lgopsd)::Dict{String, LittleGroup{D}}

    return symeigsd, lgd
end

