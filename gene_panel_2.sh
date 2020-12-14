#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -pe smp 2
#$ -l h_rt=1:0:0
#$ -l h_vmem=32G

set -x

ncores=2

module load samtools
module load bwa

SAMPLE=$1


FASTQ_DIR=/data2/Blizard-BoneMarrowFailure/fastq/gene_panel/

GENOME_AND_JARS_DIR=/data2/Blizard-BoneMarrowFailure/Genome_and_jars/
REFERENCE=${GENOME_AND_JARS_DIR}/hg19.fa
ANNOVAR_DIR=/data2/Blizard-BoneMarrowFailure/annovar/
BAM_DIR=/data2/Blizard-BoneMarrowFailure/bam/b37/gene_panel/
VCF_DIR=/data2/Blizard-BoneMarrowFailure/vcf/b37/gene_panel/
CSV_DIR=/data2/Blizard-BoneMarrowFailure/csv/b37/gene_panel/


for lane in L001 L002 L003 L004
do
f1=`find ${FASTQ_DIR} -name "*${SAMPLE}*${lane}*R1*fastq.gz"`
f2=`find ${FASTQ_DIR} -name "*${SAMPLE}*${lane}*R2*fastq.gz"`
bwa mem -t $ncores $REFERENCE $f1 $f2 | samtools view -bS - > ${BAM_DIR}/${SAMPLE}_${lane}.bam
done

samtools merge --threads ${ncores} ${BAM_DIR}/${SAMPLE}.bam ${BAM_DIR}/${SAMPLE}*L*.bam

# sort file
samtools sort --threads $ncores ${BAM_DIR}/${SAMPLE}.bam -o ${BAM_DIR}/${SAMPLE}.sorted.bam

samtools index ${BAM_DIR}/${SAMPLE}.sorted.bam

java -jar ${GENOME_AND_JARS_DIR}/AddOrReplaceReadGroups.jar I=${BAM_DIR}/${SAMPLE}.sorted.bam O=${BAM_DIR}/${SAMPLE}.grou$

java -jar ${GENOME_AND_JARS_DIR}/ReorderSam.jar I=${BAM_DIR}/${SAMPLE}.grouped.bam O=${BAM_DIR}/${SAMPLE}.kar.bam REFEREN$

samtools index ${BAM_DIR}/${SAMPLE}.kar.bam

java -jar ${GENOME_AND_JARS_DIR}/GenomeAnalysisTK.jar -T HaplotypeCaller -R $REFERENCE -I ${BAM_DIR}/${SAMPLE}.kar.bam -s$

perl $ANNOVAR_DIR/convert2annovar.pl -format vcf4 ${VCF_DIR}/${SAMPLE}.raw.vcf.gz -includeinfo > ${CSV_DIR}/${SAMPLE}.avi$

perl $ANNOVAR_DIR/table_annovar.pl ${CSV_DIR}/${SAMPLE}.avinput $ANNOVAR_DIR/humandb/ -buildver hg19 --otherinfo -out ${C$


