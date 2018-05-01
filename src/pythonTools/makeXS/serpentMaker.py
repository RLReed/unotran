import numpy as np
import os


def makeFuel(fuelOption):
    fuel = '% ** fuel discretization\n'
    if fuelOption == 'uo2':
        title = 'UO2'
        fuel += 'mat  fuel      -10.000    tmp 456\n'
        fuel += '     92235.03c 8.85e-4\n'
        fuel += '     92238.03c 2.225e-2\n'
        fuel += '     16000.03c 4.622e-2\n'
    elif fuelOption == 'moxlow':
        title = 'MOX-4.7'
        fuel += 'mat  fuel      -10.000    tmp 456\n'
        fuel += '     92235.03c 5e-5\n'
        fuel += '     92238.03c 2.21e-2\n'
        fuel += '     16000.03c 4.622e-2\n'
        fuel += '     94238.03c 1.5e-5\n'
        fuel += '     94239.03c 5.8e-4\n'
        fuel += '     94240.03c 2.4e-4\n'
        fuel += '     94241.03c 9.8e-5\n'
        fuel += '     94242.03c 5.4e-5\n'
        fuel += '     95241.03c 1.3e-5\n'
    elif fuelOption == 'moxmid':
        title = 'MOX-7.0'
        fuel += 'mat  fuel      -10.000    tmp 456\n'
        fuel += '     92235.03c 5e-5\n'
        fuel += '     92238.03c 2.21e-2\n'
        fuel += '     16000.03c 4.622e-2\n'
        fuel += '     94238.03c 2.4e-5\n'
        fuel += '     94239.03c 9.3e-4\n'
        fuel += '     94240.03c 3.9e-4\n'
        fuel += '     94241.03c 1.52e-4\n'
        fuel += '     94242.03c 8.4e-5\n'
        fuel += '     95241.03c 2.0e-5\n'
    elif fuelOption == 'moxhigh':
        title = 'MOX-8.7'
        fuel += 'mat  fuel      -10.000    tmp 456\n'
        fuel += '     92235.03c 5e-5\n'
        fuel += '     92238.03c 2.21e-2\n'
        fuel += '     16000.03c 4.622e-2\n'
        fuel += '     94238.03c 3.0e-5\n'
        fuel += '     94239.03c 1.16e-3\n'
        fuel += '     94240.03c 4.9e-4\n'
        fuel += '     94241.03c 1.90e-4\n'
        fuel += '     94242.03c 1.05e-4\n'
        fuel += '     95241.03c 2.5e-5\n'
    return title, fuel


def getGroupBounds(ng):
    if ng == 252:
        """ 252-group SCALE format

        ORNL, SCALE Manual Scale. "A Comprehensive Modeling and Simulation
        Suite for Nuclear Safety Analysis and Design." ORNL/TM-2005/39,
        Version 6.
        """

        eb = np.array([2.00000000e+07, 1.73000000e+07, 1.57000000e+07, 1.46000000e+07, 1.38000000e+07, 1.28000000e+07, 1.00000000e+07, 8.19000000e+06, 6.43000000e+06, 4.80000000e+06, 4.30000000e+06, 3.00000000e+06, 2.48000000e+06, 2.35000000e+06, 1.85000000e+06, 1.50000000e+06, 1.40000000e+06, 1.36000000e+06, 1.32000000e+06, 1.25000000e+06, 1.20000000e+06, 1.10000000e+06, 1.01000000e+06, 9.20000000e+05, 9.00000000e+05, 8.75000000e+05, 8.61000000e+05, 8.20000000e+05, 7.50000000e+05, 6.79000000e+05, 6.70000000e+05, 6.00000000e+05, 5.73000000e+05, 5.50000000e+05, 4.92000000e+05, 4.70000000e+05, 4.40000000e+05, 4.20000000e+05, 4.00000000e+05, 3.30000000e+05, 2.70000000e+05, 2.00000000e+05, 1.49000000e+05, 1.28000000e+05, 1.00000000e+05, 8.50000000e+04, 8.20000000e+04, 7.50000000e+04, 7.30000000e+04, 6.00000000e+04, 5.20000000e+04, 5.00000000e+04, 4.50000000e+04, 3.00000000e+04, 2.00000000e+04, 1.70000000e+04, 1.30000000e+04, 9.50000000e+03, 8.03000000e+03, 5.70000000e+03, 3.90000000e+03, 3.74000000e+03, 3.00000000e+03, 2.50000000e+03, 2.25000000e+03, 2.20000000e+03, 1.80000000e+03, 1.55000000e+03, 1.50000000e+03, 1.15000000e+03, 9.50000000e+02, 6.83000000e+02, 6.70000000e+02, 5.50000000e+02, 3.05000000e+02, 2.85000000e+02, 2.40000000e+02, 2.20000000e+02, 2.10000000e+02, 2.07000000e+02, 2.02000000e+02, 1.93000000e+02, 1.92000000e+02, 1.89000000e+02, 1.88000000e+02, 1.80000000e+02, 1.70000000e+02, 1.43000000e+02, 1.22000000e+02, 1.19000000e+02, 1.18000000e+02, 1.16000000e+02, 1.13000000e+02, 1.08000000e+02, 1.05000000e+02, 1.01000000e+02, 9.70000000e+01, 9.00000000e+01, 8.17000000e+01, 8.00000000e+01, 7.60000000e+01, 7.20000000e+01, 6.75000000e+01, 6.50000000e+01, 6.30000000e+01, 6.10000000e+01, 5.80000000e+01, 5.34000000e+01, 5.06000000e+01, 4.83000000e+01, 4.52000000e+01, 4.40000000e+01, 4.24000000e+01, 4.10000000e+01, 3.96000000e+01, 3.91000000e+01, 3.80000000e+01, 3.76000000e+01, 3.73000000e+01, 3.71000000e+01, 3.70000000e+01, 3.60000000e+01, 3.55000000e+01, 3.50000000e+01, 3.38000000e+01, 3.33000000e+01, 3.18000000e+01, 3.13000000e+01, 3.00000000e+01, 2.75000000e+01, 2.50000000e+01, 2.25000000e+01, 2.18000000e+01, 2.12000000e+01, 2.05000000e+01, 2.00000000e+01, 1.94000000e+01, 1.85000000e+01, 1.70000000e+01, 1.60000000e+01, 1.44000000e+01, 1.29000000e+01, 1.19000000e+01, 1.15000000e+01, 1.00000000e+01, 9.10000000e+00, 8.10000000e+00, 7.15000000e+00, 7.00000000e+00, 6.88000000e+00, 6.75000000e+00, 6.50000000e+00, 6.25000000e+00, 6.00000000e+00, 5.40000000e+00, 5.00000000e+00, 4.70000000e+00, 4.10000000e+00, 3.73000000e+00, 3.50000000e+00, 3.20000000e+00, 3.10000000e+00, 3.00000000e+00, 2.97000000e+00, 2.87000000e+00, 2.77000000e+00, 2.67000000e+00, 2.57000000e+00, 2.47000000e+00, 2.38000000e+00, 2.30000000e+00, 2.21000000e+00, 2.12000000e+00, 2.00000000e+00, 1.94000000e+00, 1.86000000e+00, 1.77000000e+00, 1.68000000e+00, 1.59000000e+00, 1.50000000e+00, 1.45000000e+00, 1.40000000e+00, 1.35000000e+00, 1.30000000e+00, 1.25000000e+00, 1.23000000e+00, 1.20000000e+00, 1.18000000e+00, 1.15000000e+00, 1.14000000e+00, 1.13000000e+00, 1.12000000e+00, 1.11000000e+00, 1.10000000e+00, 1.09000000e+00, 1.08000000e+00, 1.07000000e+00, 1.06000000e+00, 1.05000000e+00, 1.04000000e+00, 1.03000000e+00, 1.02000000e+00, 1.01000000e+00, 1.00000000e+00, 9.75000000e-01, 9.50000000e-01, 9.25000000e-01, 9.00000000e-01, 8.50000000e-01, 8.00000000e-01, 7.50000000e-01, 7.00000000e-01, 6.50000000e-01, 6.25000000e-01, 6.00000000e-01, 5.50000000e-01, 5.00000000e-01, 4.50000000e-01, 4.00000000e-01, 3.75000000e-01, 3.50000000e-01, 3.25000000e-01, 3.00000000e-01, 2.75000000e-01, 2.50000000e-01, 2.25000000e-01, 2.00000000e-01, 1.75000000e-01, 1.50000000e-01, 1.25000000e-01, 1.00000000e-01, 9.00000000e-02, 8.00000000e-02, 7.00000000e-02, 6.00000000e-02, 5.00000000e-02, 4.00000000e-02, 3.00000000e-02, 2.53000000e-02, 1.00000000e-02, 7.50000000e-03, 5.00000000e-03, 4.00000000e-03, 3.00000000e-03, 2.50000000e-03, 2.00000000e-03, 1.50000000e-03, 1.20000000e-03, 1.00000000e-03, 7.50000000e-04, 5.00000000e-04, 1.00000000e-04, 1.00000000e-05])

    elif ng > 600:
        '''
        Energy bounds are divided by equal lethargy above the thermal range

        Thermal bounds [TRESFIN] from:

        Gibson, Nathan Andrew. Resonance treatment using the discrete
        generalized multigroup method. Diss. Massachusetts Institute
        of Technology, 2013.
        '''
        # Define the thermal group bounds
        eb = np.array([5.04000000e+00, 5.01000000e+00, 4.98000000e+00, 4.95000000e+00, 4.92000000e+00, 4.89000000e+00, 4.86000000e+00, 4.83000000e+00, 4.80000000e+00, 4.77000000e+00, 4.74000000e+00, 4.71000000e+00, 4.68000000e+00, 4.65000000e+00, 4.62000000e+00, 4.59000000e+00, 4.56000000e+00, 4.54000000e+00, 4.51000000e+00, 4.48000000e+00, 4.45000000e+00, 4.42000000e+00, 4.40000000e+00, 4.37000000e+00, 4.34000000e+00, 4.31000000e+00, 4.29000000e+00, 4.26000000e+00, 4.23000000e+00, 4.21000000e+00, 4.18000000e+00, 4.16000000e+00, 4.13000000e+00, 4.10000000e+00, 4.08000000e+00, 4.05000000e+00, 4.03000000e+00, 4.00000000e+00, 3.98000000e+00, 3.95000000e+00, 3.93000000e+00, 3.90000000e+00, 3.88000000e+00, 3.86000000e+00, 3.83000000e+00, 3.81000000e+00, 3.78000000e+00, 3.76000000e+00, 3.74000000e+00, 3.71000000e+00, 3.69000000e+00, 3.67000000e+00, 3.64000000e+00, 3.62000000e+00, 3.60000000e+00, 3.58000000e+00, 3.55000000e+00, 3.53000000e+00, 3.51000000e+00, 3.49000000e+00, 3.47000000e+00, 3.44000000e+00, 3.42000000e+00, 3.40000000e+00, 3.38000000e+00, 3.36000000e+00, 3.34000000e+00, 3.32000000e+00, 3.30000000e+00, 3.28000000e+00, 3.26000000e+00, 3.24000000e+00, 3.22000000e+00, 3.20000000e+00, 3.18000000e+00, 3.16000000e+00, 3.14000000e+00, 3.12000000e+00, 3.10000000e+00, 3.08000000e+00, 3.06000000e+00, 3.04000000e+00, 3.02000000e+00, 3.00000000e+00, 2.98000000e+00, 2.97000000e+00, 2.95000000e+00, 2.93000000e+00, 2.91000000e+00, 2.89000000e+00, 2.87000000e+00, 2.86000000e+00, 2.84000000e+00, 2.82000000e+00, 2.80000000e+00, 2.79000000e+00, 2.77000000e+00, 2.75000000e+00, 2.74000000e+00, 2.72000000e+00, 2.70000000e+00, 2.69000000e+00, 2.67000000e+00, 2.66000000e+00, 2.64000000e+00, 2.63000000e+00, 2.61000000e+00, 2.60000000e+00, 2.58000000e+00, 2.57000000e+00, 2.55000000e+00, 2.53000000e+00, 2.52000000e+00, 2.50000000e+00, 2.49000000e+00, 2.47000000e+00, 2.45000000e+00, 2.44000000e+00, 2.42000000e+00, 2.41000000e+00, 2.40000000e+00, 2.38000000e+00, 2.37000000e+00, 2.36000000e+00, 2.35000000e+00, 2.33000000e+00, 2.32000000e+00, 2.30000000e+00, 2.29000000e+00, 2.27000000e+00, 2.26000000e+00, 2.24000000e+00, 2.23000000e+00, 2.21000000e+00, 2.20000000e+00, 2.19000000e+00, 2.17000000e+00, 2.16000000e+00, 2.14000000e+00, 2.13000000e+00, 2.12000000e+00, 2.11000000e+00, 2.10000000e+00, 2.09000000e+00, 2.07000000e+00, 2.06000000e+00, 2.05000000e+00, 2.04000000e+00, 2.03000000e+00, 2.02000000e+00, 2.01000000e+00, 2.00000000e+00, 1.99000000e+00, 1.97000000e+00, 1.96000000e+00, 1.95000000e+00, 1.94000000e+00, 1.93000000e+00, 1.92000000e+00, 1.91000000e+00, 1.90000000e+00, 1.88000000e+00, 1.87000000e+00, 1.87000000e+00, 1.86000000e+00, 1.85000000e+00, 1.84000000e+00, 1.83000000e+00, 1.82000000e+00, 1.81000000e+00, 1.80000000e+00, 1.79000000e+00, 1.78000000e+00, 1.77000000e+00, 1.75000000e+00, 1.74000000e+00, 1.73000000e+00, 1.72000000e+00, 1.71000000e+00, 1.70000000e+00, 1.69000000e+00, 1.68000000e+00, 1.67000000e+00, 1.66000000e+00, 1.65000000e+00, 1.64000000e+00, 1.63000000e+00, 1.62000000e+00, 1.61000000e+00, 1.60000000e+00, 1.59000000e+00, 1.58000000e+00, 1.57000000e+00, 1.56000000e+00, 1.54000000e+00, 1.53000000e+00, 1.52000000e+00, 1.51000000e+00, 1.50000000e+00, 1.49000000e+00, 1.48000000e+00, 1.47000000e+00, 1.47000000e+00, 1.46000000e+00, 1.45000000e+00, 1.44000000e+00, 1.43000000e+00, 1.42000000e+00, 1.41000000e+00, 1.40000000e+00, 1.40000000e+00, 1.39000000e+00, 1.38000000e+00, 1.37000000e+00, 1.36000000e+00, 1.35000000e+00, 1.35000000e+00, 1.34000000e+00, 1.33000000e+00, 1.32000000e+00, 1.31000000e+00, 1.30000000e+00, 1.29000000e+00, 1.28000000e+00, 1.28000000e+00, 1.27000000e+00, 1.26000000e+00, 1.25000000e+00, 1.24000000e+00, 1.24000000e+00, 1.23000000e+00, 1.22000000e+00, 1.21000000e+00, 1.20000000e+00, 1.19000000e+00, 1.19000000e+00, 1.18000000e+00, 1.17000000e+00, 1.17000000e+00, 1.16000000e+00, 1.16000000e+00, 1.15000000e+00, 1.14000000e+00, 1.14000000e+00, 1.13000000e+00, 1.12000000e+00, 1.12000000e+00, 1.11000000e+00, 1.11000000e+00, 1.11000000e+00, 1.10000000e+00, 1.10000000e+00, 1.09000000e+00, 1.09000000e+00, 1.08000000e+00, 1.08000000e+00, 1.07000000e+00, 1.07000000e+00, 1.06000000e+00, 1.06000000e+00, 1.05000000e+00, 1.04000000e+00, 1.04000000e+00, 1.04000000e+00, 1.03000000e+00, 1.03000000e+00, 1.02000000e+00, 1.01000000e+00, 1.01000000e+00, 1.00000000e+00, 9.96000000e-01, 9.91000000e-01, 9.86000000e-01, 9.81000000e-01, 9.77000000e-01, 9.72000000e-01, 9.67000000e-01, 9.61000000e-01, 9.56000000e-01, 9.50000000e-01, 9.45000000e-01, 9.40000000e-01, 9.35000000e-01, 9.30000000e-01, 9.25000000e-01, 9.20000000e-01, 9.15000000e-01, 9.10000000e-01, 9.03000000e-01, 8.97000000e-01, 8.90000000e-01, 8.83000000e-01, 8.76000000e-01, 8.71000000e-01, 8.65000000e-01, 8.60000000e-01, 8.55000000e-01, 8.50000000e-01, 8.42000000e-01, 8.35000000e-01, 8.27000000e-01, 8.19000000e-01, 8.12000000e-01, 8.05000000e-01, 7.97000000e-01, 7.90000000e-01, 7.85000000e-01, 7.80000000e-01, 7.70000000e-01, 7.61000000e-01, 7.51000000e-01, 7.42000000e-01, 7.32000000e-01, 7.23000000e-01, 7.14000000e-01, 7.05000000e-01, 6.98000000e-01, 6.90000000e-01, 6.83000000e-01, 6.75000000e-01, 6.68000000e-01, 6.61000000e-01, 6.53000000e-01, 6.46000000e-01, 6.39000000e-01, 6.32000000e-01, 6.25000000e-01, 6.18000000e-01, 6.10000000e-01, 6.03000000e-01, 5.95000000e-01, 5.88000000e-01, 5.81000000e-01, 5.74000000e-01, 5.67000000e-01, 5.60000000e-01, 5.53000000e-01, 5.47000000e-01, 5.40000000e-01, 5.36000000e-01, 5.32000000e-01, 5.28000000e-01, 5.24000000e-01, 5.20000000e-01, 5.15000000e-01, 5.10000000e-01, 5.05000000e-01, 5.00000000e-01, 4.96000000e-01, 4.93000000e-01, 4.89000000e-01, 4.85000000e-01, 4.81000000e-01, 4.76000000e-01, 4.72000000e-01, 4.67000000e-01, 4.63000000e-01, 4.58000000e-01, 4.54000000e-01, 4.50000000e-01, 4.46000000e-01, 4.41000000e-01, 4.37000000e-01, 4.33000000e-01, 4.28000000e-01, 4.23000000e-01, 4.19000000e-01, 4.14000000e-01, 4.09000000e-01, 4.05000000e-01, 4.00000000e-01, 3.96000000e-01, 3.91000000e-01, 3.86000000e-01, 3.80000000e-01, 3.75000000e-01, 3.70000000e-01, 3.65000000e-01, 3.60000000e-01, 3.55000000e-01, 3.50000000e-01, 3.46000000e-01, 3.42000000e-01, 3.38000000e-01, 3.35000000e-01, 3.31000000e-01, 3.27000000e-01, 3.24000000e-01, 3.20000000e-01, 3.17000000e-01, 3.15000000e-01, 3.11000000e-01, 3.07000000e-01, 3.04000000e-01, 3.00000000e-01, 2.95000000e-01, 2.90000000e-01, 2.85000000e-01, 2.80000000e-01, 2.76000000e-01, 2.72000000e-01, 2.68000000e-01, 2.64000000e-01, 2.60000000e-01, 2.56000000e-01, 2.52000000e-01, 2.48000000e-01, 2.44000000e-01, 2.41000000e-01, 2.37000000e-01, 2.34000000e-01, 2.30000000e-01, 2.27000000e-01, 2.23000000e-01, 2.20000000e-01, 2.17000000e-01, 2.15000000e-01, 2.12000000e-01, 2.09000000e-01, 2.07000000e-01, 2.04000000e-01, 2.01000000e-01, 1.99000000e-01, 1.96000000e-01, 1.94000000e-01, 1.91000000e-01, 1.89000000e-01, 1.87000000e-01, 1.85000000e-01, 1.82000000e-01, 1.80000000e-01, 1.77000000e-01, 1.75000000e-01, 1.72000000e-01, 1.70000000e-01, 1.67000000e-01, 1.65000000e-01, 1.62000000e-01, 1.60000000e-01, 1.58000000e-01, 1.55000000e-01, 1.53000000e-01, 1.51000000e-01, 1.49000000e-01, 1.46000000e-01, 1.44000000e-01, 1.42000000e-01, 1.40000000e-01, 1.38000000e-01, 1.36000000e-01, 1.34000000e-01, 1.30000000e-01, 1.26000000e-01, 1.23000000e-01, 1.19000000e-01, 1.15000000e-01, 1.11000000e-01, 1.08000000e-01, 1.04000000e-01, 1.00000000e-01, 9.75000000e-02, 9.50000000e-02, 9.13000000e-02, 8.75000000e-02, 8.38000000e-02, 8.00000000e-02, 7.70000000e-02, 7.45000000e-02, 7.20000000e-02, 6.95000000e-02, 6.70000000e-02, 6.48000000e-02, 6.25000000e-02, 6.03000000e-02, 5.80000000e-02, 5.60000000e-02, 5.40000000e-02, 5.20000000e-02, 5.00000000e-02, 4.80000000e-02, 4.60000000e-02, 4.40000000e-02, 4.20000000e-02, 4.03000000e-02, 3.85000000e-02, 3.68000000e-02, 3.50000000e-02, 3.38000000e-02, 3.25000000e-02, 3.13000000e-02, 3.00000000e-02, 2.88000000e-02, 2.75000000e-02, 2.63000000e-02, 2.50000000e-02, 2.38000000e-02, 2.25000000e-02, 2.13000000e-02, 2.00000000e-02, 1.88000000e-02, 1.75000000e-02, 1.63000000e-02, 1.50000000e-02, 1.38000000e-02, 1.25000000e-02, 1.13000000e-02, 1.00000000e-02, 8.97000000e-03, 7.93000000e-03, 6.90000000e-03, 6.50000000e-03, 6.00000000e-03, 5.50000000e-03, 5.00000000e-03, 4.50000000e-03, 4.00000000e-03, 3.50000000e-03, 3.00000000e-03, 2.30000000e-03, 1.70000000e-03, 1.30000000e-03, 1.00000000e-03, 8.00000000e-04, 5.00000000e-04, 1.10000000e-04, 1e-11])
        upper = 2e7
        groups = ng - len(eb)
        E = np.linspace(eb[0], upper, groups + 1)
        p = np.power(upper / eb[0], 1.0 / groups)
        for i in range(1, groups + 1):
            E[i] = E[i - 1] * p
        eb = np.concatenate((E[::-1][:-1], eb))
        eb = eb[::-1]

    eb = [e / 1e6 for e in eb[:-1][::-1]]

    # make the string that contains the energy bounds
    esub = ' '.join(['{:14.12e}'.format(e) + ('' if i % 4 != 3 else '\n    ') for i, e in enumerate(eb[:-1])])
    eb = ' '.join(['{:14.12e}'.format(e) + ('' if i % 4 != 3 else '\n    ') for i, e in enumerate(eb)])
    return eb, esub


def getENEGrid(G):
    if G == 2: return 'cas2'
    elif G == 3: return 'cas3'
    elif G == 4: return 'cas4'
    elif G == 7: return 'cas7'
    elif G == 8: return 'cas8'
    elif G == 9: return 'cas9'
    elif G == 12: return 'cas12'
    elif G == 14: return 'cas14'
    elif G == 16: return 'cas16'
    elif G == 18: return 'cas18'
    elif G == 23: return 'cas23'
    elif G == 25: return 'cas25'
    elif G == 27: return 'nj4'
    elif G == 30: return 'nj3'
    elif G == 33: return 'nj19'
    elif G == 35: return 'nj8'
    elif G == 40: return 'cas40'
    elif G == 43: return 'mupo43'
    elif G == 44: return 'scale44'
    elif G == 50: return 'nj5'
    elif G == 69: return 'wms69'
    elif G == 70: return 'cas70'
    elif G == 100: return 'nj14'
    elif G == 172: return 'wms172'
    elif G == 174: return 'nj16'
    elif G == 175: return 'nj17'
    elif G == 238: return 'scale238'
    elif G == 240: return 'nj2'
    elif G == 315: return 'nj21'
    elif G == 1968: return 'nj20'
    else: return None


def makeFile(serpentPath, fuelOption, numberGroups):

    fuelTitle, fuelComp = makeFuel(fuelOption)

    s = ''

    s += '% ** {} PIN CELL SIMULATION-QUARTER CELL\n'.format(fuelTitle)

    s += 'set title "{} QUARTER CELL"\n'.format(fuelTitle)

    s += '% ** SURFACE CARDS\n'
    s += '% ******************************************************************************\n'
    s += '% since the reflective bc can only be used for square cylinder etc, \n'
    s += '% a square cylinder with r0 = 0is given to simulate the outer \n'
    s += '% boundary of the quater pin cell\n'

    s += '% Original Pin Cell\n'
    s += '  surf   1    sqc   0.0000 0.0000 0.6333     /* outmost SURFACE */\n'
    s += '  surf   2    cyl   0.0000 0.0000 0.54     /* aluminum Radius */\n'
    s += '  surf   3    cyl   0.0000 0.0000 0.485     /* void */ \n'
    s += '  surf   4    cyl   0.0000 0.0000 0.475     /* Zirc clad */\n'
    s += '  surf   5    cyl   0.0000 0.0000 0.418     /* void */ \n'
    s += '  surf   6    cyl   0.0000 0.0000 0.4095     /* fuel */ \n'

    s += '% ** CELL CARDS\n'
    s += '% *****************************************************************************\n'
    s += '  cell 1    1 fuel     -6        % Fuel   \n'
    s += '  cell 2    1 void  6  -5        % void\n'
    s += '  cell 3    1 zirc  5  -4        % zirc cladding\n'
    s += '  cell 4    1 void  4  -3        % void\n'
    s += '  cell 5    1 alum  3  -2        % aluminum cladding\n'
    s += '  cell 55   0 fill 1 -2\n'
    s += '  cell 6    0 water 2  -1        % moderator\n'

    s += '% Reflective boundary\n'
    s += '  cell 99 0 outside   1                  % Outside world\n'

    s += '% **MATERIAL CARDS\n'
    s += '% *****************************************************************************\n'
    s += fuelComp

    s += '% **  zirconium cladding ** Density = -6.52\n'
    s += 'mat   zirc         -6.52\n'
    s += '      40000.03c    4.30e-2\n'

    s += '% **  aluminum cladding ** Density = -2.7\n'
    s += 'mat   alum         -2.7\n'
    s += '      13027.03c    6.00e-2  \n'

    s += '% **  Water\n'
    s += 'mat   water        -0.995 moder lwtr 1001 % Considering the binding effects of\n'
    s += '      1001.03c      6.70e-2              % hydrogen \n'
    s += '      8016.03c      3.35e-2\n'
    s += '      5010.03c      2.78e-5\n'

    s += '% **thermal scattering data for light water\n'
    s += '% *****************************************************************************\n'
    s += 'therm lwtr lwj3.11t\n'

    s += '% **Cross section data library file path\n'
    s += '% *****************************************************************************\n'
    s += 'set acelib "{}xsdata/endfb7/sss_endfb7u.xsdir"\n'.format(serpentPath)

    s += '%      ---??? lib setting---- \n'

    s += '% **reflective boundary condition\n'
    s += '% *****************************************************************************\n'
    s += 'set bc 2\n'

    s += 'set gcu 0 1 % homogenious in universe 0\n'
    s += 'set sym 8 % square symmetry for error reduction \n'
    name = getENEGrid(numberGroups)
    if name:
        s += 'set nfg {}\n'.format(name)
        s += 'set micro {}\n'.format(name)
        s += 'ene grid{} 4 {}\n'.format(numberGroups, name)
    else:
        groupBounds, subGroupBounds = getGroupBounds(numberGroups)
        s += 'set nfg {} '.format(numberGroups) + subGroupBounds
        s += '\nset fum grid{}\n\n'.format(numberGroups)
        s += 'ene grid{} 1 1.00000000e-11 '.format(numberGroups) + groupBounds

    s += '% ** Neutron population and criticality cycles: \n'
    s += '%*****************************************************************************\n'
    s += 'set pop 100000 80 20 1.00  % according to the kcode 100000 1.000000 10 110\n'

    s += '% ** Decay and fission yield libraries\n'

    s += 'set declib "{}xsdata/endfb7/sss_endfb7.dec"\n'.format(serpentPath)
    s += 'set nfylib "{}xsdata/endfb7/sss_endfb7.nfy"\n'.format(serpentPath)

    s += '% ** end **********************************************************************\n'

    with open('{}g/{}-{}.inp'.format(numberGroups, fuelOption, numberGroups), 'w') as f:
        f.write(s)


if __name__ == '__main__':
    serpentPath = '/home/richard/opt/serpent/serpent/'
    gs = [2, 3, 4, 7, 8, 9, 12, 14, 16, 18, 23, 25, 27, 30, 33, 35, 40, 43, 44, 50, 69, 70, 100, 172, 174, 175, 238, 240, 315, 1968]
    for g in gs:
        directory = '{}g'.format(g)
        if not os.path.exists(directory):
            os.makedirs(directory)
        s = '#!/bin/bash\n\n'
        for op in ['uo2', 'moxlow', 'moxmid', 'moxhigh']:
            makeFile(serpentPath, op, g)
            s += 'sss2 -omp 28 {}-{}.inp\n'.format(op, g)
        with open('{}g/runSerpentFiles.sh'.format(g), 'w') as f:
            f.write(s)

