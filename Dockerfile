FROM ubuntu:jammy

RUN sed -i -e 's/archive.ubuntu.com/mirrors.ustc.edu.cn/' -e 's/security.ubuntu.com/mirrors.ustc.edu.cn/' /etc/apt/sources.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      sudo \
      wget \
      gpg \
      openssl \
      ca-certificates \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

# download the key to system keyring
RUN wget -O - https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
    | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
    | sudo tee /etc/apt/sources.list.d/oneAPI.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-2021.3.0 \
      intel-oneapi-compiler-fortran-2021.3.0 \
      intel-oneapi-mpi-devel-2021.3.0 \
      intel-oneapi-mpi-2021.3.0 \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

ENV I_MPI_ROOT=/opt/intel/oneapi/mpi/latest
ENV CLASSPATH=${I_MPI_ROOT}/lib/mpi.jar:$CLASSPATH
ENV PATH=${I_MPI_ROOT}/bin:$PATH
ENV LD_LIBRARY_PATH=${I_MPI_ROOT}/lib/release:${I_MPI_ROOT}/lib:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=${I_MPI_ROOT}/lib/release:${I_MPI_ROOT}/lib:$LIBRARY_PATH
ENV CPATH=${I_MPI_ROOT}/include:$CPATH
ENV MANPATH=${I_MPI_ROOT}/man:$MANPATH
ENV FI_PROVIDER_PATH=${I_MPI_ROOT}/libfabric/lib/prov:/usr/lib64/libfabric:$FI_PROVIDER_PATH
ENV PATH=${I_MPI_ROOT}/libfabric/bin:$PATH
ENV LD_LIBRARY_PATH=${I_MPI_ROOT}/libfabric/lib:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=${I_MPI_ROOT}/libfabric/lib:$LIBRARY_PATH
#
ENV I_COMPILER_ROOT=/opt/intel/oneapi/compiler/latest
ENV LIBRARY_PATH=${I_COMPILER_ROOT}/linux/lib:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=${I_COMPILER_ROOT}/linux/compiler/lib/intel64_lin:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=${I_COMPILER_ROOT}/linux/lib/x64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=${I_COMPILER_ROOT}/linux/lib:$LD_LIBRARY_PATH
ENV DIAGUTIL_PATH=${I_COMPILER_ROOT}/sys_check/sys_check.sh:$DIAGUTIL_PATH
# Compiler ENV VARS
ENV CMPLR_ROOT=/opt/intel/oneapi/compiler/2023.0.0
ENV TBBROOT=/opt/intel/oneapi/tbb/2021.10.0
ENV CPATH=/opt/intel/oneapi/tbb/2021.10.0/include:$CPATH
ENV LIBRARY_PATH=/opt/intel/oneapi/tbb/2021.10.0/lib/intel64/gcc4.8:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/tbb/2021.10.0/lib/intel64/gcc4.8:$LD_LIBRARY_PATH
ENV CMAKE_PREFIX_PATH=/opt/intel/oneapi/tbb/2021.10.0:$CMAKE_PREFIX_PATH
ENV OCL_ICD_FILENAMES=$OCL_ICD_FILENAMES:/opt/intel/oneapi/compiler/2023.0.0/linux/lib/x64/libintelocl.so
ENV PATH=/opt/intel/oneapi/compiler/2023.0.0/linux/bin:$PATH
ENV PATH=/opt/intel/oneapi/compiler/2023.0.0/linux/bin/intel64:$PATH
ENV MANPATH=$MANPATH:/opt/intel/oneapi/compiler/2023.0.0/documentation/en/man/common
ENV CMAKE_PREFIX_PATH=/opt/intel/oneapi/compiler/2023.0.0/linux/IntelDPCPP:$CMAKE_PREFIX_PATH
ENV NLSPATH=/opt/intel/oneapi/compiler/2023.0.0/linux/compiler/lib/intel64_lin/locale/%l_%t/%N:$NLSPATH
ENV DIAGUTIL_PATH=/opt/intel/oneapi/compiler/2023.0.0/sys_check/sys_check.sh:$DIAGUTIL_PATH
