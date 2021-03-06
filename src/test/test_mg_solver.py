import sys
sys.path.append('../')

import unittest
import pydgm
import numpy as np


class TestMG_SOLVER(unittest.TestCase):

    def setUp(self):
        # Set the variables for the test
        pydgm.control.spatial_dimension = 1
        pydgm.control.fine_mesh_x = [1]
        pydgm.control.coarse_mesh_x = [0.0, 1.0]
        pydgm.control.material_map = [1]
        pydgm.control.xs_name = 'test/3gXS.anlxs'.ljust(256)
        pydgm.control.angle_order = 2
        pydgm.control.angle_option = pydgm.angle.gl
        pydgm.control.boundary_east = 1.0
        pydgm.control.boundary_west = 1.0
        pydgm.control.allow_fission = False
        pydgm.control.outer_print = 0
        pydgm.control.inner_print = 0
        pydgm.control.outer_tolerance = 1e-16
        pydgm.control.equation_type = 'DD'
        pydgm.control.lamb = 1.0
        pydgm.control.store_psi = False
        pydgm.control.solver_type = 'fixed'.ljust(256)
        pydgm.control.source_value = 1.0
        pydgm.control.scatter_leg_order = 0
        pydgm.control.delta_leg_order = 0
        pydgm.control.max_outer_iters = 20000

        # Initialize the dependancies
        pydgm.solver.initialize_solver()

    def test_mg_solver_mg_solve_R(self):
        ''' 
        Test convergence for the multigroup solver with reflective conditions
        '''

        pydgm.mg_solver.mg_solve()

        phi_test = [[[161.534959460539], [25.4529297193052813], [6.9146161770064944]]]
        incident_test = np.array([[80.7674797302686329, 80.7674797302685761],
                                  [12.7264648596526406, 12.7264648596526424],
                                  [3.4573080885032477, 3.4573080885032477]])

        phi = pydgm.state.mg_phi
        incident = pydgm.state.mg_incident_x[:, :, 0, 0]

        np.testing.assert_array_almost_equal(phi, phi_test, 12)
        np.testing.assert_array_almost_equal(incident, incident_test, 12)

    def test_mg_solver_mg_solve_V(self):
        ''' 
        Test convergence for the multigroup solver with reflective conditions
        '''

        pydgm.control.boundary_east = 0.0
        pydgm.control.boundary_west = 0.0

        pydgm.mg_solver.mg_solve()

        phi_test = [[[1.1128139420344907], [1.0469097961254414], [0.9493149657672653]]]
        incident_test = np.array([[0.6521165715780991, 1.3585503570955177],
                                  [0.6642068017193753, 1.2510439369070607],
                                  [0.589237898650032, 1.1413804154385336]])

        phi = pydgm.state.mg_phi
        incident = pydgm.state.mg_incident_x[:, :, 0, 0]

        np.testing.assert_array_almost_equal(phi, phi_test, 12)
        np.testing.assert_array_almost_equal(incident, incident_test, 12)

    def tearDown(self):
        pydgm.solver.finalize_solver()
        pydgm.control.finalize_control()


if __name__ == '__main__':

    unittest.main()
