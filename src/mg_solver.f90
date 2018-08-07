module mg_solver

  implicit none
  
  contains
  
  subroutine mg_solve(source, phi, psi, incident, higher_dgm_flag)
    ! ##########################################################################
    ! Solve the within group equation
    ! ##########################################################################

    ! Use Statements
    use control, only : ignore_warnings, max_outer_iters, outer_print, outer_tolerance, &
                        number_groups, number_cells, number_angles, number_legendre
    use wg_solver, only : wg_solve

    ! Variable definitions
    double precision, intent(in), dimension(:,:,:) :: &
        source               ! External source
    logical, intent(in) :: &
        higher_dgm_flag      ! Flag to limit iterations to 1
    double precision, intent(inout), dimension(0:,:,:) :: &
        phi                  ! Scalar flux
    double precision, intent(inout), dimension(:,:,:) :: &
        psi                  ! Angular flux
    double precision, intent(inout), dimension(:,:) :: &
        incident             ! Angular flux incident on the cell
    double precision, allocatable, dimension(:,:,:) :: &
        phi_old              ! Save the previous scalar flux
    double precision, dimension(number_cells, 2 * number_angles) :: &
        total_S              ! Sum of all sources
    integer :: &
        outer_count,       & ! Counter for the outer loop
        l,                 & ! Legendre index
        g                    ! Group index
    double precision :: &
        outer_error          ! Residual error between iterations

    ! Save the scalar flux from previous iteration
    allocate(phi_old(0:number_legendre, number_cells, number_groups))
    phi_old = 0.0

    ! Begin loop to converge on the in-scattering source
    do outer_count = 1, max_outer_iters
      ! save old value of scalar flux
      phi_old = phi

      ! Loop over the energy groups
      do g = 1, number_groups
        total_S = source(:,:,g)

        ! compute fixed source if not a higher moment DGM sweep
        if (.not. higher_dgm_flag) then
            call compute_mg_source(g, phi, total_S)
        end if

        ! Solve the within group problem
        call wg_solve(g, total_S, phi(:,:,g), psi(:,:,g), incident(:,g), higher_dgm_flag)

      end do

      ! Update the error
      outer_error = maxval(abs(phi_old - phi))

      ! Check for NaN during convergence
      if (outer_error /= outer_error) then
        print *, "NaN detected...exiting"
        stop
      end if

      ! Print output
      if (outer_print > 0) then
        write(*, 1001) outer_count, outer_error
        1001 format ( "  outer: ", i4, " Error: ", es12.5E2)
        if (outer_print > 1) then
          print *, phi
        end if
      end if

      ! Check if tolerance is reached
      if (outer_error < outer_tolerance .or. higher_dgm_flag) then
        exit
      end if
    end do

    if (outer_count == max_outer_iters) then
      if (.not. ignore_warnings) then
        ! Warning if more iterations are required
        write(*, 1002) outer_count
        1002 format ('outer iteration did not converge in ', i4, ' iterations')
      end if
    end if

    ! Deallocate memory
    deallocate(phi_old)

  end subroutine mg_solve

  subroutine compute_mg_source(g, phi, source)
    ! ##########################################################################
    ! Get the source including external, fission, and in-scatter
    ! ##########################################################################

    ! Use Statements
    use angle, only : p_leg
    use state, only : mg_nu_sig_f, mg_sig_s, mg_chi, keff, mg_mMap
    use control, only : solver_type, number_groups, number_cells, number_angles, &
                        number_legendre, allow_fission

    ! Variable definitions
    integer, intent(in) :: &
        g       ! Group index
    double precision, intent(in), dimension(0:,:,:) :: &
        phi     ! Scalar flux
    double precision, intent(inout), dimension(:,:) :: &
        source  ! Container to hold the computed source
    integer :: &
        c,    & ! Cell index
        gp,   & ! Alternate group index
        a,    & ! Angle index
        mat,  & ! Material index
        l       ! Legendre index

    ! Add the fission source if fixed source problem
    if (solver_type == 'fixed' .and. allow_fission) then
      do c = 1, number_cells
        mat = mg_mMap(c)
        source(c,:) = source(c,:) + 0.5 * mg_chi(mat, g) * dot_product(mg_nu_sig_f(mat,:), phi(0,c,:)) / keff
      end do
    end if

    ! Add the in-scattering source for each Legendre moment
    do gp = 1, number_groups
      ! Ignore the within-group terms
      if (g == gP) then
        cycle
      end if

      do a = 1, 2 * number_angles
        do c = 1, number_cells
          mat = mg_mMap(c)
          do l = 0, number_legendre
            source(c,a) = source(c,a) + 0.5 * p_leg(l, a) * mg_sig_s(l, mat, gp, g) * phi(l,c,gp)
          end do
        end do
      end do
    end do

  end subroutine compute_mg_source

end module mg_solver