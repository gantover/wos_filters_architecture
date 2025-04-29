source ~/tools/Xilinx/Vivado/2024.2/settings64.sh

# the objective will be to generate a design for different b,c,K and export reports for those

# export B=3 C=8 MR=8 K=5
# export B=8 C=8 MR=8 K=5
# export B=5 C=4 MR=4 K=5
export B=5 C=4 MR=4 K=6

RUN_NAME=synth_1
JOBS=16

UNIT_NAME=arrayUnit
FOLDER=array
CONTAINER=ArrayContainer
PROJECT_FILE=../vivado/wos/wos.xpr
EXPORT_NAME=arrayUnit

# UNIT_NAME=stack_filters_unit
# FOLDER=stack_filters
# CONTAINER=StackFiltersContainer
# PROJECT_FILE=../vivado/stack_filters/stack_filters.xpr
# EXPORT_NAME=stackFiltersUnit

# for K in $(seq 2 1 13); do # start step end
for C in $(seq 2 1 10); do # start step end
# for C in $(seq 10 1 12); do # start step end
    export C
    export MR=$C

# for B in $(seq 1 1 6); do # start step end
    # export B
    echo "Running Vivado synthesis for B=$B C=$C MR=$MR K=$K"
    sbt "runMain wos.$FOLDER.$CONTAINER" 
    cd temp
    vivado -mode tcl <<EOF
    open_project $PROJECT_FILE
    add_files ../generated/$CONTAINER.v
    update_compile_order -fileset sources_1
    reset_run $RUN_NAME
    launch_runs $RUN_NAME -jobs $JOBS
    wait_on_run $RUN_NAME
    open_run synth_1 -name synth_1
    report_utilization -hierarchical -cells [get_cells $UNIT_NAME] -file ../reports/u_${EXPORT_NAME}_b${B}_c${C}_mr${MR}_k${K}_.csv 
    exit
EOF
    cd ..
done

# report_timing -cells [get_cells $UNIT_NAME] -file ../timing_reports/u_${EXPORT_NAME}_b${B}_c${C}_mr${MR}_k${K}_.csv 
# open_run synth_1 -name synth_1