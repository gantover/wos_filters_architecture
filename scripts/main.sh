source ~/tools/Xilinx/Vivado/2024.2/settings64.sh

# the objective will be to generate a design for different b,c,K and export reports for those

export B=8 C=8 MR=8 K=7

PROJECT_FILE=../vivado/wos/wos.xpr
RUN_NAME=synth_1
JOBS=16
UNIT_NAME=arrayUnit

for K in $(seq 2 1 16); do # start step end
    export K
    echo "Running Vivado synthesis for B=$B C=$C MR=$MR K=$K"
    sbt "runMain wos.array.ArrayContainer" 
    cd temp
    vivado -mode tcl <<EOF
    open_project $PROJECT_FILE
    reset_run $RUN_NAME
    launch_runs $RUN_NAME -jobs $JOBS
    wait_on_run $RUN_NAME
    open_run synth_1 -name synth_1
    report_utilization -hierarchical -cells [get_cells $UNIT_NAME] -file ../reports/u_${UNIT_NAME}_b${B}_c${C}_mr${MR}_k${K}_.csv 
    exit
EOF
    cd ..
done
# open_project $PROJECT_FILE
# open_run synth_1 -name synth_1
# report_utilization -hierarchical -cells [get_cells $UNIT_NAME] -file ../reports/u_${UNIT_NAME}_b${B}_c${C}_mr${MR}_k${K}_.csv 
# exit
# EOF