import pydgm
import numpy as np
np.set_printoptions(precision=16, linewidth=132)

G = 7
geo = 4
bound = 'R'
solver = 'eigen'

# Set the variables
if geo == 0:
    pydgm.control.fine_mesh = [10]
    pydgm.control.coarse_mesh = [0.0, 10.0]
    pydgm.control.material_map = [1]
elif geo == 1:
    pydgm.control.fine_mesh = [3, 10, 3]
    pydgm.control.coarse_mesh = [0.0, 0.09, 1.17, 1.26]
    pydgm.control.material_map = [5, 1, 5]
elif geo == 2:
    pydgm.control.fine_mesh = [3, 22, 3]
    pydgm.control.coarse_mesh = [0.0, 0.09, 1.17, 1.26]
    pydgm.control.material_map = [1, 1, 1]
elif geo == 3:
    pydgm.control.fine_mesh = [200, 200, 200]
    pydgm.control.coarse_mesh = [0, 100, 200, 300]
    pydgm.control.material_map = [1, 2, 1]
elif geo == 4:
    # Define the number of pins of UO2
    nPins = 5
    # Define the fine mesh
    pydgm.control.fine_mesh = [3, 12, 3] * nPins * 2
    # Define the coarse mesh
    x = [0.0, 0.09, 1.17, 1.26]
    cm = [xx + i * x[-1] for i in range(10) for xx in x[:-1]] + [2 * nPins * 1.26]
    pydgm.control.coarse_mesh = cm
    # Define the material map
    mMap = [5, 1, 5] * nPins + [5, 3, 5] * nPins
    pydgm.control.material_map = mMap

pydgm.control.angle_order = 4
pydgm.control.angle_option = pydgm.angle.gl
if bound == 'V':
    pydgm.control.boundary_type = [0.0, 0.0]
elif bound == 'R':
    pydgm.control.boundary_type = [1.0, 1.0]

pydgm.control.allow_fission = True
pydgm.control.delta_legendre_order = 1
pydgm.control.truncate_delta = True
pydgm.control.recon_print = 1
pydgm.control.eigen_print = 0
pydgm.control.outer_print = 0
pydgm.control.inner_print = 0
pydgm.control.recon_tolerance = 1e-8
pydgm.control.eigen_tolerance = 1e-8
pydgm.control.outer_tolerance = 1e-8
pydgm.control.inner_tolerance = 1e-8
pydgm.control.max_recon_iters = 1000
pydgm.control.max_eigen_iters = 1000
pydgm.control.max_outer_iters = 1000
pydgm.control.max_inner_iters = 100
pydgm.control.lamb = 1.0
pydgm.control.use_dgm = True
pydgm.control.store_psi = True
pydgm.control.solver_type = solver.ljust(256)
pydgm.control.source_value = 0.0 if solver == 'eigen' else 1.0
pydgm.control.equation_type = 'DD'
pydgm.control.legendre_order = 0
pydgm.control.ignore_warnings = True
# 1.059630301 ref
# 1.059929370 delta-0
# 1.059617344 delta-1
if G == 2:
    pydgm.control.xs_name = '2gXS.anlxs'.ljust(256)
    pydgm.control.dgm_basis_name = 'test/2gbasis'.ljust(256)
    pydgm.control.energy_group_map = [1]
elif G == 4:
    pydgm.control.xs_name = '4gXS.anlxs'.ljust(256)
    pydgm.control.dgm_basis_name = 'test/4gbasis'.ljust(256)
    pydgm.control.energy_group_map = [2]
elif G == 7:
    pydgm.control.xs_name = 'test/7gXS.anlxs'.ljust(256)
    pydgm.control.dgm_basis_name = 'test/7gbasis'.ljust(256)
    pydgm.control.energy_group_map = [1, 1, 1, 2, 3, 4, 4]
    #pydgm.control.truncation_map = [1, 1, 0, 2]
elif G == 1:
    pydgm.control.xs_name = 'aniso.anlxs'.ljust(256)
elif G == 44:
    pydgm.control.xs_name = 'pythonTools/makeXS/44g/44gXS.anlxs'.ljust(256)
    pydgm.control.dgm_basis_name = 'pythonTools/basisMaking/44g/dlp_44g'.ljust(256)
    pydgm.control.energy_group_map = [14, 37, 42]

if pydgm.control.use_dgm:
    # Initialize the dependancies
    pydgm.dgmsolver.initialize_dgmsolver()

    # Solve the problem
    #pydgm.dgmsolver.dgmsolve()
else:
    # Initialize the dependancies
    pydgm.solver.initialize_solver()

    # Solve the problem
    pydgm.solver.solve()

print pydgm.dgm.order
print pydgm.dgm.basismap
print pydgm.dgm.basis
exit()


# Print the output
print pydgm.state.phi
np.save('aniso_phi', pydgm.state.phi)
#print pydgm.state.phi.flatten('F').tolist()
#print pydgm.state.psi.flatten('F').tolist()
#print repr(pydgm.state.d_keff)
