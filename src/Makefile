# Makefile for Unotran and related tests

#===============================================================================
# Compilation settings
#===============================================================================

F90 = gfortran
F90FLAGS = -O3 -fcheck=all -fdefault-double-8 -fdefault-real-8 -pg -pedantic -std=f2008 -Wall -fopenmp
LDFLAGS = 


#===============================================================================
# Object Files
#===============================================================================

objects =        \
angle.o          \
control.o        \
dgm.o            \
dgmsolver.o      \
material.o       \
mesh.o           \
mg_solver.o      \
solver.o         \
sources.o        \
state.o          \
sweeper_1D.o     \
sweeper_2D.o       

 
#===============================================================================
# Targets
#===============================================================================

# main executable
xdgm: $(objects) main.f90
	$(F90) $(F90FLAGS) $(LDFLAGS) $^ -o $@ 

# executable tests
test_angle: pydgm
	python test/test_angle.py
test_dgm: pydgm
	python test/test_dgm.py
test_dgmsolver: pydgm
	python test/test_dgmsolver.py
test_dgmsweeper: pydgm
	python test/test_dgmsweeper.py
test_material: pydgm
	python test/test_material.py
test_mesh: pydgm
	python test/test_mesh.py
test_solver: pydgm
	python test/test_solver.py
test_sources: pydgm
	python test/test_sources.py
test_state: pydgm
	python test/test_state.py
test_sweeper_1D: pydgm
	python test/test_sweeper_1D.py
test_sweeper_2D: pydgm
	python test/test_sweeper_2D.py
test: pydgm
	python test/test_all.py

# f2py module
pydgm: control.f90 angle.f90 material.f90 mesh.f90 dgm.f90 state.f90 sources.f90 sweeper_1D.f90 sweeper_2D.f90 mg_solver.f90 solver.f90 dgmsolver.f90 
	@rm -f pydgm*so
	f2py --f90flags="$(F90FLAGS)" -c -lgomp -m $@ $^

# Debug module
debug: F90FLAGS += -g -Wall -pedantic -fbacktrace
debug: xdgm

# Remove objects, module files, and exectables
clean:
	@rm -f *.o *.mod pydgm*so xdgm test/*.x


#===============================================================================
# Rules
#===============================================================================

.SUFFIXES: .F90 .o
.PHONY: clean neat

%.o: %.f90
	$(F90) $(F90FLAGS) $(INCLUDE) -c $<


#===============================================================================
# Dependencies
#===============================================================================

angle.o: control.o
dgm.o: angle.o
dgm.o: control.o
dgm.o: material.o
dgm.o: mesh.o
dgmsolver.o: angle.o
dgmsolver.o: control.o
dgmsolver.o: dgm.o
dgmsolver.o: material.o
dgmsolver.o: mesh.o
dgmsolver.o: solver.o
dgmsolver.o: state.o
main.o: control.o
main.o: dgmsolver.o
main.o: solver.o
material.o: control.o
mesh.o: control.o
mg_solver.o: angle.o
mg_solver.o: control.o
mg_solver.o: material.o
mg_solver.o: mesh.o
mg_solver.o: sources.o
mg_solver.o: state.o
mg_solver.o: sweeper_1D.o
mg_solver.o: sweeper_2D.o
solver.o: angle.o
solver.o: control.o
solver.o: material.o
solver.o: mesh.o
solver.o: mg_solver.o
solver.o: state.o
solver.o: sweeper_1D.o
solver.o: sweeper_2D.o
sources.o: angle.o
sources.o: control.o
sources.o: dgm.o
sources.o: state.o
state.o: angle.o
state.o: control.o
state.o: dgm.o
state.o: material.o
state.o: mesh.o
sweeper_1D.o: angle.o
sweeper_1D.o: control.o
sweeper_1D.o: material.o
sweeper_1D.o: mesh.o
sweeper_1D.o: state.o
sweeper_2D.o: angle.o
sweeper_2D.o: control.o
sweeper_2D.o: material.o
sweeper_2D.o: mesh.o
sweeper_2D.o: state.o
