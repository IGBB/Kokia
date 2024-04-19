#Make CNV table:
library(data.table)
library(dplyr)

# Read data from file
a <- fread("list.pan.red")

# Filter and manipulate data
b <- a %>%
  filter(!(Gokir == Kocoo & Gokir == Kodry & Gokir == Kokau)) %>%
  mutate(pattern = paste(Gokir, Kocoo, Kodry, Kokau, sep = "|"))
table(b$pattern)
# Create table of counts
table_result <- table(b$pattern)

# Convert table to data frame
table_df <- as.data.frame(table_result)

# Save the data frame to a file (e.g., TSV with tab separator)
write.table(table_df, "output_table.tsv", sep = "\t", col.names = FALSE, row.names = FALSE)