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
      intel-oneapi-mkl-devel-2021.3.0 \
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
# MKL environment variables
ENV MKLROOT=/opt/intel/oneapi/mkl/latest
ENV LD_LIBRARY_PATH=${MKLROOT}/lib/intel64:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=${MKLROOT}/lib/intel64:$LIBRARY_PATH
ENV CPATH=${MKLROOT}/include:$CPATH
ENV PKG_CONFIG_PATH=${MKLROOT}/lib/pkgconfig:$PKG_CONFIG_PATH
ENV NLSPATH=${MKLROOT}/lib/intel64/locale/en_US/mkl_msg.cat:$NLSPATH
