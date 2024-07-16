## Plane group 2 corner charge simulations 
This folder is dedicated to the special case of `sgnum=2`, for which we have incommensurate lattice vectors and thus need to run separate simulations for the cladding. 
For both the cladding and the bulk, we use a dielectric contrast of `16`. We use lattices `9558` and `1877` for the bulk and the cladding, respectively. The lattice vectors
of lattice `1877` were changed to those of the bulk to have a commensurate structure.  

## Folder structure: 

1. **`./symeigs`**: We check that the symmetry eigenvalues of the cladding structure don't change (at least for the first three bands) when we change the lattice vectors to those of the
   bulk.
2. **`./dispersions`**: Similarly, we check that the dispersion isn't altered significantly (as we must maintain a gap).
3. **`./supercell_calcs`**: Supercell calculation of the bulk with the cladding. 
