program test_material

use material

implicit none

! initialize types
  integer :: number_materials_test, number_groups_test, number_legendre_test, debugFlag_test
  double precision :: ebounds_test(8), velocity_test(7)
  real :: sig_t_test(7,7), sig_f_test(7,7), vsig_f_test(7,7), chi_test(7,7)
  double precision :: sig_s_test(8,7,7)
  integer :: t1=1, t2=1, t3=1, t4=1, t5=1, testCond
  
  character(len=10) :: filename = 'test.anlxs'
  
  call create_material(filename)
  
  number_materials_test = 7
  number_groups_test = 7
  number_legendre_test = 8
  debugFlag_test = 0
  
  ebounds_test = [1.000000e+37,4.000000e+00,2.000000e-01,3.000000e-03,4.000000e-05,5.000000e-07,6.000000e-09,0.000000e+00]
  velocity_test = [3.158699e+09,1.265531e+09,2.062621e+08,2.214246e+07,2.447058e+06,4.107856e+05,8.296621e+04]
  sig_t_test = reshape((/0.216236, 0.228405, 0.228189, 0.228073, 0.153580, 0.106427, 0.0, &
                         0.306648, 0.317683, 0.317428, 0.317826, 0.256022, 0.292923, 0.0, &
                         0.445147, 0.464176, 0.464807, 0.465355, 0.382343, 0.839012, 0.0, & 
                         0.536315, 0.556162, 0.566729, 0.574985, 0.284138, 1.052420, 0.0, &
                         0.556016, 0.588508, 0.623460, 0.649671, 0.255095, 1.084110, 0.0, &
                         0.711023, 0.986023, 1.255970, 1.480740, 0.260362, 1.894040, 0.0, &
                         1.754220, 2.186120, 2.870890, 3.448620, 0.299655, 5.596170, 0.0/), shape(sig_t_test))
  vsig_f_test = reshape((/0.04377570, 0.04867930, 0.05036610, 0.05165750, 0.0, 0.0, 0.0, &
                          0.01259030, 0.01496700, 0.01643930, 0.01756960, 0.0, 0.0, 0.0, &
                          0.00249733, 0.00294972, 0.00432797, 0.00544935, 0.0, 0.0, 0.0, &
                          0.01962850, 0.02593640, 0.03766070, 0.04686690, 0.0, 0.0, 0.0, &
                          0.05301660, 0.07556850, 0.10852500, 0.13377400, 0.0, 0.0, 0.0, &
                          0.52135500, 1.02075000, 1.50444000, 1.90256000, 0.0, 0.0, 0.0, &
                          2.03165000, 3.02363000, 4.39402000, 5.53922000, 0.0, 0.0, 0.0 /), shape(vsig_f_test))
  sig_f_test = reshape((/0.01361113, 0.01502550, 0.01544622, 0.01576693, 0.0, 0.0, 0.0, &
                         0.00467188, 0.00543715, 0.00590706, 0.00626443, 0.0, 0.0, 0.0, &
                         0.00097176, 0.00103467, 0.00150882, 0.00189564, 0.0, 0.0, 0.0, &
                         0.00759461, 0.00912987, 0.01319072, 0.01638571, 0.0, 0.0, 0.0, &
                         0.02030750, 0.02654889, 0.03796532, 0.04672675, 0.0, 0.0, 0.0, &
                         0.19427521, 0.35709163, 0.52515394, 0.66370610, 0.0, 0.0, 0.0, &
                         0.77935654, 1.05926886, 1.53287075, 1.92955102, 0.0, 0.0, 0.0 /), shape(sig_f_test))
  chi_test = reshape((/  0.11505700, 0.11924300, 0.12066700, 0.12019500, 0.0, 0.0, 0.0, &
                         0.85043100, 0.84636000, 0.84533500, 0.84612500, 0.0, 0.0, 0.0, &
                         0.03444650, 0.03434360, 0.03392080, 0.03359890, 0.0, 0.0, 0.0, &
                         6.61309e-05, 5.32432e-05, 7.78717e-05, 8.07813e-05, 0.0, 0.0, 0.0, &
                         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
                         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
                         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 /), shape(chi_test))
  sig_s_test = reshape((/0.140483,0.094212,0.072556,0.059907,0.046352,0.032127,0.020068,0.011430, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.054594,-0.000986,0.000446,0.000325,-0.000398,-0.000288,-0.000063,-0.000027, &
                         0.290195,0.068100,0.041293,0.020179,0.012131,0.005415,0.002440,0.000714, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.004461,0.000010,0.000029,0.000003,0.000000,0.000009,0.000006,-0.000022, &
                         0.010012,-0.001718,0.000051,0.000012,-0.000004,-0.000009,-0.000001,0.000007, &
                         0.430856,0.020776,0.001323,0.000088,0.000034,-0.000011,0.000003,-0.000073, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000006,-0.000002,-0.000000,0.000000,-0.000001,0.000000,-0.000001,0.000000, &
                         0.000004,0.000001,0.000000,0.000000,-0.000000,-0.000000,0.000000,-0.000000, &
                         0.004317,-0.001342,-0.000055,0.000003,-0.000009,-0.000003,0.000003,0.000000, &
                         0.478784,0.010693,0.000092,0.000020,-0.000069,-0.000033,0.000026,-0.000013, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.005233,-0.001622,-0.000073,-0.000002,0.000003,0.000010,-0.000008,0.000004, &
                         0.393849,0.010184,0.000572,0.000005,-0.000172,0.000082,0.000010,0.000002, &
                         0.002379,-0.000247,-0.000104,-0.000043,-0.000009,-0.000008,-0.000008,-0.000003, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.006400,-0.001462,-0.000167,-0.000028,-0.000036,-0.000015,0.000000,0.000015, &
                         0.374041,0.008300,0.000371,0.000172,0.000048,-0.000110,0.000018,0.000074, &
                         0.293938,-0.022958,-0.005105,-0.002964,-0.001194,-0.002966,-0.001063,-0.000020, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, &
                         0.001101,-0.000082,-0.000014,-0.000022,0.000006,-0.000011,-0.000008,0.000004, &
                         0.199363,0.022191,0.009386,0.006565,0.003632,0.001115,0.000818,0.001271 /), shape(sig_s_test))
  
  ! Test total cross section             
  t1 = testCond(norm2(sig_t - sig_t_test) .lt. 1e-6)
  
  ! Test fission cross section  
  t2 = testCond(norm2(sig_f - sig_f_test) .lt. 1e-6)
  
  ! Test nu * fission cross section  
  t3 = testCond(norm2(vsig_f - vsig_f_test) .lt. 1e-6)
  
  ! Test chi
  t4 = testCond(norm2(chi - chi_test) .lt. 1e-6)
  
  ! Test scattering cross section  
  t5 = testCond(norm2(sig_s(1,:,:,:) - sig_s_test) .lt. 1e-5)
  
  ! Print appropriate output statements
  if (t1 .eq. 0) then
    print *, 'material: sig_t failed'
  else if (t2 .eq. 0) then
    print *, 'material: sig_f failed'
  else if (t3 .eq. 0) then
    print *, 'material: vsig_f failed'
  else if (t3 .eq. 0) then
    print *, 'material: chi failed'
  else if (t3 .eq. 0) then
    print *, 'material: sig_s failed'
  else
    print *, ' all tests passed for material'
  end if
  
end program test_material

integer function testCond(condition)
  logical, intent(in) :: condition
  if (condition) then
    write(*,"(A)",advance="no") '.'
    testCond = 1
  else
    write(*,"(A)",advance="no") 'F'
    testCond = 0
  end if

end function testCond
