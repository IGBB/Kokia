#4 species GENESPACE run:
#Rscript:
#load lib:
library(GENESPACE)
library(data.table)
library(ggplot2)
#Rscript
#Paths:
wd = "kiki_stuff"
path2mcscanx = "/opt/MCScanX/"

#initialise GENESPACE:
#builds directory structure
gpar <- init_genespace( wd=wd, path2mcscanx = "/opt/MCScanX/")

out <- run_genespace(gpar)
save.image("genespace.image")

#get pangenomes with a ref:
load('kiki_stuff/results/gsParams.rda',verbose = TRUE)
Gokir_syn = syntenic_pangenes(gsParam = gsParam, refGenome = "Gokir", maxPlacePerChr = 2, minPropInterp2keep = 0.75)
fwrite(file = "Gokir_syn.txt", Gokir_syn, row.names = F, quote = F, sep = '\t')
Gokir_pan = query_pangenes(gsParam = gsParam, refGenome = "Gokir", showArrayMem=F, showNSOrtho=F)
fwrite(file = "Gokir_pan.txt", Gokir_pan, row.names = F, quote = F, sep = '\t')

#gene order graph:
ripd <- plot_riparian(gsParam = gsParam, genomeIDs = c("Gokir", "Kocoo", "Kodry", "Kokau"), refGenome = "Gokir", useOrder = FALSE, useRegions = FALSE, reorderBySynteny = TRUE, syntenyWeight = 1, pdfFile = "Gokir_def.pdf")

#custom colour & background:
ggthemes <- ggplot2::theme(panel.background = ggplot2::element_rect(fill = "white"))
customPal <- colorRampPalette(c("darkorange", "skyblue", "darkblue", "purple", "darkred", "salmon"))
ripDat <- plot_riparian(gsParam = gsParam, palette = customPal, braidAlpha = .75, chrFill = "lightgrey", addThemes = ggthemes, refGenome = "Gokir", , pdfFile = "Gokir_color.pdf")

#reformatted graph:
invchr <- data.frame(genome=rep("Kodry", 7),
                     chr=sprintf("Kd_%02d", c(3,6:11)))

## plot_riparian(gsParam = gsParam,
##               invertTheseChrs=invchr,
##               genomeIDs = c("Gokir", "Kokau", "Kodry", "Kocoo"),
##               refGenome = "Gokir",
##               useOrder = FALSE,
##               useRegions = FALSE,
##               reorderBySynteny = TRUE,
##               syntenyWeight = 1,
##               pdfFile = "Gokir_def.pdf")

##custom colour & background:
ggthemes <- theme(panel.background = element_rect(fill = "white"))
customPal <- colorRampPalette(c("darkorange", "skyblue", "darkblue",
                                "purple", "darkred", "salmon"))
plot_riparian(gsParam = gsParam,
              invertTheseChrs=invchr,
              palette = customPal,
              braidAlpha = .75,
              chrFill = "lightgrey",
              addThemes = ggthemes,
              customRefChrOrder = c("KI_01", "KI_2_4",
                                    sprintf("KI_%02d", c(3,5:13))),
              genomeIDs = c("Gokir", "Kokau", "Kodry", "Kocoo"),
              refGenome = "Gokir",
              pdfFile = "Gokir_reorg.pdf")
