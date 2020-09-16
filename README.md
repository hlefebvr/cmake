# CMAKE utils

## How to use

Inside your CLion project:
```shell script
ln -s <THIS_REPO_FOLDER> cmake
```

then inside your CMakeLists.txt:
```cmake
add_subdirectory(cmake)
target_link_cplex(my_target) # for linking with cplex
target_link_mosek(my_target) # for linking with cplex
target_link_openmp(my_target) # for linking with openmp
```