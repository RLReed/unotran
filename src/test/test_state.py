import sys
sys.path.append('../')

import unittest
import pydgm
import numpy as np


class TestSTATE(unittest.TestCase):

    def setUp(self):
        # Set the variables for the test
        pydgm.control.spatial_dimension = 1
        pydgm.control.fine_mesh_x = [1]
        pydgm.control.coarse_mesh_x = [0.0, 1.0]
        pydgm.control.material_map = [1]
        pydgm.control.xs_name = 'test/7gXS.anlxs'.ljust(256)
        pydgm.control.angle_order = 2
        pydgm.control.angle_option = pydgm.angle.gl
        pydgm.control.allow_fission = True
        pydgm.control.store_psi = False
        pydgm.control.solver_type = 'fixed'.ljust(256)
        pydgm.control.source_value = 0.0
        pydgm.control.scatter_leg_order = 0
        pydgm.control.use_DGM = False

    def test_state_initialize(self):
        ''' 
        Test initializing of state arrays, no psi
        '''
        pydgm.state.initialize_state()

        phi_test = np.ones((7, 1))

        np.testing.assert_array_almost_equal(pydgm.state.phi[0], phi_test, 12)

    def test_state_initialize2(self):
        ''' 
        Test initializing of state arrays, with psi
        '''
        pydgm.control.store_psi = True
        pydgm.state.initialize_state()

        phi_test = np.ones((7, 1))
        psi_test = np.ones((7, 4, 1)) / 2

        np.testing.assert_array_almost_equal(pydgm.state.phi[0], phi_test, 12)
        np.testing.assert_array_almost_equal(pydgm.state.psi, psi_test, 12)

    def test_state_update_fission_density(self):
        pydgm.control.fine_mesh_x = [3, 10, 3]
        pydgm.control.coarse_mesh_x = [0.0, 1.0, 2.0, 3.0]
        pydgm.control.material_map = [1, 2, 6]

        pydgm.solver.initialize_solver()

        density_test = [0.85157342, 0.85157342, 0.85157342, 1.08926612, 1.08926612,
                        1.08926612, 1.08926612, 1.08926612, 1.08926612, 1.08926612,
                        1.08926612, 1.08926612, 1.08926612, 0.0, 0.0, 0.0]

        np.testing.assert_array_almost_equal(pydgm.state.mg_density, density_test, 12)

    def tearDown(self):
        # Finalize the dependancies
        pydgm.solver.finalize_solver()
        pydgm.control.finalize_control()


if __name__ == '__main__':

    unittest.main()
