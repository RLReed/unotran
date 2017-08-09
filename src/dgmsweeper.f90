module dgmsweeper
  use control, only : boundary_type, inner_print, inner_tolerance, lambda, use_recondensation
  use material, only : number_groups, number_legendre
  use mesh, only : dx, number_cells, mMap
  use angle, only : number_angles, p_leg, wt, mu
  use sweeper, only : computeEQ, updateSource
  use state, only : d_source, d_nu_sig_f, d_chi, d_sig_s, d_phi, d_delta
  use dgm, only : phi_0_moment, psi_0_moment, number_course_groups, expansion_order, sig_t_moment, &
                  energymesh, basis, compute_xs_moments, compute_flux_moments

  implicit none
  
  contains

  subroutine sweep(phi_new, psi_new, incoming)
    double precision, intent(inout) :: incoming(number_course_groups,2 * number_angles,0:expansion_order)
    double precision, intent(inout) :: phi_new(:,:,:), psi_new(:,:,:)
    double precision :: norm, inner_error, hold
    double precision, allocatable :: phi_m(:,:,:), psi_m(:,:,:)
    integer :: counter, i

    allocate(phi_m(0:number_legendre,number_course_groups,number_cells))
    allocate(psi_m(number_course_groups,number_angles*2,number_cells))
    phi_new = 0.0
    psi_new = 0.0
    phi_m = 0.0
    psi_m = 0.0

    ! Get the first guess for the flux moments
    call compute_flux_moments()

    do i = 0, expansion_order
      ! Initialize iteration variables
      inner_error = 1.0
      hold = 0.0
      counter = 1

      ! Compute the order=0 cross section moments
      call compute_xs_moments(order=i)

      ! Converge the 0th order flux moments
      do while (inner_error > inner_tolerance)  ! Interate to convergance tolerance
        ! Sweep through the mesh

        ! Use discrete ordinates to sweep over the moment equation
        call moment_sweep(phi_m, psi_m, incoming(:,:,i))

        ! Store norm of scalar flux
        norm = norm2(phi_m)
        ! error is the difference in the norm of phi for successive iterations
        inner_error = abs(norm - hold)
        ! Keep the norm for the next iteration
        hold = norm
        ! output the current error and iteration number
        if (inner_print) then
          print *, '    ', 'eps = ', inner_error, ' counter = ', counter, ' order = ', i, phi_m(0,:,1)
        end if
        ! increment the iteration
        counter = counter + 1

        ! Update the 0th order moments if working on converging zeroth moment
        if (i == 0) then
          !phi_0_moment = (1.0 - lambda) * phi_0_moment + lambda * phi_m
          !psi_0_moment = (1.0 - lambda) * psi_0_moment + lambda * psi_m
          phi_0_moment = phi_m
          psi_0_moment = psi_m
        end if

        if (i > 0) then
          exit
        end if

        ! If recondensation is active, break out of loop early
        if (use_recondensation) then
          call compute_xs_moments(order=i)
        end if

      end do

      ! Unfold 0th order flux
      call unfold_flux_moments(i, phi_m, psi_m, phi_new, psi_new)

    end do

    deallocate(phi_m, psi_m)
  end subroutine sweep

  ! Unfold the flux moments
  subroutine unfold_flux_moments(order, phi_moment, psi_moment, phi_new, psi_new)
    integer, intent(in) :: order
    double precision, intent(in) :: phi_moment(:,:,:), psi_moment(:,:,:)
    double precision, intent(out) :: psi_new(:,:,:), phi_new(:,:,:)
    integer :: a, c, cg, g, mat

    do c = 1, number_cells
      do a = 1, number_angles * 2
        do g = 1, number_groups
          cg = energyMesh(g)
          ! Scalar flux
          if (a == 1) then
            phi_new(:, g, c) = phi_new(:, g, c) + basis(g, order) * phi_moment(:, cg, c)
          end if
          ! Angular flux
          psi_new(g, a, c) = psi_new(g, a, c) +  basis(g, order) * psi_moment(cg, a, c)
        end do
      end do
    end do
  end subroutine unfold_flux_moments
  
  subroutine moment_sweep(phi_m, psi_m, incoming)
    integer :: o, c, a, cg, cgp, l, an, cmin, cmax, cstep, amin, amax, astep
    double precision :: Q(number_course_groups), Ps, invmu, fiss
    double precision :: M(0:number_legendre), source(number_course_groups)
    double precision, intent(inout) :: phi_m(:,:,:), incoming(:,:), psi_m(:,:,:)
    logical :: octant

    phi_m = 0.0  ! Reset phi
    psi_m = 0.0  ! Reset psi

    do o = 1, 2  ! Sweep over octants
      ! Sweep in the correct direction in the octant
      octant = o == 1
      cmin = merge(1, number_cells, octant)
      cmax = merge(number_cells, 1, octant)
      cstep = merge(1, -1, octant)
      amin = merge(1, number_angles, octant)
      amax = merge(number_angles, 1, octant)
      astep = merge(1, -1, octant)

      ! set boundary conditions
      incoming = boundary_type(o) * incoming  ! Set albedo conditions

      do c = cmin, cmax, cstep  ! Sweep over cells
        do a = amin, amax, astep  ! Sweep over angle
          ! Get the correct angle index
          an = merge(a, 2 * number_angles - a + 1, octant)
          ! get a common fraction
          invmu = dx(c) / (2 * abs(mu(a)))

          ! legendre polynomial integration vector
          M = 0.5 * wt(a) * p_leg(:, an)

          source(:) = d_source(:,an,c) - d_delta(:,an,c) * psi_0_moment(:,an,c)
          ! Update the right hand side
          Q = updateSource(number_course_groups, source(:), phi_0_moment(:,:,c), an, &
                           d_sig_s(:,:,:,c), d_nu_sig_f(:,c), d_chi(:,c))

          do cg = 1, number_course_groups  ! Sweep over group
            ! Use the specified equation.  Defaults to DD
            call computeEQ(Q(cg), incoming(cg, an), sig_t_moment(cg, c), invmu, Ps)

            psi_m(cg,an,c) = Ps

            ! Increment the legendre expansions of the scalar flux
            phi_m(:,cg,c) = phi_m(:,cg,c) + M(:) * Ps
          end do
        end do
      end do
    end do

  end subroutine moment_sweep
  
end module dgmsweeper
