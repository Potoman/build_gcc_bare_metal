# git clone --depth 1 --branch releases/gcc-13.1.0 https://github.com/gcc-mirror/gcc.git
# tar binutils-2.40.tar.gz

# cd gcc
# ./contrib/download_prerequisites
# On WSL :
# sudo apt install flex bison textinfo
# On Msys2 :
# pacman -S texinfo
# pacman -S diffutils

set -x -e

# wget http://ftpmirror.gnu.org/gmp/gmp-6.2.1.tar.bz2
# wget ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2
# wget http://ftpmirror.gnu.org/mpc/mpc-1.2.1.tar.gz
# wget http://ftpmirror.gnu.org/mpfr/mpfr-4.1.0.tar.bz2
# wget http://ftpmirror.gnu.org/binutils/binutils-2.40.tar.gz

rm install_dir -rf
rm build_gcc -rf
rm gmp-6.2.1 -rf
rm isl-0.24 -rf
rm mpfr-4.1.0 -rf
rm mpc-1.2.1 -rf
rm binutils-2.40 -rf

mkdir install_dir -p

export INSTALL_DIR=/home/potoman/gcc/script/install_dir

# GMP :
tar xf gmp-6.2.1.tar.bz2
cd gmp-6.2.1
mkdir build
cd build
../configure --prefix=${INSTALL_DIR}
make -j 16
make install
cd ../..

# ISL :
tar xf isl-0.24.tar.bz2
cd isl-0.24
mkdir build
cd build
../configure --prefix=${INSTALL_DIR}
make -j 16
make install
cd ../..

# MPFR :
tar xf mpfr-4.1.0.tar.bz2 
cd mpfr-4.1.0
mkdir build
cd build
../configure --prefix=${INSTALL_DIR}
make -j 16
make install
cd ../..

# MPC :
tar xf mpc-1.2.1.tar.gz
cd mpc-1.2.1
mkdir build
cd build
../configure --prefix=${INSTALL_DIR} --with-mpfr=${INSTALL_DIR}
# For Msys2 :
# ../configure --prefix=${INSTALL_DIR} --with-mpfr=${INSTALL_DIR} --enable-static --disable-shared
make -j 16
make install
cd ../..

# BINUTILS :
tar xf binutils-2.40.tar.gz
cd binutils-2.40
mkdir build
cd build
../configure --prefix=${INSTALL_DIR} --target=aarch64-none-elf --disable-mutilib
make -j 16
make install
cd ../..

# GCC :
export PATH=${INSTALL_DIR}/bin:$PATH
LD_LIBRARY_PATH=${INSTALL_DIR}/lib
mkdir build_gcc
cd build_gcc
../gcc/configure --prefix=${INSTALL_DIR} --enable-languages=c,c++ --disable-multilib --target=aarch64-none-elf --with-isl=${INSTALL_DIR} --with-gmp=${INSTALL_DIR} --with-mpc=${INSTALL_DIR} --with-mpfr=${INSTALL_DIR}
make all-gcc -j 16
make install-gcc
cd ..

