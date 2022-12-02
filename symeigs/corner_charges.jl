"""
General function to return the symmetry vector and the corresponding irrep labels
"""
function n_irlabs(bandsummary::BandSummary)
    irlabs = bandsummary.brs.irlabs
    n = bandsummary.n
    return n, irlabs
end

"""
Returns the difference in the number of bands in a certain representation at one k point and the number of bands in a certain representation 
at another k point.
"""
function find_diff(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, k1labs::Vector{<:AbstractString},
    k2labs::Vector{<:AbstractString})
    
    k1_idxs = findall(x-> ∈(x, k1labs), irlabs)
    k2_idxs = findall(x-> ∈(x, k2labs), irlabs)
 
    return sum(n[k1_idxs]) - sum(n[k2_idxs])
end


corner_c2(x1::Real, x2::Real, x3::Real) =  mod(1/4*(-x1 -x2 + x3), 1)
corner_c3(x::Real) =  mod(1/3*x, 1)
corner_c4(x1::Real, x2::Real, x3::Real) =  mod(1/4*(x1 + 2*x2 + 3*x3), 1)
corner_c6(x1::Real, x2::Real) =  mod(1/4*x1 + 1/6*x2, 1)

polarization_c2(x1::Real, x2::Real) = [mod(1/2*x1, 1), mod(1/2*x2, 1)]
polarization_c3(x1::Real, x2::Real) = mod(2/3*x1 + 4/3*x2, 1)*[1, 1]
polarization_c4(x::Real) = mod(1/2*x, 1)*[1, 1]


function corners(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    sgnum = bandsummary.brs.sgnum
    if sgnum == 2
        return corner_sg2(bandsummary, wyckoff)
    elseif sgnum == 6
        return corner_sg6(bandsummary, wyckoff)
    elseif sgnum == 9
        return corner_sg9(bandsummary, wyckoff)
    elseif sgnum == 10
        return corner_sg10(bandsummary, wyckoff)
    elseif sgnum == 11
        return corner_sg11(bandsummary, wyckoff)
    elseif sgnum == 12
        return corner_sg12(bandsummary, wyckoff)
    elseif sgnum == 13
        return corner_sg13(bandsummary, wyckoff)
    elseif sgnum == 14
        return corner_sg14(bandsummary, wyckoff)
    elseif sgnum == 15
        return corner_sg15(bandsummary, wyckoff)
    elseif sgnum == 16
        return corner_sg16(bandsummary, wyckoff)
    elseif sgnum == 17
        return corner_sg17(bandsummary, wyckoff)
    end
end

function polarizations(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    sgnum = bandsummary.brs.sgnum
    if sgnum == 2
        return polarization_sg2(bandsummary, wyckoff)
    elseif sgnum == 6
        return polarization_sg6(bandsummary, wyckoff)
    elseif sgnum == 9
        return polarization_sg9(bandsummary, wyckoff)
    elseif sgnum == 10
        return polarization_sg10(bandsummary, wyckoff)
    elseif sgnum == 11
        return polarization_sg11(bandsummary, wyckoff)
    elseif sgnum == 12
        return polarization_sg12(bandsummary, wyckoff)
    elseif sgnum == 13
        return polarization_sg13(bandsummary, wyckoff)
    elseif sgnum == 14
        return polarization_sg14(bandsummary, wyckoff)
    elseif sgnum == 15
        return polarization_sg15(bandsummary, wyckoff)
    elseif sgnum == 16
        return polarization_sg16(bandsummary, wyckoff)
    elseif sgnum == 17
        return polarization_sg17(bandsummary, wyckoff)
    end
end

function corner_sg2(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg2(n, irlabs, wyckoff)
end

function corner_sg6(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg6(n, irlabs, wyckoff)
end

function corner_sg9(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg9(n, irlabs, wyckoff)
end

function corner_sg10(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg10(n, irlabs, wyckoff)
end

function corner_sg11(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg11(n, irlabs, wyckoff)
end

function corner_sg12(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg12(n, irlabs, wyckoff)
end

function corner_sg13(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg13(n, irlabs, wyckoff)
end

function corner_sg14(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg14(n, irlabs, wyckoff)
end

function corner_sg15(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg15(n, irlabs, wyckoff)
end

function corner_sg16(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg16(n, irlabs, wyckoff)
end

function corner_sg17(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return corner_sg17(n, irlabs, wyckoff)
end

function polarization_sg2(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg2(n, irlabs, wyckoff)
end

function polarization_sg6(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg6(n, irlabs, wyckoff)
end

function polarization_sg9(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg9(n, irlabs, wyckoff)
end

function polarization_sg10(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg10(n, irlabs, wyckoff)
end

function polarization_sg11(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg11(n, irlabs, wyckoff)
end

function polarization_sg12(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg12(n, irlabs, wyckoff)
end

function polarization_sg13(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg13(n, irlabs, wyckoff)
end

function polarization_sg14(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg14(n, irlabs, wyckoff)
end

function polarization_sg15(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg15(n, irlabs, wyckoff)
end

function polarization_sg16(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg16(n, irlabs, wyckoff)
end

function polarization_sg17(bandsummary::BandSummary, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    n, irlabs = n_irlabs(bandsummary)
    return polarization_sg17(n, irlabs, wyckoff)
end


function corner_sg2(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    # In order- B, Y, A
    diffX, diffY, diffM =
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["B₁"],  ["Γ₁"]),
            find_diff(n, irlabs, ["Y₁"],  ["Γ₁"]),
            find_diff(n, irlabs, ["A₁"],  ["Γ₁"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([0, 1/2]))
            find_diff(n, irlabs, ["B₁"],  ["Γ₁"]),
            find_diff(n, irlabs, ["Y₂"],  ["Γ₁"]),
            find_diff(n, irlabs, ["A₂"],  ["Γ₁"])
        elseif wyckoff == WyckoffPosition(1, 'c', RVec([1/2, 0]))
            find_diff(n, irlabs, ["B₂"],  ["Γ₁"]),
            find_diff(n, irlabs, ["Y₁"],  ["Γ₁"]),
            find_diff(n, irlabs, ["A₂"],  ["Γ₁"])
        elseif wyckoff == WyckoffPosition(1, 'd', RVec([1/2, 1/2]))
            find_diff(n, irlabs, ["B₂"],  ["Γ₁"]),
            find_diff(n, irlabs, ["Y₂"],  ["Γ₁"]),
            find_diff(n, irlabs, ["A₁"],  ["Γ₁"])
        end
    return corner_c2(diffX, diffY, diffM)
end

function polarization_sg2(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    # In order- B, Y, A
    diffX, diffY, diffM =
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["B₁"],  ["Γ₁"]),
            find_diff(n, irlabs, ["Y₁"],  ["Γ₁"]),
            find_diff(n, irlabs, ["A₁"],  ["Γ₁"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([0, 1/2]))
            find_diff(n, irlabs, ["B₁"],  ["Γ₁"]),
            find_diff(n, irlabs, ["Y₂"],  ["Γ₁"]),
            find_diff(n, irlabs, ["A₂"],  ["Γ₁"])
        elseif wyckoff == WyckoffPosition(1, 'c', RVec([1/2, 0]))
            find_diff(n, irlabs, ["B₂"],  ["Γ₁"]),
            find_diff(n, irlabs, ["Y₁"],  ["Γ₁"]),
            find_diff(n, irlabs, ["A₂"],  ["Γ₁"])
        elseif wyckoff == WyckoffPosition(1, 'd', RVec([1/2, 1/2]))
            find_diff(n, irlabs, ["B₂"],  ["Γ₁"]),
            find_diff(n, irlabs, ["Y₂"],  ["Γ₁"]),
            find_diff(n, irlabs, ["A₁"],  ["Γ₁"])
        end
    return polarization_c2(diffY + diffM, diffX + diffM)
end


function corner_sg6(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    
    diffX, diffY, diffM = 
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["X₁", "X₂"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₁", "Y₂"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["S₁", "S₂"],  ["Γ₁", "Γ₂"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([0, 1/2]))
            find_diff(n, irlabs, ["X₁", "X₂"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₃", "Y₄"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["S₃", "S₄"],  ["Γ₁", "Γ₂"])
        elseif wyckoff == WyckoffPosition(1, 'c', RVec([1/2, 0]))
            find_diff(n, irlabs, ["X₃", "X₄"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₁", "Y₂"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["S₃", "S₄"],  ["Γ₁", "Γ₂"])
        elseif wyckoff == WyckoffPosition(1, 'd', RVec([1/2, 1/2]))
            find_diff(n, irlabs, ["X₃", "X₄"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₃", "Y₄"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["S₁", "S₂"],  ["Γ₁", "Γ₂"])
        end
    return corner_c2(diffX, diffY, diffM)
end


function polarization_sg6(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    # In order- B, Y, A
    diffX, diffY, diffM = 
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["X₁", "X₂"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₁", "Y₂"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["S₁", "S₂"],  ["Γ₁", "Γ₂"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([0, 1/2]))
            find_diff(n, irlabs, ["X₁", "X₂"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₃", "Y₄"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["S₃", "S₄"],  ["Γ₁", "Γ₂"])
        elseif wyckoff == WyckoffPosition(1, 'c', RVec([1/2, 0]))
            find_diff(n, irlabs, ["X₃", "X₄"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₁", "Y₂"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["S₃", "S₄"],  ["Γ₁", "Γ₂"])
        elseif wyckoff == WyckoffPosition(1, 'd', RVec([1/2, 1/2]))
            find_diff(n, irlabs, ["X₃", "X₄"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₃", "Y₄"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["S₁", "S₂"],  ["Γ₁", "Γ₂"])
        end
    
    return polarization_c2(diffY + diffM, diffX + diffM)
end

function corner_sg9(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(2, 'a', RVec([0, 0])))
    
    diffX, diffY, diffM = 
    if wyckoff == WyckoffPosition(2, 'a', RVec([0, 0]))
        find_diff(n, irlabs, ["S₁"], ["Γ₁", "Γ₂"]),
        find_diff(n, irlabs,["S₁"] , ["Γ₁", "Γ₂"]),
        find_diff(n, irlabs, ["Y₁", "Y₂"],  ["Γ₁", "Γ₂"])
    elseif wyckoff == WyckoffPosition(2, 'b', RVec([0, 1/2]))
        find_diff(n, irlabs, ["S₂"], ["Γ₁", "Γ₂"]),
        find_diff(n, irlabs,["S₂"] , ["Γ₁", "Γ₂"]),
        find_diff(n, irlabs, ["Y₁", "Y₂"],  ["Γ₁", "Γ₂"])
    end
    return corner_c2(diffX, diffY, diffM)
end

function polarization_sg9(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(2, 'a', RVec([0, 0])))
    
    diffX, diffY, diffM = 
        if wyckoff == WyckoffPosition(2, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["S₁"], ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs,["S₁"] , ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₁", "Y₂"],  ["Γ₁", "Γ₂"])
        elseif wyckoff == WyckoffPosition(2, 'b', RVec([0, 1/2]))
            find_diff(n, irlabs, ["S₂"], ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs,["S₂"] , ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["Y₁", "Y₂"],  ["Γ₁", "Γ₂"])
        end
    return polarization_c2(diffY + diffM, diffX + diffM)
end

function corner_sg16(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
        diff2 = find_diff(n, irlabs, ["K₁"],  ["Γ₁",  "Γ₂"])
        diff1 = find_diff(n, irlabs, ["M₁"],  ["Γ₁"])
        diff11 = 2*find_diff(n, irlabs, [""],  ["Γ₃Γ₅"])
        return corner_c6(diff1+diff11, diff2)
    end
end

function corner_sg17(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    
    diff2 = find_diff(n, irlabs, ["K₁",  "K₂"],  ["Γ₁",  "Γ₂", "Γ₃", "Γ₄" ])
    diff1 = find_diff(n, irlabs, ["M₁", "M₂"],  ["Γ₁", "Γ₂"])
    diff11 = 2*find_diff(n, irlabs, [""],  ["Γ₅"])

    return corner_c6(diff1+diff11, diff2)
end

function polarization_sg16(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))    
    return zeros(2)
end

function polarization_sg17(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    return zeros(2)
end

function corner_sg13(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    diffK =        
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["K₂"],  ["Γ₂Γ₃"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([1/3, 2/3]))
            find_diff(n, irlabs, ["K₁"],  ["Γ₂Γ₃"])
        elseif wyckoff == WyckoffPosition(1, 'c', RVec([2/3, 1/3]))
            find_diff(n, irlabs, ["K₃"],  ["Γ₂Γ₃"])
        end
    corner_c3(diffK)
end

function polarization_sg13(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    diffK1, diffK2 = 
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["K₁"],  ["Γ₁"]), 
            find_diff(n, irlabs, ["K₂"],  ["Γ₂Γ₃"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([1/3, 2/3]))
            find_diff(n, irlabs, ["K₃"],  ["Γ₁"]),
            find_diff(n, irlabs, ["K₁"],  ["Γ₂Γ₃"])
        elseif wyckoff == WyckoffPosition(1, 'c', RVec([2/3, 1/3]))
            find_diff(n, irlabs, ["K₂"],  ["Γ₁"]),
            find_diff(n, irlabs, ["K₃"],  ["Γ₂Γ₃"])
        end
    polarization_c3(diffK1, diffK2)
end

function corner_sg14(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    diffK = 
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["K₂"], ["Γ₃"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([1/3, 2/3]))
            find_diff(n, irlabs, ["K₁"], ["Γ₃"])
        elseif wyckoff == WyckoffPosition(1, 'c', RVec([2/3, 1/3]))
            find_diff(n, irlabs, ["K₃"], ["Γ₃"])
        end
    return corner_c3(diffK)
end

function polarization_sg14(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    diffK1, diffK2 = 
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["K₁"],  ["Γ₁", "Γ₂"]), 
            find_diff(n, irlabs, ["K₂"],  ["Γ₃"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([1/3, 2/3]))
            find_diff(n, irlabs, ["K₃"],  ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["K₁"],  ["Γ₃"])
        elseif wyckoff == WyckoffPosition(1, 'c', RVec([2/3, 1/3]))
            find_diff(n, irlabs, ["K₂"], ["Γ₁", "Γ₂"]),
            find_diff(n, irlabs, ["K₃"],  ["Γ₃"])
        end
    return polarization_c3(diffK1, diffK2)
end

function corner_sg15(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    diffK = 
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["K₃"], ["Γ₃"])
        elseif wyckoff == WyckoffPosition(2, 'b', RVec([1/3, 2/3]))
            find_diff(n, irlabs, ["K₁", "K₂"], ["Γ₃"])
        elseif wyckoff == WyckoffPosition(2, 'c', RVec([2/3, 1/3]))
            find_diff(n, irlabs, ["K₃"], ["Γ₃"])
        end
    return corner_c3(diffK)
end

function polarization_sg15(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    diffK1, diffK2 = 
    if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
        find_diff(n, irlabs, ["K₁", "K₂"], ["Γ₁", "Γ₂"]), 
        find_diff(n, irlabs, ["K₃"], ["Γ₃"])
    elseif wyckoff == WyckoffPosition(2, 'b', RVec([1/3, 2/3]))
        find_diff(n, irlabs, ["K₃"], ["Γ₁", "Γ₂"]), 
        find_diff(n, irlabs, ["K₁", "K₂"], ["Γ₃"])
    elseif wyckoff == WyckoffPosition(2, 'c', RVec([2/3, 1/3]))
        find_diff(n, irlabs, ["K₃"], ["Γ₁", "Γ₂"]), 
        find_diff(n, irlabs, ["K₃"], ["Γ₃"])
    end
    
    return polarization_c3(diffK1, diffK2)
end

function corner_sg10(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
   
    diffX, diffM1, diffM2 = 
    if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
        find_diff(n, irlabs, ["X₁"], ["Γ₁", "Γ₂"]),
        find_diff(n, irlabs, ["M₁"], ["Γ₁"]),
        find_diff(n, irlabs, ["M₃M₄"], ["Γ₃Γ₄"])
    elseif wyckoff == WyckoffPosition(1, 'b', RVec([1/2, 1/2]))
        find_diff(n, irlabs, ["X₂"], ["Γ₁", "Γ₂"]),
        find_diff(n, irlabs, ["M₂"], ["Γ₁"]),
        find_diff(n, irlabs, ["M₃M₄"], ["Γ₃Γ₄"])
    end
    
    return corner_c4(diffX, diffM1, diffM2)
end

function polarization_sg10(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))    
    diffX = 
    if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
        find_diff(n, irlabs, ["X₁"], ["Γ₁", "Γ₂"])
    elseif wyckoff == WyckoffPosition(1, 'b', RVec([1/2, 1/2]))
        find_diff(n, irlabs, ["X₂"], ["Γ₁", "Γ₂"])
    end
    return polarization_c4(diffX)
end

function corner_sg11(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
    
    diffX, diffM1, diffM2 = 
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["X₁", "X₂"], ["Γ₁", "Γ₂", "Γ₃", "Γ₄"]),
            find_diff(n, irlabs, ["M₁", "M₄"], ["Γ₁", "Γ₄"]),
            find_diff(n, irlabs, [ "M₅"], ["Γ₅"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([1/2, 1/2]))
            find_diff(n, irlabs, ["X₃", "X₄"], ["Γ₁", "Γ₂", "Γ₃", "Γ₄"]),
            find_diff(n, irlabs, ["M₂", "M₃"], ["Γ₁", "Γ₄"]),
            find_diff(n, irlabs, [ "M₅"], ["Γ₅"])
        end
    return corner_c4(diffX, diffM1, diffM2)
end

function polarization_sg11(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(1, 'a', RVec([0, 0])))
            
    diffX =
        if wyckoff == WyckoffPosition(1, 'a', RVec([0, 0]))
            find_diff(n, irlabs, ["X₁", "X₂"], ["Γ₁", "Γ₂", "Γ₃", "Γ₄"])
        elseif wyckoff == WyckoffPosition(1, 'b', RVec([1/2, 1/2]))
            find_diff(n, irlabs, ["X₃", "X₄"], ["Γ₁", "Γ₂", "Γ₃", "Γ₄"])
        end
    return polarization_c4(diffX)
end


# Apparently nothing changes for sg12 
# double check
function corner_sg12(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(2, 'a', RVec([0, 0])))

    diffX, diffM1, diffM2 =
        if wyckoff ∈ (WyckoffPosition(2, 'a', RVec([0, 0])),  WyckoffPosition(2, 'a', RVec([1/2, 1/2])))
            find_diff(n, irlabs, ["X₁"], ["Γ₁", "Γ₂", "Γ₃", "Γ₄"]), 
            find_diff(n, irlabs, ["M₅"], ["Γ₁", "Γ₄"]), 
            find_diff(n, irlabs, [ "M₁M₃", "M₂M₄" ], ["Γ₅"])
        else
            error("Wrong Wyckoff Position")
        end
    return corner_c4(diffX, diffM1, diffM2)
end

function polarization_sg12(n::Vector{<:Integer}, irlabs::Vector{<:AbstractString}, wyckoff::WyckoffPosition{2}=WyckoffPosition(2, 'a', RVec([0, 0])))
    
    diffX = 
        if wyckoff ∈ (WyckoffPosition(2, 'a', RVec([0, 0])),  WyckoffPosition(2, 'a', RVec([1/2, 1/2])))
            find_diff(n, irlabs, ["X₁"], ["Γ₁", "Γ₂", "Γ₃", "Γ₄"])
        else
            error("Wrong Wyckoff Position")
        end
    return polarization_c4(diffX)
end
