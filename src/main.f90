program main
  ! ############################################################################
  ! Discrete ordinates solver in 1-D with options for :
  !     Discrete Generalized Multigroup
  !     Fixed Source problems
  !     Eigenvalue Problems
  ! ############################################################################

  use control, only : initialize_control, use_DGM, finalize_control
  use dgmsolver
  use solver, only : initialize_solver, solve, output, finalize_solver

  implicit none
  
  ! initialize types
  character(80) :: &
      inputfile  ! Name of the input file provided from command line
  
  if ( COMMAND_ARGUMENT_COUNT() .lt. 1 ) then
    stop "*** ERROR: user input file not specified ***"
  else
    call get_command_argument(1, inputfile);
  end if

  ! Initialize the solver using options set in the input file
  call initialize_control(inputfile)

  print *, 'Successfully read ', inputfile

  ! Call the correct solver
  if (use_DGM) then
    print *, 'Initializing solver'
    call initialize_dgmsolver()
    print *, 'Success'
    print *, 'Running solver'
    call dgmsolve()
    !call dgmoutput()
    call finalize_dgmsolver()
  else
    print *, 'Initializing solver'
    call initialize_solver()
    print *, 'Success'
    print *, 'Running solver'
    call solve()
    !call output()
    call finalize_solver()
  end if

  ! Clean up the problem
  call finalize_control()

end program main
