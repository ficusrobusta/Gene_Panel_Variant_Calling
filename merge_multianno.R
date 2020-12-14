library(data.table)

suffix <- '.hg19_multianno.csv'

print('Reading...')
multi_anno <- list()
#for (f in list.files(path='~/Blizard-BoneMarrowFailure/csv/b37/gene_panel/DG5.1/' , pattern=sprintf('.*%s',suffix))) {
for (f in list.files(path='.' , pattern=sprintf('.*%s',suffix))) {
  d <- as.data.frame(fread(f))
  print(sample <- gsub(suffix,'',f))
  print(dim(d))
  if (nrow(d)==0) {
      cat('WARN: skipping empty file',f,'\n')
      next
  }
  d[,'INFO'] <- sapply(strsplit(d$Otherinfo,'\t'),'[[',9)
  d[,sprintf('Geno.%s',sample)] <- sapply(strsplit(d$Otherinfo,'\t'),'[[',10)
  d[,sprintf('Quality.%s',sample)] <- as.numeric(sapply(strsplit(d$Otherinfo,'\t'),'[[',6))
  d <- d[,-which('Otherinfo'==colnames(d))]
  multi_anno[[sample]] <- d
}

print('Merging...')
merged.multi_anno <- multi_anno[[1]]
for (i in 2:length(multi_anno)) {
print(names(multi_anno)[[i]])
merged.multi_anno <- merge(merged.multi_anno, multi_anno[[i]], all=TRUE, by=c("Chr", "Start", "End", "Ref", "Alt", "Func.$
}

#print(dim(merged.multi_anno[,grep('Quality',colnames(merged.multi_anno))]))

merged.multi_anno$MEAN_QUALITY <- rowMeans(merged.multi_anno[,grep('Quality',colnames(merged.multi_anno))],na.rm=TRUE)

merged.multi_anno <- merged.multi_anno[,-grep('Quality',colnames(merged.multi_anno))]

print(dim(merged.multi_anno))
write.csv(file='hg19_multianno_merged.csv',merged.multi_anno, row.names=FALSE)
