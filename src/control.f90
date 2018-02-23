module control
  ! ############################################################################
  ! Define the options for solving the transport equation
  ! ############################################################################

  implicit none

  ! control variables
  double precision, allocatable, dimension(:) :: &
      coarse_mesh                   ! Coarse mesh boundaries
  integer, allocatable, dimension(:) :: &
      fine_mesh,                  & ! Number of fine cells per coarse region
      material_map,               & ! Material ID within each coarse region
      energy_group_map,           & ! Coarse energy group boundaries
      truncation_map                ! Expansion order within each coarse group (optional)
  double precision :: &
      boundary_type(2),           & ! Albedo value at [left, right] boundary
      recon_tolerance=1e-8,       & ! Convergance criteria for recon iteration
      eigen_tolerance=1e-8,       & ! Convergance criteria for eigen iteration
      outer_tolerance=1e-8,       & ! Convergance criteria for outer iteration
      inner_tolerance=1e-8,       & ! Convergance criteria for inner iteration
      lamb=1.0,                   & ! Parameter (0 < lamb <= 1.0) for krasnoselskii iteration
      source_value=0.0,           & ! Value of external source for the problem
      initial_keff=1.0              ! Initial value for the eigenvalue
  character(len=256) :: &
      xs_name,                    & ! Name of the cross section file
      dgm_basis_name,             & ! Name of file containing energy basis
      file_name,                  & ! Name of file containing the options
      initial_phi,                & ! Name of file with initial scalar flux
      initial_psi,                & ! Name of file with initial angular flux
      solver_type                   ! Choice of [eigen, fixed] solver
  character(len=2) :: &
      equation_type="DD"            ! Closure equation for discrete ordinates [DD, SC, SD]
  integer :: &
      angle_order,                & ! Number of angles per octant
      angle_option,               & ! Quadrature option [gl=0, dgl=1]
      legendre_order=-1,          & ! Anisotropic scattering order
      max_recon_iters=1000,       & ! Maximum iterations for recon loop
      max_eigen_iters=1000,       & ! Maximum iterations for eigen loop
      max_outer_iters=1000,       & ! Maximum iterations for outer loop
      max_inner_iters=1000          ! Maximum iterations for inner loop
  logical :: &
      allow_fission=.false.,      & ! Enable/Disable fission in the problem
      recon_print=.true.,         & ! Enable/Disable recon iteration printing
      eigen_print=.true.,         & ! Enable/Disable eigen iteration printing
      outer_print=.true.,         & ! Enable/Disable outer iteration printing
      inner_print=.false.,        & ! Enable/Disable inner iteration printing
      use_dgm=.false.,            & ! Enable/Disable DGM solver
      store_psi=.false.,          & ! Enable/Disable storing the angular flux
      ignore_warnings=.true.        ! Enable/Disable warning messages

  contains

  subroutine initialize_control(fname, silent)
    ! ##########################################################################
    ! Read the options file and output the choices if not silent
    ! ##########################################################################

    ! Input variables
    character(len=256) :: &
        buffer, & ! Buffer to hold read-in strings
        label     ! Contains the read-variable name
    character(len=*), intent(in) :: &
        fname     ! Name of the file containing options
    integer :: &
        pos,    & ! Position indicator in the line
        ios=0,  & ! I/O file flag
        line=0    ! Line number
    integer, parameter :: &
        fh=15     ! File number
    logical, optional :: &
        silent    ! Flag to prevent printing the read variables and values
    logical :: &
        no_print  ! Local flag to prevent printing the read variables and values

    ! Set the local value of no_print from silent
    if (present(silent)) then
      no_print = silent   ! Use provided value
    else
      no_print = .false.  ! Default value
    end if

    ! Cut the trailing whitespace from fname
    file_name = trim(adjustl(fname))

    ! Start reading the options file
    open(fh, file=file_name, action='read', iostat=ios)
    if (ios > 0) stop "*** ERROR: user input file not found ***"

    ! ios is negative if an end of record condition is encountered or if
    ! an endfile condition was detected.  It is positive if an error was
    ! detected.  ios is zero otherwise.
    do while (ios == 0)
      read(fh, '(A)', iostat=ios) buffer
      if (ios == 0) then
        ! Increment the line count
        line = line + 1

        ! Find the first whitespace and split label and data
        pos = scan(buffer, '    ')
        label = buffer(1:pos)
        buffer = buffer(pos+1:)

        ! Parse the label and save the value to the proper variable
        select case (label)
        case ('fine_mesh')
          allocate(fine_mesh(nitems(buffer)))
          read(buffer, *, iostat=ios) fine_mesh
        case ('coarse_mesh')
          allocate(coarse_mesh(nitems(buffer)))
          read(buffer, *, iostat=ios) coarse_mesh
        case ('material_map')
          allocate(material_map(nitems(buffer)))
          read(buffer, *, iostat=ios) material_map
        case ('xs_file')
          xs_name=trim(adjustl(buffer))
        case ('initial_phi')
          initial_phi=trim(adjustl(buffer))
        case ('initial_psi')
          initial_psi=trim(adjustl(buffer))
        case ('initial_keff')
          read(buffer, *, iostat=ios) initial_keff
        case ('angle_order')
          read(buffer, *, iostat=ios) angle_order
        case ('angle_option')
          read(buffer, *, iostat=ios) angle_option
        case ('boundary_type')
          read(buffer, *, iostat=ios) boundary_type
        case ('allow_fission')
          read(buffer, *, iostat=ios) allow_fission
        case ('energy_group_map')
          allocate(energy_group_map(nitems(buffer)))
          read(buffer, *, iostat=ios) energy_group_map
        case ('dgm_basis_file')
          dgm_basis_name=trim(adjustl(buffer))
        case ('truncation_map')
          allocate(truncation_map(nitems(buffer)))
          read(buffer, *, iostat=ios) truncation_map
        case ('recon_print')
          read(buffer, *, iostat=ios) recon_print
        case ('eigen_print')
          read(buffer, *, iostat=ios) eigen_print
        case ('outer_print')
          read(buffer, *, iostat=ios) outer_print
        case ('inner_print')
          read(buffer, *, iostat=ios) inner_print
        case ('recon_tolerance')
          read(buffer, *, iostat=ios) recon_tolerance
        case ('eigen_tolerance')
          read(buffer, *, iostat=ios) eigen_tolerance
        case ('outer_tolerance')
          read(buffer, *, iostat=ios) outer_tolerance
        case ('inner_tolerance')
          read(buffer, *, iostat=ios) inner_tolerance
        case ('lambda')
          read(buffer, *, iostat=ios) lamb
        case ('use_DGM')
          read(buffer, *, iostat=ios) use_DGM
        case ('store_psi')
          read(buffer, *, iostat=ios) store_psi
        case ('ignore_warnings')
          read(buffer, *, iostat=ios) ignore_warnings
        case ('equation_type')
          equation_type=trim(adjustl(buffer))
        case ('solver_type')
          solver_type=trim(adjustl(buffer))
        case ('source')
          read(buffer, *, iostat=ios) source_value
        case ('legendre_order')
          read(buffer, *, iostat=ios) legendre_order
        case ('max_recon_iters')
          read(buffer, *, iostat=ios) max_recon_iters
        case ('max_eigen_iters')
          read(buffer, *, iostat=ios) max_eigen_iters
        case ('max_outer_iters')
          read(buffer, *, iostat=ios) max_outer_iters
        case ('max_inner_iters')
          read(buffer, *, iostat=ios) max_inner_iters
        case default
          print *, 'Skipping invalid label at line', line
        end select
      end if
    end do
    close(fh)

    ! If DGM is enabled, angular flux must be stored
    if (use_DGM) then
      store_psi = .true.
    end if

    ! Unless disabled, send the options to standard output
    if (.not. no_print) then
      call output_control()
    end if

    ! Kill the program if an invalid solver_type is selected
    if (solver_type == 'eigen') then
      continue
    else if (solver_type == 'fixed') then
      continue
    else
      print *, 'FATAL ERROR : Invalid solver type'
      stop
    end if

  end subroutine initialize_control

  subroutine output_control()
    ! ##########################################################################
    ! Output the variables/options to the standard output
    ! ##########################################################################

    print *, 'MESH VARIABLES'
    print *, '  fine_mesh          = [', fine_mesh, ']'
    print *, '  coarse_mesh        = [', coarse_mesh, ']'
    print *, '  material_map       = [', material_map, ']'
    print *, '  boundary_type      = [', boundary_type, ']'
    print *, 'MATERIAL VARIABLES'
    print *, '  xs_file_name       = "', trim(xs_name), '"'
    print *, 'ANGLE VARIABLES'
    print *, '  angle_order        = ', angle_order
    print *, '  angle_option       = ', angle_option
    print *, 'SOURCE'
    print *, '  constant source    = ', source_value
    print *, 'OPTIONS'
    print *, '  initial_phi        = ', trim(initial_phi)
    print *, '  initial_psi        = ', trim(initial_psi)
    print *, '  initial_keff       = ', initial_keff
    print *, '  solver_type        = "', trim(solver_type), '"'
    print *, '  equation_type      = "', trim(equation_type), '"'
    print *, '  store_psi          = ', store_psi
    print *, '  allow_fission      = ', allow_fission
    if (solver_type == 'eigen') then
      print *, '  eigen_print        = ', eigen_print
      print *, '  eigen_tolerance    = ', eigen_tolerance
      print *, '  max_eigen_iters    = ', max_eigen_iters
    end if
    print *, '  outer_print        = ', outer_print
    print *, '  outer_tolerance    = ', outer_tolerance
    print *, '  max_outer_iters    = ', max_outer_iters
    print *, '  inner_print        = ', inner_print
    print *, '  inner_tolerance    = ', inner_tolerance
    print *, '  max_inner_iters    = ', max_inner_iters
    print *, '  lambda             = ', lamb
    print *, '  ignore_warnings    = ', ignore_warnings
    if (legendre_order > -1) then
      print *, '  legendre_order     = ', legendre_order
    else
      print *, '  legendre_order     = DEFAULT'
    end if
    if (use_DGM) then
      print *, 'DGM OPTIONS'
      print *, '  dgm_basis_file     = "', trim(dgm_basis_name), '"'
      print *, '  use_DGM            = ', use_DGM
      print *, '  recon_print        = ', recon_print
      print *, '  recon_tolerance    = ', recon_tolerance
      print *, '  max_recon_iters    = ', max_recon_iters
      if (allocated(truncation_map)) then
        print *, '  energy_group_map   = [', energy_group_map, ']'
      end if
      if (allocated(truncation_map)) then
        print *, '  truncation_map     = [', truncation_map, ']'
      end if
    else
      print *, '  use_dgm            = ', use_dgm
    end if

  end subroutine output_control

  subroutine finalize_control()
    ! ##########################################################################
    ! Deallocate all allocated arrays
    ! ##########################################################################

    if (allocated(fine_mesh)) then
      deallocate(fine_mesh)
    end if
    if (allocated(coarse_mesh)) then
      deallocate(coarse_mesh)
    end if
    if (allocated(material_map)) then
      deallocate(material_map)
    end if
    if (allocated(energy_group_map)) then
      deallocate(energy_group_map)
    end if
    if (allocated(truncation_map)) then
      deallocate(truncation_map)
    end if
  end subroutine finalize_control

  ! Copied from http://www.tek-tips.com/viewthread.cfm?qid=1688013
  ! Credit to salgerman
  integer function nitems(line)
    ! ##########################################################################
    ! Compute the number of space-separated items in a line
    ! ##########################################################################

    character line*(*)
    logical back
    integer length, k

    back = .true.
    length = len_trim(line)
    k = index(line(1:length), ' ', back)
    if (k == 0) then
      nitems = 0
      return
    end if

    nitems = 1
    do
      ! starting with the right most blank space,
      ! look for the next non-space character down
      ! indicating there is another item in the line
      do
        if (k <= 0) exit
        if (line(k:k) == ' ') then
          k = k - 1
          cycle
        else
          nitems = nitems + 1
          exit
        end if
      end do

      ! once a non-space character is found,
      ! skip all adjacent non-space character
      do
        if ( k<=0 ) exit
        if (line(k:k) /= ' ') then
          k = k - 1
          cycle
        end if
        exit
      end do
      if (k <= 0) exit
    end do
  end function nitems

end module control
