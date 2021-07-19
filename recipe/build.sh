export CFLAGS="-Wall -g -m64 -pipe -O2  -fPIC ${CFLAGS}"
export CXXLAGS="${CFLAGS} ${CXXLAGS}"
export CPPFLAGS="-I${PREFIX}/include ${CPPFLAGS}"
export LDFLAGS="-L${PREFIX}/lib ${LDFLAGS}"
export LDSHARED="$CC -shared -pthread" 

if [ `uname` == Linux ]; then
    MAKEFILE=libdrs_Makefile.Linux.gfortran
    echo "Linux  "${PREFIX}
else
    export FC=gfortran
    MAKEFILE=libdrs_Makefile.Mac.gfortran
    echo "Mac  "${PREFIX}
fi
cd lib
sed "s#@cdat_EXTERNALS@#${PREFIX}#g;" ${MAKEFILE}.in > ${MAKEFILE}
if [[ "$target_platform" == "osx-arm64" ]]; then
  # -lquadmath doesn't exist and isn't needed on OSX ARM
  sed -i.bak "s#-lquadmath##g" ${MAKEFILE}
fi
make  -f ${MAKEFILE}
make  -f ${MAKEFILE} install

