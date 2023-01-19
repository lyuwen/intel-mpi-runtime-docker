FROM ubuntu:focal

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
      intel-oneapi-mpi-2021.7.1 \
      intel-oneapi-compiler-fortran-runtime-2022.2.1 \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

ENV I_MPI_ROOT=/opt/intel/oneapi/mpi/2021.7.1
ENV CLASSPATH=/opt/intel/oneapi/mpi/2021.7.1/lib/mpi.jar:$CLASSPATH
ENV PATH=/opt/intel/oneapi/mpi/2021.7.1/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/mpi/2021.7.1/lib/release:/opt/intel/oneapi/mpi/2021.7.1/lib:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=/opt/intel/oneapi/mpi/2021.7.1/lib/release:/opt/intel/oneapi/mpi/2021.7.1/lib:$LIBRARY_PATH
ENV CPATH=/opt/intel/oneapi/mpi/2021.7.1/include:$CPATH
ENV MANPATH=/opt/intel/oneapi/mpi/2021.7.1/man:$MANPATH
ENV FI_PROVIDER_PATH=/opt/intel/oneapi/mpi/2021.7.1/libfabric/lib/prov:/usr/lib64/libfabric:$FI_PROVIDER_PATH
ENV PATH=/opt/intel/oneapi/mpi/2021.7.1/libfabric/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/mpi/2021.7.1/libfabric/lib:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=/opt/intel/oneapi/mpi/2021.7.1/libfabric/lib:$LIBRARY_PATH
ENV LIBRARY_PATH=/opt/intel/oneapi/compiler/2022.2.1/linux/lib:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/2022.2.1/linux/compiler/lib/intel64_lin:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/2022.2.1/linux/lib/x64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/2022.2.1/linux/lib:$LD_LIBRARY_PATH
ENV DIAGUTIL_PATH=/opt/intel/oneapi/compiler/2022.2.1/sys_check/sys_check.sh:$DIAGUTIL_PATH


