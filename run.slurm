#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --account=courses0100
#SBATCH --reservation=CurtinHPCcourse2025
#SBATCH --job-name=gol-openmp
#SBATCH --time=00:20:00
#SBATCH --export=NONE


module purge
module load craype-x86-milan
module load PrgEnv-gnu/8.3.3

# To change the number of threads, alter the cpus-per-task directive
# for SBATCH and the variable OMP_NUM_THREADS
export OMP_NUM_THREADS=64

# update these as necessary
exe=
# if there are arguments then add this here
args=


#Compile
make clean
#srun -N -n 1 -c ${OMP_NUM_THREADS} ${exe} ${args} 
make COMPILERTYPE=CRAY cpu_openmp_loop_cc

#Run
srun --export=all -u -n 1 ./bin/02_gol_cpu_openmp_loop 10000 1000 50

#srun --export=all -u -n 1 ./bin/01_gol_cpu_serial 10000 10000 10

#report
echo "Generating profiling report"
gprof -lbp ./bin/02_gol_cpu_openmp_loop gmon.out
