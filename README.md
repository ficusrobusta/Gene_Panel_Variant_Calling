Gene_Panel_Variant_Calling

```
Gene panel variant calling scripts, commands and instructions. This pipeline was designed for the following:
- Bone marrow failure gene panel
- Multiplex 150bp dual indexed libraries 
- Miseq sequencing data

Go to BaseSpace, open the project and click on the SAMPLES tab.
Select all the fastq folders and click the Download Samples button (top right). Save them into a folder on the NAS. For this to work the first time, you need to install the Illumina Download app. 

Open up the Apocrita account and empty the following directories (having checked that all data required has been copied across to the NAS: 
~/Blizard-BoneMarrowFailure/bam/b37/gene_panel/
~/Blizard-BoneMarrowFailure/csv/b37/gene_panel/
~/Blizard-BoneMarrowFailure/vcf/b37/gene_panel/
~/Blizard-BoneMarrowFailure/fastq/gene_panel/

Using FileZilla, transfer the fastq files from the NAS to the ~/Blizard-BoneMarrowFailure/fastq/gene_panel directory
Get each fastq file out of its folder: mv */*gz .

Delete the empty directories: rmdir

Navigate back to the working directory
Remove any existing .sh.o and .sh.e files and the samples.txt file from previous runs.

For these gene_panel files, the names should have the following structure: 
${PROJECT}-*_S*_L*_R*_*.fastq.gz where the project name is defined by, for example, GC-JA-8284- which is the prefix to every sample followed by *_S*_L*_R*_*.fastq.gz

You can then create a samples.txt file, containing three columns: sample, fastq 1 , fastq 2,for the specific project using the following command:
bash $SCRIPTS/gene_panel/make_sample_list.sh GC-JA-8284 > samples.txt

If the file names do not have the project prefix, you can fix as follows:
for x in *fastq.gz; do mv ${x} GC-JA-8284-${x}; done

The samples.txt file should appear in the working directory. To check it's there and to see it's contents:
cat samples.txt

For each sample, this should list the following details:

GC-JA-7789-4423 /data2/Blizard-BoneMarrowFailure/fastq/gene_panel//GC-JA-7789-4423_S8_L001_R1_001.fastq.gz /data2/Blizard-BoneMarrowFailure/fastq/gene_panel//GC-JA-7789-4423_S8_L001_R2_001.fastq.gz


Now submit gene_panel.sh on each sample to be run in parallel on the cluster:
while read -r x; do qsub $SCRIPTS/apocrita_NGS/gene_panel/gene_panel.sh $x; done < samples.txt

.bam, .vcf and .csv files should start to appear in the relevant directories

In order to merge the files to produce hg19_multianno_merged.csv, run the following command in the directory:cd ~/Blizard-BoneMarrowFailure/csv/b37/gene_panel/
Rscript $SCRIPTS/apocrita_NGS/gene_panel/merge_multianno.R

To track your job status:
qstat

To kill a specific job:
qdel 760053

```









