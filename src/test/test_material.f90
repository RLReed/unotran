program test_material

use material

implicit none

! initialize types
  integer :: number_materials_test, number_groups_test, number_legendre_test, debugFlag_test
  double precision :: ebounds_test(8), velocity_test(7)
  double precision :: sig_t_test(7,6), sig_f_test(7,6), nu_sig_f_test(7,6), chi_test(7,6), sig_s_test(0:7,7,7)
  integer :: t1=1, t2=1, t3=1, t4=1, t5=1, testCond
  
  character(len=10) :: filename = 'test.anlxs'
  
  call create_material(filename, .true.)
  
  number_materials_test = 7
  number_groups_test = 7
  number_legendre_test = 8
  debugFlag_test = 0
  
  ebounds_test = [1.000000e+37,4.000000e+00,2.000000e-01,3.000000e-03,4.000000e-05,5.000000e-07,6.000000e-09,0.000000e+00]
  velocity_test = [3.158699e+09,1.265531e+09,2.062621e+08,2.214246e+07,2.447058e+06,4.107856e+05,8.296621e+04]
  sig_t_test = reshape((/0.21623600, 0.30664800, 0.44514700, 0.53631500, 0.55601600, 0.71102300, 1.75422000, &
                         0.22840500, 0.31768300, 0.46417600, 0.55616200, 0.58850800, 0.98602300, 2.18612000, &
                         0.22818900, 0.31742800, 0.46480700, 0.56672900, 0.62346000, 1.25597000, 2.87089000, &
                         0.22807300, 0.31782600, 0.46535500, 0.57498500, 0.64967100, 1.48074000, 3.44862000, &
                         0.15358000, 0.25602200, 0.38234300, 0.28413800, 0.25509500, 0.26036200, 0.29965500, &
                         0.10642700, 0.29292300, 0.83901200, 1.05242000, 1.08411000, 1.89404000, 5.59617000/), &
                         shape(sig_t_test))
  nu_sig_f_test = reshape((/0.04377570, 0.01259030, 0.00249733, 0.01962850, 0.05301660, 0.52135500, 2.03165000, &
                          0.04867930, 0.01496700, 0.00294972, 0.02593640, 0.07556850, 1.02075000, 3.02363000, &
                          0.05036610, 0.01643930, 0.00432797, 0.03766070, 0.10852500, 1.50444000, 4.39402000, &
                          0.05165750, 0.01756960, 0.00544935, 0.04686690, 0.13377400, 1.90256000, 5.53922000, &
                          0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, &
                          0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000/), &
                          shape(nu_sig_f_test))
  sig_f_test = reshape((/0.01361113, 0.00467188, 0.00097176, 0.00759461, 0.02030750, 0.19427521, 0.77935654, &
                         0.01502550, 0.00543715, 0.00103467, 0.00912987, 0.02654889, 0.35709163, 1.05926886, &
                         0.01544622, 0.00590706, 0.00150882, 0.01319072, 0.03796532, 0.52515394, 1.53287075, &
                         0.01576693, 0.00626443, 0.00189564, 0.01638571, 0.04672675, 0.66370610, 1.92955102, &
                         0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, &
                         0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000/), &
                         shape(sig_f_test))
  chi_test = reshape((/0.11505700, 0.85043100, 0.03444650, 0.00006613, 0.00000000, 0.00000000, 0.00000000, &
                       0.11924300, 0.84636000, 0.03434360, 0.00005324, 0.00000000, 0.00000000, 0.00000000, &
                       0.12066700, 0.84533500, 0.03392080, 0.00007787, 0.00000000, 0.00000000, 0.00000000, &
                       0.12019500, 0.84612500, 0.03359890, 0.00008078, 0.00000000, 0.00000000, 0.00000000, &
                       0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, &
                       0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000, 0.00000000/), &
                       shape(chi_test))
  sig_s_test = reshape((/1.40483000e-01,9.42122000e-02,7.25556000e-02,5.99072000e-02,4.63522000e-02,3.21268000e-02,2.00680000e-02,&
        1.14301000e-02,   5.45935000e-02, -9.86157000e-04,  4.45699000e-04,  3.24824000e-04, -3.98124000e-04, -2.87788000e-04,&
       -6.27927000e-05, -2.68265000e-05,  4.46131000e-03,  1.03513000e-05,  2.88584000e-05,  3.07981000e-06,  9.27746000e-08,&
        8.95180000e-06,  6.04032000e-06, -2.15160000e-05,  5.67970000e-06, -1.93756000e-06, -9.54919000e-08,  3.98292000e-07,&
       -5.54262000e-07,  3.54791000e-07, -5.90387000e-07,  3.38492000e-07,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,&
        0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,&
        0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,&
        0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,&
        0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,  0.00000000e+00,&
        0.00000000e+00,  2.90195000e-01,  6.81002000e-02,  4.12929000e-02,  2.01794000e-02,  1.21315000e-02,  5.41458000e-03,&
        2.43975000e-03,  7.13877000e-04,  1.00118000e-02, -1.71773000e-03,  5.07904000e-05,  1.16454000e-05,  -3.65514000e-06,&
       -9.21417000e-06,  -1.15427000e-06,   7.03809000e-06,   4.31254000e-06,   5.30705000e-07,   4.98607000e-09,   6.56702000e-08,&
       -3.06942000e-07,  -9.06458000e-08,   1.33253000e-07,  -3.94822000e-08,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   4.30856000e-01,   2.07762000e-02,   1.32256000e-03,   8.83757000e-05,   3.38281000e-05,&
       -1.07348000e-05,   3.31111000e-06,  -7.31177000e-05,   4.31667000e-03,  -1.34161000e-03,  -5.54658000e-05,   3.07669000e-06,&
       -8.52640000e-06,  -3.45038000e-06,   3.10179000e-06,   2.48849000e-07,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   4.78784000e-01,   1.06934000e-02,   9.16843000e-05,   1.97392000e-05,&
       -6.94651000e-05,  -3.34261000e-05,   2.59693000e-05,  -1.27557000e-05,   5.23292000e-03,  -1.62198000e-03,  -7.29505000e-05,&
       -2.24915000e-06,   3.17128000e-06,   1.04925000e-05,  -7.59823000e-06,   4.24191000e-06,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   3.93849000e-01,   1.01841000e-02,   5.72144000e-04,&
        5.13888000e-06,  -1.72000000e-04,   8.16604000e-05,   9.93405000e-06,   2.40003000e-06,   6.39980000e-03,  -1.46229000e-03,&
       -1.66809000e-04,  -2.82449000e-05,  -3.63744000e-05,  -1.47727000e-05,   4.79534000e-07,   1.52706000e-05,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   2.37858000e-03,  -2.47384000e-04,  -1.03905000e-04,&
       -4.30762000e-05,  -8.90478000e-06,  -7.77460000e-06,  -7.92134000e-06,  -2.61010000e-06,   3.74041000e-01,   8.29958000e-03,&
        3.70553000e-04,   1.72386000e-04,   4.84455000e-05,  -1.10155000e-04,   1.75277000e-05,   7.35265000e-05,   1.10108000e-03,&
       -8.17733000e-05,  -1.36923000e-05,  -2.17839000e-05,   6.15597000e-06,  -1.10089000e-05,  -7.90130000e-06,   3.80946000e-06,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,&
        0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   0.00000000e+00,   2.93938000e-01,  -2.29583000e-02,&
       -5.10469000e-03,  -2.96445000e-03,  -1.19434000e-03,  -2.96551000e-03,  -1.06301000e-03,  -1.96649000e-05,   1.99363000e-01,&
        2.21910000e-02,   9.38584000e-03,   6.56500000e-03,   3.63192000e-03,   1.11533000e-03,   8.18084000e-04,   1.27068000e-03 &
                      /), shape(sig_s_test))
  
  ! Test total cross section             
  t1 = testCond(norm2(sig_t - sig_t_test) < 1e-6)
  
  ! Test fission cross section  
  t2 = testCond(norm2(sig_f - sig_f_test) < 1e-6)
  
  ! Test nu * fission cross section  
  t3 = testCond(norm2(nu_sig_f - nu_sig_f_test) < 1e-6)
  
  ! Test chi
  t4 = testCond(norm2(chi - chi_test) < 1e-6)
  
  ! Test scattering cross section
  t5 = testCond(all(abs(sig_s(:,:,:,1) - sig_s_test) < 1e-3))
  
  ! Print appropriate output statements
  if (t1 == 0) then
    print *, 'material: sig_t failed'
  else if (t2 == 0) then
    print *, 'material: sig_f failed'
  else if (t3 == 0) then
    print *, 'material: nu_sig_f failed'
  else if (t4 == 0) then
    print *, 'material: chi failed'
  else if (t5 == 0) then
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
