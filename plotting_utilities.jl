shapely_point = pyimport("shapely.geometry").Point
shapely_polygon = pyimport("shapely.geometry.polygon").Polygon

function wigner_plot(flat::Crystalline.AbstractFourierLattice{2}, Rs::DirectBasis{2}, c::Cell{2};
              N::Integer=500, 
              filling::Union{Real, Nothing}=0.5, 
              isoval::Union{Real, Nothing}=nothing,
              fig=nothing, 
              ax=nothing, in_polygon::Bool=false, translation_vector::Vector{<:Real} = zeros(2), xyz::Union{AbstractRange, Nothing}=nothing)

    xyz = (isnothing(xyz) ? range(-0.75, 0.75, length=N) : xyz) #xyz is the grid on which the Fourier lattice is calculated
    vals = Crystalline.calcfouriergridded(xyz, flat, length(xyz))
    if isnothing(isoval)
        isnothing(filling) && error(ArgumentError("`filling` and `isoval` cannot both be `nothing`"))
        isoidxs = 1:(N-1)
        vals′ = (@view vals[isoidxs, isoidxs])
        isoval = quantile(Iterators.flatten(vals′), filling) # Find the isovalue that gives the desired filling
    end
    plotiso(xyz, vals, isoval, Rs, c, fig, ax, in_polygon, translation_vector)

    return xyz, vals, isoval
end

# plot isocontour of data
function plotiso(xyz, vals, isoval::Real, Rs::DirectBasis{2}, c::Cell{2},
                 fig=nothing,
                 ax=nothing, in_polygon::Bool=false, translation_vector::Vector{<:Real}=zeros(2))
    fig = (isnothing(fig) && isnothing(ax)) ? plt.figure() : fig #If neither figure nor axis provided, make a new figure
    ax = isnothing(ax) ? fig.add_subplot(projection="rectilinear") : ax # If axis is not provided make a new axis
    
    tx, ty = translation_vector

    N = length(xyz) 
    X = broadcast((x,y) -> (x+tx)*Rs[1][1] + (y+ty)*Rs[2][1], reshape(xyz,(1,N)), reshape(xyz, (N,1))) #optional tx, ty translations
    Y = broadcast((x,y) -> (x+tx)*Rs[1][2] + (y+ty)*Rs[2][2], reshape(xyz,(1,N)), reshape(xyz, (N,1)))
    if setting(c) !== Brillouin.CARTESIAN
        c = Brillouin.cartesianize(c)
    end
    cxs, cys = getindex.(c[1], 1), getindex.(c[1], 2)
    push!(cxs, cxs[1]); push!(cys, cys[1]) # To make a closed loop for the wigner-seitz cell
    ax.plot(cxs, cys, color="black", linewidth=0.8) # plot unit cell
    polygon = shapely_polygon(c[1])
    vals = -(vals .< isoval).*1000 .+ 500
    in_polygon_vals = (broadcast((x,y) -> polygon.contains(shapely_point(((x+tx)*Rs[1][1] + (y+ty)*Rs[2][1], (x+tx)*Rs[1][2] + (y+ty)*Rs[2][2]))), reshape(xyz,(1,N)), reshape(xyz, (N,1)))) # Determine whether points on the grid are within the first Brillouin zone
    
    
    # old code vals = !in_polygon ? vals : vals .* in_polygon_vals
    vals = !in_polygon ? vals : (vals .* in_polygon_vals + 500*(1 .- in_polygon_vals)) #outside polygon, value of 500, inside polygon, value of -500 if below isovalue and value of 500 if above isovalue. 
    plt.xlim(-1,1); plt.ylim(-1,1);
    #= old code
    !in_polygon ? ax.contourf(X,Y,vals; levels=(-1e6, 0, 1e6 ), cmap=plt.get_cmap("gray", 2)) : ax.contourf(X,Y,vals; levels=(-1e6, -50, 50, 1e6 ), cmap=plt.get_cmap("gray", 3))
=#
        !in_polygon ? ax.contourf(X,Y,vals; levels=(-1e6, 0, 1e6 ), cmap=plt.get_cmap("gray", 2)) : ax.contourf(X,Y,vals; levels=(-1e6, -1000, 50, 1e6 ), cmap=plt.get_cmap("gray", 3)) # Three values in cmap so we get a gray-white combination. 

        
    ax.set_aspect("equal", adjustable="box")
    ax.set_axis_off()
    
    return nothing
end