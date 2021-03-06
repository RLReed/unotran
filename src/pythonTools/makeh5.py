import numpy as np
import binascii
import h5py

chi = np.array([[1.0, 0.0], [1.0, 0.0]])
sig_t = np.array([[1.0, 2.0], [1.0, 3.0]])
sig_s = np.array([[[0.3, 0.0], [0.3, 0.3]], [[0.8, 0.0], [1.2, 1.2]]])
nu_sig_f = np.array([[0.5, 0.5], [0.0, 0.0]])
number_groups = len(sig_t[0])

#chi = np.array([[1.0], [1.0]])
#sig_t = np.array([[1.0], [1.0]])
#sig_s = np.array([[[0.3]], [[0.8]]])
#nu_sig_f = np.array([[0.5], [0.0]])
#number_groups = len(sig_t[0])

print sig_s
asdf

def makeHDF5():
    mats = ['material' + str(i) for i in range(len(sig_t))]

    with h5py.File('{}group.h5'.format(number_groups), 'w') as f:
        h = f.create_group('input')
        h['db_data'] = []
        h['dbl_data'] = []
        h['int_data'] = []
        h['str_data'] = []
        h['vec_dbl_data'] = []
        h['vec_int_data'] = []

        g = f.create_group('material')
        g.attrs['number_groups'] = number_groups
        g.attrs['number_materials'] = len(mats)
        for i, mat in enumerate(mats):
            sig_a = sig_t - np.sum(sig_s, axis=2)
        
            h = g.create_group(mat)
            h['chi'] = chi[i, :]
            h['diff_coef'] = np.ones(number_groups)[:]
            h['nu'] = np.ones(number_groups)[:]
            h['sigma_a'] = sig_a[i, :]
            h['sigma_f'] = nu_sig_f[i, :]
            h['sigma_s'] = sig_s[i, :]
            h['sigma_t'] = sig_t[i, :]
            
makeHDF5()
