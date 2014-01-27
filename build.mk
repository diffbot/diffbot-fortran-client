#!/bin/bash

FC=gfortran

clean () {
    rm -f *.mod *.o
}

# FORTRAN 90
clean

for i in 1 2; do
    $FC -o example${i}_f90 example$i.f90
done

# FORTRAN 77
clean

MODS="fson_string_m.f95 fson_value_m.f95 fson_path_m.f95 fson.f95 fdiffbot.f90"
for f in $MODS; do
    $FC -c modules/$f
done

OBJS="fson_string_m.o fson_value_m.o fson_path_m.o fson.o fdiffbot.o"
for i in 1 2; do
    $FC -c example$i.f
    $FC -o example${i}_f example$i.o $OBJS
done
