program test_dgmsolver
!  call test2g()
!  call vacuum1()
!  call reflect1()
!  call vacuum2()
!  call reflect2()
  call eigenV2g()
end program test_dgmsolver

! Test the 2 group dgm solution
subroutine test2g()
  use control
  use dgmsolver

  implicit none

  ! initialize types
  integer :: testCond, t1=1, t2=1
  double precision :: phi_test(0:0,2,1), psi_test(2,4,1)
  double precision :: phi_new(0:0,2,1), psi_new(2,4,1)

  call initialize_control('test/dgm_test_options1', .true.)

  phi_test = reshape([1.1420149990909008,0.37464706668551212], shape(phi_test))

  psi_test = reshape([0.81304488744042813,0.29884810509581583,1.31748796916478740,0.41507830480599001,&
                      1.31748796916478740,0.41507830480599001,0.81304488744042813,0.29884810509581583&
                      ], shape(psi_test))

  ! initialize the variables necessary to solve the problem
  call initialize_dgmsolver()

  ! set source
  source(:,:,:) = 1.0

  ! set phi and psi to the converged solution
  phi = phi_test
  psi = psi_test

  call dgmsweep(phi_new, psi_new, incoming)

  t1 = testCond(norm2(phi - phi_test) < 1e-6)
  t2 = testCond(norm2(psi - psi_test) < 1e-6)

  if (t1 == 0) then
    print *, 'DGM solver 2g: phi failed'
  else if (t2 == 0) then
    print *, 'DGM solver 2g: psi failed'
  else
    print *, 'all tests passed for DGM solver 2g'
  end if

  call finalize_dgmsolver()
  call finalize_control()

end subroutine test2g

! Test against detran with vacuum conditions
subroutine vacuum1()
  use control
  use dgmsolver

  implicit none

  ! initialize types
  integer :: l, c, a, g, counter, testCond, t1, t2
  double precision :: norm, error, phi_test(7,28)

  ! Define problem parameters
  call initialize_control('test/dgm_test_options2', .true.)
  call initialize_dgmsolver()

  phi_test = reshape([  2.43576516357,  4.58369841267,  1.5626711117,  1.31245374786,  1.12046360588,  &
                        0.867236739559,  0.595606769942,  2.47769600029,  4.77942918468,  1.71039214967,  &
                        1.45482285016,  1.2432932006,  1.00395695756,  0.752760077886,  2.51693149995,  &
                        4.97587877605,  1.84928362206,  1.58461198915,  1.35194171606,  1.11805871638,  &
                        0.810409774028,  2.59320903064,  5.23311939144,  1.97104981208,  1.69430758654,  &
                        1.44165108478,  1.20037776749,  0.813247000713,  2.70124816247,  5.52967658354,  &
                        2.07046672497,  1.78060787735,  1.51140559905,  1.25273492166,  0.808917503514,  &
                        2.79641531407,  5.78666661987,  2.15462056117,  1.85286457556,  1.56944290225,  &
                        1.29575568046,  0.813378868173,  2.87941186529,  6.00774402332,  2.22561326404,  &
                        1.91334927054,  1.61778278393,  1.33135223233,  0.819884638625,  2.95082917982,  &
                        6.19580198153,  2.28505426287,  1.96372778133,  1.65788876716,  1.36080630864,  &
                        0.82640046716,  3.01116590643,  6.35316815516,  2.3341740765,  2.00522071328,  &
                        1.69082169384,  1.38498482157,  0.83227605712,  3.06083711902,  6.48170764214,  &
                        2.37390755792,  2.0387192711,  1.71734879522,  1.40447856797,  0.837283759523,  &
                        3.10018046121,  6.58289016281,  2.40495581492,  2.06486841143,  1.73802084073,  &
                        1.4196914264,  0.841334574174,  3.12946077671,  6.6578387922,  2.4278320614,  &
                        2.08412599358,  1.75322625595,  1.43089755336,  0.844390210178,  3.14887366178,  &
                        6.70736606465,  2.44289487705,  2.09680407626,  1.76322843396,  1.43827772036,  &
                        0.846433375617,  3.15854807829,  6.73199979835,  2.4503712844,  2.10309664539,  &
                        1.76819052183,  1.44194181402,  0.847456401368,  3.15854807829,  6.73199979835,  &
                        2.4503712844,  2.10309664539,  1.76819052183,  1.44194181402,  0.847456401368,  &
                        3.14887366178,  6.70736606465,  2.44289487705,  2.09680407626,  1.76322843396,  &
                        1.43827772036,  0.846433375617,  3.12946077671,  6.6578387922,  2.4278320614,  &
                        2.08412599358,  1.75322625595,  1.43089755336,  0.844390210178,  3.10018046121,  &
                        6.58289016281,  2.40495581492,  2.06486841143,  1.73802084073,  1.4196914264,  &
                        0.841334574174,  3.06083711902,  6.48170764214,  2.37390755792,  2.0387192711,  &
                        1.71734879522,  1.40447856797,  0.837283759523,  3.01116590643,  6.35316815516,  &
                        2.3341740765,  2.00522071328,  1.69082169384,  1.38498482157,  0.83227605712,  &
                        2.95082917982,  6.19580198153,  2.28505426287,  1.96372778133,  1.65788876716,  &
                        1.36080630864,  0.82640046716,  2.87941186529,  6.00774402332,  2.22561326404,  &
                        1.91334927054,  1.61778278393,  1.33135223233,  0.819884638625,  2.79641531407,  &
                        5.78666661987,  2.15462056117,  1.85286457556,  1.56944290225,  1.29575568046,  &
                        0.813378868173,  2.70124816247,  5.52967658354,  2.07046672497,  1.78060787735,  &
                        1.51140559905,  1.25273492166,  0.808917503514,  2.59320903064,  5.23311939144,  &
                        1.97104981208,  1.69430758654,  1.44165108478,  1.20037776749,  0.813247000713,  &
                        2.51693149995,  4.97587877605,  1.84928362206,  1.58461198915,  1.35194171606,  &
                        1.11805871638,  0.810409774028,  2.47769600029,  4.77942918468,  1.71039214967,  &
                        1.45482285016,  1.2432932006,  1.00395695756,  0.752760077886,  2.43576516357,  &
                        4.58369841267,  1.5626711117,  1.31245374786,  1.12046360588,  0.867236739559,  &
                        0.595606769942 ],shape(phi_test))

  phi(0,:,:) = phi_test

  call dgmsolve()

  t1 = testCond(norm2(phi(0,:,:) - phi_test) < 1e-5)

  if (t1 == 0) then
    print *, 'dgmsolver: vacuum test 1 failed'
  else
    print *, 'all tests passed for dgmsolver vacuum 1'
  end if

  call finalize_dgmsolver()
  call finalize_control()

end subroutine vacuum1

! test against detran with reflective conditions
subroutine reflect1()
  use control
  use dgmsolver

  implicit none

  ! initialize types
  integer :: l, c, a, g, counter, testCond, t1, t2
  double precision :: norm, error, phi_test(7,28)

  ! Define problem parameters
  call initialize_control('test/dgm_test_options2', .true.)
  material_map = [1, 1, 1]
  boundary_type = [1.0, 1.0]
  allow_fission = .false.
  outer_tolerance = 1e-8
  call initialize_dgmsolver()

  source = 1.0

  phi_test = reshape([  94.51265887,  106.66371692,   75.39710228,   17.95365148,&
                         6.2855009 ,    3.01584797,    1.21327705,   94.51265887,&
                       106.66371692,   75.39710228,   17.95365148,    6.2855009 ,&
                         3.01584797,    1.21327705,   94.51265887,  106.66371692,&
                        75.39710228,   17.95365148,    6.2855009 ,    3.01584797,&
                         1.21327705,   94.51265887,  106.66371692,   75.39710228,&
                        17.95365148,    6.2855009 ,    3.01584797,    1.21327705,&
                        94.51265887,  106.66371692,   75.39710228,   17.95365148,&
                         6.2855009 ,    3.01584797,    1.21327705,   94.51265887,&
                       106.66371692,   75.39710228,   17.95365148,    6.2855009 ,&
                         3.01584797,    1.21327705,   94.51265887,  106.66371692,&
                        75.39710228,   17.95365148,    6.2855009 ,    3.01584797,&
                         1.21327705,   94.51265887,  106.66371692,   75.39710228,&
                        17.95365148,    6.2855009 ,    3.01584797,    1.21327705,&
                        94.51265887,  106.66371692,   75.39710228,   17.95365148,&
                         6.2855009 ,    3.01584797,    1.21327705,   94.51265887,&
                       106.66371692,   75.39710228,   17.95365148,    6.2855009 ,&
                         3.01584797,    1.21327705,   94.51265887,  106.66371692,&
                        75.39710228,   17.95365148,    6.2855009 ,    3.01584797,&
                         1.21327705,   94.51265887,  106.66371692,   75.39710228,&
                        17.95365148,    6.2855009 ,    3.01584797,    1.21327705,&
                        94.51265887,  106.66371692,   75.39710228,   17.95365148,&
                         6.2855009 ,    3.01584797,    1.21327705,   94.51265887,&
                       106.66371692,   75.39710228,   17.95365148,    6.2855009 ,&
                         3.01584797,    1.21327705,   94.51265887,  106.66371692,&
                        75.39710228,   17.95365148,    6.2855009 ,    3.01584797,&
                         1.21327705,   94.51265887,  106.66371692,   75.39710228,&
                        17.95365148,    6.2855009 ,    3.01584797,    1.21327705,&
                        94.51265887,  106.66371692,   75.39710228,   17.95365148,&
                         6.2855009 ,    3.01584797,    1.21327705,   94.51265887,&
                       106.66371692,   75.39710228,   17.95365148,    6.2855009 ,&
                         3.01584797,    1.21327705,   94.51265887,  106.66371692,&
                        75.39710228,   17.95365148,    6.2855009 ,    3.01584797,&
                         1.21327705,   94.51265887,  106.66371692,   75.39710228,&
                        17.95365148,    6.2855009 ,    3.01584797,    1.21327705,&
                        94.51265887,  106.66371692,   75.39710228,   17.95365148,&
                         6.2855009 ,    3.01584797,    1.21327705,   94.51265887,&
                       106.66371692,   75.39710228,   17.95365148,    6.2855009 ,&
                         3.01584797,    1.21327705,   94.51265887,  106.66371692,&
                        75.39710228,   17.95365148,    6.2855009 ,    3.01584797,&
                         1.21327705,   94.51265887,  106.66371692,   75.39710228,&
                        17.95365148,    6.2855009 ,    3.01584797,    1.21327705,&
                        94.51265887,  106.66371692,   75.39710228,   17.95365148,&
                         6.2855009 ,    3.01584797,    1.21327705,   94.51265887,&
                       106.66371692,   75.39710228,   17.95365148,    6.2855009 ,&
                         3.01584797,    1.21327705,   94.51265887,  106.66371692,&
                        75.39710228,   17.95365148,    6.2855009 ,    3.01584797,&
                         1.21327705,   94.51265887,  106.66371692,   75.39710228,&
                        17.95365148,    6.2855009 ,    3.01584797,    1.21327705 &
                       ],shape(phi_test))

  phi(0,:,:) = phi_test

  call dgmsolve()

  t1 = testCond(all(abs(phi(0,:,:) - phi_test) < 1e-5))

  if (t1 == 0) then
    print *, 'dgmsolver: reflection test 1 failed'
  else
    print *, 'all tests passed for dgmsolver reflect 1'
  end if

  call finalize_dgmsolver()
  call finalize_control()

end subroutine reflect1

! Test against detran with vacuum conditions and 1 spatial cell
subroutine vacuum2()
  use control
  use dgmsolver

  implicit none

  ! initialize types
  integer :: fineMesh(1), materialMap(1), l, c, a, g, counter, testCond, t1, t2
  double precision :: coarseMesh(2), norm, error, phi_test(7,1), boundary(2), psi_test(7,4,1)

  call initialize_control('test/dgm_test_options3', .true.)
  call initialize_dgmsolver()

  phi_test = reshape([  1.1076512516190389,1.1095892550819531,1.0914913168898499,1.0358809957845283,&
                        0.93405352272848619,0.79552760081182894,0.48995843862242699 ],shape(phi_test))

  psi_test = reshape([ 0.62989551954274092,0.65696484059125337,0.68041606804080934,0.66450867626366705,&
                       0.60263096140806338,0.53438683380855967,0.38300537939872042,1.3624866129734592,&
                       1.3510195477616225,1.3107592451448140,1.2339713438183100,1.1108346317861364,&
                       0.93482033401344933,0.54700730201708170,1.3624866129734592,1.3510195477616225,&
                       1.3107592451448140,1.2339713438183100,1.1108346317861364,0.93482033401344933,&
                       0.54700730201708170,0.62989551954274092 ,0.65696484059125337,0.68041606804080934,&
                       0.66450867626366705,0.60263096140806338,0.53438683380855967,0.38300537939872042 ], shape(psi_test))

  phi(0,:,:) = phi_test
  psi(:,:,:) = psi_test
  source(:,:,:) = 1.0

  call dgmsolve()

  t1 = testCond(norm2(phi(0,:,:) - phi_test) < 1e-5)

  if (t1 == 0) then
    print *, 'dgmsolver: vacuum test 2 failed'
  else
    print *, 'all tests passed for dgmsolver vacuum 2'
  end if

  call finalize_dgmsolver()
  call finalize_control()

end subroutine vacuum2

! test against detran with reflective conditions
subroutine reflect2()
  use control
  use dgmsolver

  implicit none

  ! initialize types
  integer :: fineMesh(1), materialMap(1), l, c, a, g, counter, testCond, t1, t2
  double precision :: coarseMesh(2), norm, error, phi_test(7,1), psi_test(7,4,1), boundary(2)

  call initialize_control('test/dgm_test_options3', .true.)
  boundary_type = [1.0, 1.0]
  call initialize_dgmsolver()

  source = 1.0

  phi_test = reshape([ 94.51265887,  106.66371692,   75.39710228,   17.95365148,&
                        6.2855009 ,    3.01584797,    1.21327705],shape(phi_test))

  psi_test = reshape([94.512658438949273,106.66371642824166,75.397102078564259,17.953651480951333,&
                      6.2855008963667123,3.0158479735464110,1.2132770548341645,94.512658454844384,&
                      106.66371644092482,75.397102082192546,17.953651480951343,6.2855008963667141,&
                      3.0158479735464105,1.2132770548341649,94.512658454844384,106.66371644092482,&
                      75.397102082192546,17.953651480951343,6.2855008963667141,3.0158479735464105,&
                      1.2132770548341649,94.512658438949273,106.66371642824166,75.397102078564259,&
                      17.953651480951333,6.2855008963667123,3.0158479735464110,1.2132770548341645], shape(psi_test))

  phi(0,:,:) = phi_test
  psi(:,:,:) = psi_test
  source(:,:,:) = 1.0

  call dgmsolve()

  t1 = testCond(all(abs(phi(0,:,:) - phi_test) < 1e-5))

  if (t1 == 0) then
    print *, 'dgmsolver: reflection test 2 failed'
  else
    print *, 'all tests passed for dgmsolver reflect 2'
  end if

  call finalize_dgmsolver()
  call finalize_control()

end subroutine reflect2

! Test the 2g eigenvalue problem
subroutine eigenV2g()
  use control
  use dgmsolver
  use angle, only : wt

  implicit none

  ! initialize types
  integer :: testCond, t1, t2, t3, a, c
  double precision :: phi_test(2,10), psi_test(2,4,10), keff_test

  ! Define problem parameters
  call initialize_control('test/eigen_test_options', .true.)
  xs_name = 'test/2gXS.anlxs'
  source_value = 0.0
  boundary_type = [0.0, 0.0]
  legendre_order = 0
  dgm_basis_name = '2gbasis'
  use_DGM = .true.
  use_recondensation = .false.
  outer_print = .false.
  inner_print = .false.
  lambda = 0.03
  max_inner_iters = 50
  max_outer_iters = 5000
  ignore_warnings = .true.

!  call output_control()

  call initialize_dgmsolver()

  keff_test = 0.809952323

  phi_test = reshape([0.0588274918942, 0.00985808742285, 0.109950141974, 0.0193478123294,  0.149799204, &
                      0.026176658006, 0.178131036674, 0.0312242163256, 0.192866360834, 0.03377131381, &
                      0.192866360834, 0.0337713138118, 0.178131036674, 0.0312242163256,  0.149799204, &
                      0.026176658006, 0.109950141974, 0.0193478123294, 0.0588274918942, 0.009858087423],shape(phi_test))

  call dgmsolve()

  phi = phi / phi(0,1,1) * phi_test(1,1)

  t1 = testCond(norm2(phi(0,:,:) - phi_test) < 1e-6)

  phi_test = 0
  do c = 1, number_cells
    do a = 1, number_angles
      phi_test(:,c) = phi_test(:,c) + 0.5 * wt(a) * psi(:,a,c)
      phi_test(:,c) = phi_test(:,c) + 0.5 * wt(number_angles - a + 1) * psi(:, 2 * number_angles - a + 1,c)
    end do
  end do
  phi_test(:,:) = phi_test(:,:) / phi(0,:,:)
  t2 = testCond(all(abs(phi_test(:,:) - sum(phi_test) / 20) < 5e-4))

  t3 = testCond(abs(d_keff - keff_test) < 1e-6)

  if (t1 == 0) then
    print *, 'dgmsolver: eigen 2g vacuum solver phi failed'
  else if (t2 == 0) then
    print *, 'dgmsolver: eigen 2g vacuum solver psi failed'
  else if (t3 == 0) then
    print *, 'dgmsolver: eigen 2g vacuum solver keff failed'
  else
    print *, 'all tests passed for eigen 2g vacuum dgmsolver'
  end if

  call finalize_dgmsolver()
  call finalize_control()

end subroutine eigenV2g

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
