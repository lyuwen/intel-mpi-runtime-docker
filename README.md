# Docker image for Intel MPI runtime

A minimum image for running programs compiled with Intel MPI. Only the compiler runtime and MPI dynamic libraries and scheduler programs (e.g. `mpirun`, `mpiexec`, etc.) are installed to keep the base image as small as possible.

It’s intended as the base image of the final packaging stage of a docker build procedure and compiled binaries can be copied from the builder image (with `intel/oneapi-hpckit` as the base image).

An example can be found in thé `Intel` branch of [lyuwen/qe-docker](https://github.com/lyuwen/qe-docker/tree/intel) repository. 