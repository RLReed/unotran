import unittest
from test_angle import TestANGLE
from test_mesh import TestMESH
from test_material import TestMATERIAL
from test_state import TestSTATE
from test_sources import TestSOURCES
from test_sweeper import TestSWEEPER
from test_mg_solver import TestMG_SOLVER
from test_solver import TestSOLVER
from test_dgm import TestDGM
from test_dgmsolver import TestDGMSOLVER


def AllSuite():
    suite = unittest.TestSuite()
    suite.addTests(unittest.makeSuite(TestANGLE))
    suite.addTests(unittest.makeSuite(TestMESH))
    suite.addTests(unittest.makeSuite(TestMATERIAL))
    suite.addTests(unittest.makeSuite(TestSTATE))
    suite.addTests(unittest.makeSuite(TestSOURCES))
    suite.addTests(unittest.makeSuite(TestSWEEPER))
    suite.addTests(unittest.makeSuite(TestMG_SOLVER))
    suite.addTests(unittest.makeSuite(TestSOLVER))
    suite.addTests(unittest.makeSuite(TestDGM))
    suite.addTests(unittest.makeSuite(TestDGMSOLVER))

    return suite


if __name__ == '__main__':
    runner = unittest.TextTestRunner()

    test_suite = AllSuite()

    runner.run(test_suite)
