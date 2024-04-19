#dNdS plotting:
#load slurm modules:
#module load r-tidyverse/1.3.2-py310-r42-ftebeob	r-gridextra/2.3-py310-r42-kvugc7l
library(tidyverse)
library(gridExtra)
library(grid)
library(dplyr)

# Read data from files
dd <- read.table("dnds.list", header = TRUE)
dn <- read.table("dn.list", header = TRUE)
ds <- read.table("ds.list", header = TRUE)

# Pivot the data frames after converting data types
ggdn <- pivot_longer(dn,cols= -OG,names_to="comparison") %>% mutate(type="dn")  %>% mutate(value=as.numeric(value)) %>% na.omit()
ggds <- pivot_longer(ds,cols= -OG,names_to="comparison") %>% mutate(type="ds") %>% mutate(value=as.numeric(value)) %>% na.omit()
ggdd <- pivot_longer(dd,cols= -OG,names_to="comparison") %>% mutate(type="dd")  %>% mutate(value=as.numeric(value)) %>% na.omit()

# Create density plots
myds <- ggplot(ggds, aes(x = value)) +
  geom_density(aes(color = comparison, linetype = comparison), adjust = 3, linewidth = 3) +
  scale_colour_brewer(palette = "Set1") +
  scale_linetype_manual(values = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")) +
  xlim(0, 0.025) +
  ggtitle(NULL) +
  theme(axis.text = element_text(size = 20),
        legend.title = element_blank(),
        legend.text = element_text(size = 20)) +
  labs(x = NULL, y = NULL)
mydn <- ggplot(ggdn, aes(x = value)) +
  geom_density(aes(color = comparison, linetype = comparison), adjust = 3, linewidth = 3) +
  scale_colour_brewer(palette = "Set1") +
  scale_linetype_manual(values = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")) +
  xlim(0, 0.025) +
  ggtitle(NULL) +
  theme(axis.text = element_text(size = 20),
        legend.title = element_blank(),
        legend.text = element_text(size = 20)) +
  labs(x = NULL, y = NULL)
mydd <- ggplot(ggdd, aes(x = value)) +
  geom_density(aes(color = comparison, linetype = comparison), adjust = 3, linewidth = 3) +
  scale_colour_brewer(palette = "Set1") +
  scale_linetype_manual(values = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")) +
  xlim(0, 0.025) +
  ggtitle(NULL) +
  theme(axis.text = element_text(size = 20),
        legend.title = element_blank(),
        legend.text = element_text(size = 20)) +
  labs(x = NULL, y = NULL)

# Combine plots
combined <- gridExtra::grid.arrange(mydd, mydn, myds, ncol = 3)

ggsave("ThreeDplots.jpg", plot=combined, width=30, height=6, units="in")


only2 <- bind_rows(ggds,ggdn)

# Define colors for each type
type_colors <- c("dn" = "red", "ds" = "green")
options(scipen = 999) # removes scientific notation


# Your ggplot code
dn.ds <- ggplot(only2, aes(x = comparison, y = value, fill = type)) +
  geom_boxplot(position = position_dodge(1), outlier.shape = NA, color = "grey", size = 1.5) +
  scale_x_discrete(labels = c("Gk - Kc","Gk - Kd","Gk - Kk","Kc - Kd","Kc - Kk","Kd - Kk")) +
  theme(legend.position = c(0.95, 0.9),
        legend.title = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(color = "black", size = 20),
        legend.text = element_text(size = 20),  # Adjust legend text size
        legend.key.size = unit(3, "lines")) +  # Adjust legend box size
  theme(axis.text = element_text(size = 20)) +  # Separate line for additional theme
  ylim(0, 0.03) +
  stat_summary(fun = median,
               geom = "point",
               size = 1,
               color = "white",
               position = position_dodge(1)) +
  scale_fill_manual(values = type_colors) +
  stat_summary(fun = median,
               geom = "text",
               aes(label = paste("Median\n", round(after_stat(y), 4))),
               vjust = -1.5,
               position = position_dodge(1),
               color = "black",
               size = 8)

# Insert the plot into the main plot
insetplot <- myds +
  annotation_custom(ggplotGrob(dn.ds), xmin = 0.005, xmax = 0.025, ymin = 150, ymax = 200) +
  theme(legend.text = element_text(size = 40),  # Adjust legend text size for the combined plot
        axis.text = element_text(size = 40))  # Adjust axis text size for the combined plot

# Save the plot
ggsave("Density-boxplot.jpg", plot = insetplot, width = 30, height = 25, units = "in", device = "jpeg")

