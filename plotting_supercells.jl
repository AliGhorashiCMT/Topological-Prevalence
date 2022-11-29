shapely_point = pyimport("shapely.geometry").Point
shapely_polygon = pyimport("shapely.geometry.polygon").Polygon

function supercell_plot(flat_bulk::Crystalline.AbstractFourierLattice{2}, flat_clad::Crystalline.AbstractFourierLattice{2}, Rs::DirectBasis{2}, c::Cell{2}, isoval_bulk::Real, isoval_clad::Real; N::Integer=500,  fig=nothing, ax=nothing, translation_vector::Vector{<:Real} = zeros(2), xyz::Union{AbstractRange, Nothing}=nothing, supercell::Integer=1)

    xyz = (isnothing(xyz) ? range(-0.75, 0.75, length=N) : xyz)
    vals_bulk = Crystalline.calcfouriergridded(xyz, flat_bulk, length(xyz))
    vals_clad = Crystalline.calcfouriergridded(xyz, flat_clad, length(xyz))
    vals_bulk = -(vals_bulk .< isoval_bulk).*1000 .+ 500
    vals_clad = -(vals_clad .< isoval_clad).*1000 .+ 500

    plotiso_supercell(xyz, vals_bulk, vals_clad, Rs, c, fig, ax, translation_vector, supercell)
end

function plotiso_supercell(xyz, vals_bulk, vals_clad, Rs::DirectBasis{2}, c::Cell{2},
                 fig=nothing, ax=nothing, translation_vector::Vector{<:Real}=zeros(2), supercell::Integer=1)
    
    fig = (isnothing(fig) && isnothing(ax)) ? plt.figure() : fig
    ax = isnothing(ax) ? fig.add_subplot(projection="rectilinear") : ax
    
    tx, ty = translation_vector

    N = length(xyz) 
    X = broadcast((x,y) -> (x+tx)*Rs[1][1] + (y+ty)*Rs[2][1], reshape(xyz,(1,N)), reshape(xyz, (N,1)))
    Y = broadcast((x,y) -> (x+tx)*Rs[1][2] + (y+ty)*Rs[2][2], reshape(xyz,(1,N)), reshape(xyz, (N,1)))
    
    if setting(c) !== Brillouin.CARTESIAN
        c = Brillouin.cartesianize(c)
    end
    cxs, cys = getindex.(c[1]*supercell, 1), getindex.(c[1]*supercell, 2)
    push!(cxs, cxs[1]); push!(cys, cys[1])

    ax.plot(cxs, cys) # plot unit cell
    polygon = shapely_polygon(c[1]*supercell)
    in_polygon_vals = (broadcast((x,y) -> polygon.contains(shapely_point(((x+tx)*Rs[1][1] + (y+ty)*Rs[2][1], (x+tx)*Rs[1][2] + (y+ty)*Rs[2][2]))), reshape(xyz,(1,N)), reshape(xyz, (N,1))))
    
    #vals = vals_bulk
    vals =  vals_bulk .* in_polygon_vals + vals_clad .* (1 .- in_polygon_vals)
    
    ax.contourf(X,Y,vals; levels=(-1e6, 0, 1e6), cmap=plt.get_cmap("gray", 2)) 
    ax.set_aspect("equal", adjustable="box")
    ax.set_axis_off()
 end