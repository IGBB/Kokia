#Kokia-specific GENESPACE run:
#Rscript:
#load lib:
library(GENESPACE)
library(data.table)
#Rscript
#Paths:
wd = "Kokia_specif_OF"
path2mcscanx = "/opt/MCScanX/"

#initialise GENESPACE:
#builds directory structure
gpar <- init_genespace( wd=wd, path2mcscanx = "/opt/MCScanX/")

out <- run_genespace(gpar)
save.image("genespace.image")

#get pangenomes with a ref:
load('Kokia_specif_OF/results/gsParams.rda',verbose = TRUE)
Kokau_syn = syntenic_pangenes(gsParam = gsParam, refGenome = "Kokau", maxPlacePerChr = 2, minPropInterp2keep = 0.75)
fwrite(file = "Kokau_syn.txt", Kokau_syn, row.names = F, quote = F, sep = '\t')
Kokau_pan = query_pangenes(gsParam = gsParam, refGenome = "Kokau", showArrayMem=F, showNSOrtho=F)
fwrite(file = "Kokau_pan.txt", Kokau_pan, row.names = F, quote = F, sep = '\t')

#gene order graph:
ripd <- plot_riparian(gsParam = gsParam, genomeIDs = c("Kocoo", "Kodry", "Kokau"), refGenome = "Kokau", useOrder = FALSE, useRegions = FALSE, reorderBySynteny = TRUE, syntenyWeight = 1, pdfFile = "Kokau_def.pdf")

#custom colour & background:
ggthemes <- ggplot2::theme(panel.background = ggplot2::element_rect(fill = "white"))
customPal <- colorRampPalette(c("darkorange", "skyblue", "darkblue", "purple", "darkred", "salmon"))
ripDat <- plot_riparian(gsParam = gsParam, palette = customPal, braidAlpha = .75, chrFill = "lightgrey", addThemes = ggthemes, refGenome = "Kokau", , pdfFile = "Kokau_color.pdf")
