#Redraw tree in R with piechart.R:
library(phangorn)
library(ggtree)
library(treeio)
library(ggplot2)
library(ape)

tree2 <- read.iqtree("sptree.tre")
tree2

p <- ggtree(tree2, linewidth=1, color = "grey") + #tree branch options
  geom_treescale(linesize = 1, fontsize = 4, offset=-0.01, x=0.1, y=0.8) + #x & y position scale bare
  geom_tiplab(aes(label=label), show.legend = F, hjust=-.2, fontface = 4, size = 4) + 
  geom_rootedge(rootedge = 0.1, linewidth= 1, color = "grey") + #root option
  xlim_tree(0.2)

p
p1 <- as.phylo(p)

k <- read.table("phypart.node.key", header=F, row.names=NULL, sep=" ", na.strings = c("", "NA"), stringsAsFactors=FALSE)

colnames(k) <- c("NodeP", "Tips")
NodeP <- rep(0, length(k$NodeP))
k2 <- as.data.frame(NodeP)
k2$NodeT <- rep(0, length(k2$NodeP))

toMatch <- c("A.*", "B.*", "C.*", "D.*", "E.*", "F.*", "G.*", "K.*" , "k.*")
#grep(paste(toMatch,collapse="|"),  tips_vec[[1]], value=TRUE)

for (x in 1:length(k[,1])) {
  k2$NodeP[x] <-  k[x,1]
  tips <- gsub("\\)|\\(", ",", k[x,2])
  tips_vec <- strsplit(tips, ",")
  tips_vec2 <- grep(paste(toMatch,collapse="|"),  tips_vec[[1]], value=TRUE)
  k2$NodeT[x] <- mrca.phylo(p1, tips_vec2)
}

lines <- readLines("phyparts_pies.csv")
tail(lines)  # Display the last few lines of the file

phypart_pie <- read.csv(file = "phyparts_pies.csv", sep = ",", header = T)
str(data)  # View structure of the data frame
head(data) # View the first few rows of data
new_pie <- cbind(k2, phypart_pie)[c(2,4:7)]
names(new_pie)[names(new_pie) == 'NodeT'] <- 'node'

color_list <- list(
  adj_concord = "#009E73",
  adj_most_conflict = "#D55E00",
  other_conflict = "#56B4E9",
  the_rest = "#999999"
)

pies <- nodepie(new_pie, cols = 2:5, alpha = 0.75,
                color = color_list)

p2 <- p  + geom_inset(pies, width = 0.2, height = 0.2) 
p2

pdf("piechart.pdf", width = 15, height = 10) #height for larger trees
p2
dev.off()
