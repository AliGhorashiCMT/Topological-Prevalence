shapely_point = pyimport("shapely.geometry").Point
shapely_polygon = pyimport("shapely.geometry.polygon").Polygon

function bulk_vals(val, isoval)
    val < isoval ? 500 : 10000
end
function clad_vals(val, isoval)
    val < isoval ? -500 : 10000
end

function supercell_plot(flat_bulk::Crystalline.AbstractFourierLattice{2}, flat_clad::Crystalline.AbstractFourierLattice{2}, Rs::DirectBasis{2}, c::Cell{2}, isoval_bulk::Real, isoval_clad::Real; N::Integer=500,  fig=nothing, ax=nothing, translation_vector::Vector{<:Real} = zeros(2), xyz::Union{AbstractRange, Nothing}=nothing, supercell::Integer=1, kwargs...)

    xyz = (isnothing(xyz) ? range(-0.75, 0.75, length=N) : xyz)
    
    vals_bulk = Crystalline.calcfouriergridded(xyz, flat_bulk, length(xyz)) # Calculate fourier lattice values for bulk 
    vals_clad = Crystalline.calcfouriergridded(xyz, flat_clad, length(xyz)) # Calculate fourier lattice values for cladding
    
    vals_bulk = bulk_vals.(vals_bulk, Ref(isoval_bulk))#-(vals_bulk .< isoval_bulk).*600 .+ 300
    vals_clad = clad_vals.(vals_clad, Ref(isoval_clad))#-(vals_clad .< isoval_clad).*300 .+ 150

    plotiso_supercell(xyz, vals_bulk, vals_clad, Rs, c, fig, ax, translation_vector, supercell; kwargs...)
end

function plotiso_supercell(xyz, vals_bulk, vals_clad, Rs::DirectBasis{2}, c::Cell{2},
                 fig=nothing, ax=nothing, translation_vector::Vector{<:Real}=zeros(2), supercell::Integer=1; plot_boundary::Bool=false,
        vert_idxs::Union{Vector{<:Integer}, Nothing}=nothing, relative_shift::Vector{<:Integer}=[0, 0], kwargs...)
    
    fig = (isnothing(fig) && isnothing(ax)) ? plt.figure() : fig # if neither fig nor ax provided, make a new figure
    ax = isnothing(ax) ? fig.add_subplot(projection="rectilinear") : ax # if ax not provided, make a new axis
    
    tx, ty = translation_vector

    N = length(xyz) 
    X = broadcast((x,y) -> (x+tx)*Rs[1][1] + (y+ty)*Rs[2][1], reshape(xyz,(1,N)), reshape(xyz, (N,1)))
    Y = broadcast((x,y) -> (x+tx)*Rs[1][2] + (y+ty)*Rs[2][2], reshape(xyz,(1,N)), reshape(xyz, (N,1)))
    
    if setting(c) !== Brillouin.CARTESIAN
        c = Brillouin.cartesianize(c)
    end
    cxs, cys = isnothing(vert_idxs) ? (getindex.(c[1]*supercell, 1), getindex.(c[1]*supercell, 2)) :  (getindex.(c[1][vert_idxs]*supercell, 1), getindex.(c[1][vert_idxs]*supercell, 2)) # multiply wigner-seitz cells by supercell size
    push!(cxs, cxs[1]); push!(cys, cys[1]) # push the first vertex to list of vertices so as to close the loop

    plot_boundary &&  ax.plot(cxs, cys)  # plot unit cell
    polygon = isnothing(vert_idxs) ? shapely_polygon(c[1]*supercell) : shapely_polygon(c[1][vert_idxs]*supercell)
    in_polygon_vals = (broadcast((x,y) -> polygon.contains(shapely_point(((x+tx)*Rs[1][1] + (y+ty)*Rs[2][1], (x+tx)*Rs[1][2] + (y+ty)*Rs[2][2]))), reshape(xyz,(1,N)), reshape(xyz, (N,1))))
    
    #vals = vals_bulk
    vals =  vals_bulk .* in_polygon_vals + np.roll(vals_clad, relative_shift, axis=[1, 0]) .* (1 .- in_polygon_vals)
    # Relative shift takes into account whether we have shifted the cladding wrt the bulk (for instance when we use the same crystal for both just with a relative shift to make one have nonzero corner charge
    
    #ax.contourf(X,Y,vals; levels=(-1e6, 0, 1e6), cmap=plt.get_cmap("gray", 2), kwargs...) 
    ax.contourf(X,Y,vals; levels=(-1e6, -1000, 0, 1000, 1e6), cmap=plt.get_cmap("gray", 4), kwargs...) 
    ax.set_aspect("equal", adjustable="box")
    ax.set_axis_off()
 end