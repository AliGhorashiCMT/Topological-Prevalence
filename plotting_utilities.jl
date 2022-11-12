function wigner_plot(flat::Crystalline.AbstractFourierLattice{2}, Rs::DirectBasis{2}, c::Cell{2};
              N::Integer=150, 
              filling::Union{Real, Nothing}=0.5, 
              isoval::Union{Real, Nothing}=nothing,
              fig=nothing, 
              ax=nothing)

    xyz = range(-.75, .75, length=N)
    vals = Crystalline.calcfouriergridded(xyz, flat, N)
    if isnothing(isoval)
        isnothing(filling) && error(ArgumentError("`filling` and `isoval` cannot both be `nothing`"))
        # we don't want to "double count" the BZ edges - so to avoid that, exclude the last 
        # index of each dimension (same approach as in `MPBUtils.filling2isoval`)
        isoidxs = 1:(N-1)
        vals′ = (@view vals[isoidxs, isoidxs])
        isoval = quantile(Iterators.flatten(vals′), filling)
    end
    plotiso(xyz, vals, isoval, Rs, c, fig, ax)

    return xyz, vals, isoval
end

# plot isocontour of data
function plotiso(xyz, vals, isoval::Real, Rs::DirectBasis{2}, c::Cell{2},
                 fig=nothing,
                 ax=nothing)
    fig = (isnothing(fig) && isnothing(ax)) ? plt.figure() : fig
    ax = isnothing(ax) ? fig.add_subplot(projection="rectilinear") : ax

    N = length(xyz) 
    X = broadcast((x,y) -> x*Rs[1][1] + y*Rs[2][1], reshape(xyz,(1,N)), reshape(xyz, (N,1)))
    Y = broadcast((x,y) -> x*Rs[1][2] + y*Rs[2][2], reshape(xyz,(1,N)), reshape(xyz, (N,1)))
    ax.contourf(X,Y,vals; levels=(-1e12, isoval, 1e12), cmap=plt.get_cmap("gray",2))
    
    if setting(c) !== Brillouin.CARTESIAN
        c = Brillouin.cartesianize(c)
    end
    cxs, cys = getindex.(c[1], 1), getindex.(c[1], 2)
    push!(cxs, cxs[1]); push!(cys, cys[1])
    ax.plot(cxs, cys) # plot unit cell

    plt.xlim(-1,1); plt.ylim(-1,1);
    ax.set_aspect("equal", adjustable="box")
    ax.set_axis_off()
    
    return nothing
end