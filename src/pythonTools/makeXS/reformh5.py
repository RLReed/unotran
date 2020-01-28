import h5py
import numpy as np

def makeDB(name):
    name1 = '{}_res.m'.format(name)
    f = open(name1, 'r').readlines()
    material_names = []
    db = {}
    db['filename'] = name
    for line in f:
        if 'GC_UNIVERSE_NAME' in line:
            key = line.split()[-2][1:-1]
            db[key] = {}
            material_names.append(key)
        else:
            if 'INF_TOT' in line:
                sig = np.array([float(i) for i in line.split()[6:-1]])
                db[key]['sig_t'] = sig[::2]
                db[key]['sig_t_err'] = sig[1::2]
            elif 'INF_NSF' in line:
                db[key]['vsig_f'] = np.array([float(i) for i in line.split()[6:-1:2]])
            elif 'INF_S' in line:
                if line[5] in '01234567':
                    n = line[5]
                    D = np.array([float(i) for i in line.split()[6:-1:2]])
                    db[key]['sig_s{}'.format(n)] = D.reshape((int(np.sqrt(len(D))),-1))
            elif 'INF_CHIT' in line:
                db[key]['chi'] = np.array([float(i) for i in line.split()[6:-1:2]])
            elif 'INF_FLX' in line:
                db[key]['phi'] = np.array([float(i) for i in line.split()[6:-1:2]])
            elif 'INF_KINF' in line:
                db[key]['k'] = line.split()[-3]
            elif 'MACRO_E' in line:
                db[key]['E'] = np.array([float(i) for i in line.split()[6:-1]])
            elif 'INF_INVV' in line:
                db[key]['vel'] = np.array([float(i) for i in line.split()[6:-1:2]]) ** -1
            elif 'INF_NUBAR' in line:
                db[key]['nu'] = np.array([float(i) for i in line.split()[6:-1:2]])
            elif 'INF_DIFFCOEF' in line:
                db[key]['D'] = np.array([float(i) for i in line.split()[6:-1:2]])
    db['name_order'] = material_names
    return db
    
def combineScattering(db, nLegendre):
    Ng = len(db['sig_s0'])
    D = np.zeros((nLegendre, Ng, Ng))
    for l in range(nLegendre):
        D[l,:,:] = db['sig_s{}'.format(l)]
        del db['sig_s{}'.format(l)]
    db['sig_s'] = D
    return db
    
def makeHDF5(db):
    with h5py.File('{0}g/{0}gXS.h5'.format(G), 'w') as f:
        h = f.create_group('input')
        h['db_data'] = []
        h['dbl_data'] = []
        h['int_data'] = []
        h['str_data'] = []
        h['vec_dbl_data'] = []
        h['vec_int_data'] = []

        g = f.create_group('material')
        g.attrs['number_groups'] = G
        g.attrs['number_materials'] = len(names) + 1
        for i, name in enumerate(names + ['water']):
            d = db[name]['0'] if name != 'water' else db[names[0]]['2']
            chi = d['chi'][:]
            D = d['D'][:]
            sig_t = d['sig_t']
            sig_s = d['sig_s0']
            vsig_f = d['vsig_f']
            sig_a = sig_t - np.sum(sig_s, axis=1)

            h = g.create_group('material' + str(i))
            h['chi'] = chi[:]
            h['diff_coef'] = D
            h['nu'] = np.ones(len(vsig_f))[:]
            h['sigma_a'] = sig_a[:]
            h['sigma_f'] = vsig_f[:]
            h['sigma_s'] = sig_s[:]
            h['sigma_t'] = sig_t[:]
    print('success')
        
            
if __name__ == '__main__':
    Gs = [2]
    names = ['UO2-1', 'UO2-2', 'UO2-Gd', 'MOX']#, 'c5g7-uo2', 'c5g7-moxlow', 'c5g7-moxmid', 'c5g7-moxhigh']
    for G in Gs:
        db = {}
        for name in names:
            fname = '{}g/'.format(G) + name + '-{}.inp'.format(G)
            db[name] = makeDB(fname)
        
        makeHDF5(db)
            
            
            
