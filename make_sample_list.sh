PROJECT=$1
FASTQ_DIR=/data2/Blizard-BoneMarrowFailure/fastq/gene_panel/

for s in ${FASTQ_DIR}/${PROJECT}-*_S*_L*_R*_*.fastq.gz
do
    s=$(basename $s | sed 's/_S.*_L.*_R.*_.*.fastq.gz//')
    echo $s ${FASTQ_DIR}/${s}_S*_L*_R1_*.fastq.gz ${FASTQ_DIR}/${s}_S*_L*_R2_*.fastq.gz
done | sort -u
