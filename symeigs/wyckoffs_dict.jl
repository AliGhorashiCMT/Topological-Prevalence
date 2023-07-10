using Crystalline, MPBUtils, JLD2, LinearAlgebra, StaticArrays, SymmetryBases, PyPlot

sg_wyckoffs = [filter(x -> x.mult == 1, wyckoffs(i, 2)) for i in (2, 6, (9:17)...)]
# For all plane groups other than 12 (p4gm), 15 (p31m), and 9 (c2mm) it is sufficient to look at which wyckoff positions have multiplicity 1 
sg_wyckoffs[3] = [wyckoffs(9, 2)[end-1:end]..., WyckoffPosition(4, 'c', RVec([1/4, 1/4])), WyckoffPosition(4, 'c', RVec([1/4, -1/4]))];
#Plane group 9- all wyckoff positions have C2 symmetry 
sg_wyckoffs[6] = [wyckoffs(12, 2)[end]];
#Plane group 12- the 1a position becomes the 2a position, and has full C4 rotational symmetry 
sg_wyckoffs[9] = [WyckoffPosition(1, 'a', RVec([0, 0])), WyckoffPosition(2, 'b', RVec([1/3, 2/3])), WyckoffPosition(2, 'c', RVec([2/3, 1/3]))]
#Plane group 15- Though only one wyckoff position has a multiplicity of 1, three of them have C3 symmetry
sg_wyckoffs_dict = Dict(([2, 6, 9:17...])[i] => sg_wyckoffs[i] for i in 1:11)

