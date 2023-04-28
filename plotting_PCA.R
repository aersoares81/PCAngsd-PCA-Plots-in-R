library(RcppCNPy)
library(ggfortify)
library(tidyverse)
library(ggrepel)
#library(RColorBrewer)

# Make sure you're in the right place
# Don't forget to edit this!
basedir <- "~/Your/path/here/"

# Load the output from PCAangsd
cov_quad <- as.matrix(read.table(paste0(basedir, "output.cov"), header = F))

# Now it will perform the PCA
run.pca <- eigen(cov_quad)

# Here is the information from your population: location and name of the samples
samplemat <- as.matrix(read.table(paste0(basedir, "pop.info"), header = F))
sampleheaders <- c("location","sample_id")
colnames(samplemat) <- sampleheaders

# Extract the eigenvectors and turn them into a dataframe for plotting
eigenvectors = run.pca$vectors #extract eigenvectors 
# Combining the information from the populations/samples
pca.vectors = as_tibble(cbind(samplemat, data.frame(eigenvectors)))
# You can edit this too
legend_title <- "Location"

# This will create a "simple" PCA plot. It will have a legend with the location of the samples next to it.
# Adjust the title, of course.
# Please notice that I commented the RColorBrewer.
# Uncomment and use the palette your like the most if you want to change the colors.
# Don't forget to uncomment the library in in the beginning of the script too.
simple.pca = ggplot(data = pca.vectors, aes(x=X1, y=X2, colour = location, label = sample_id)) + 
  geom_point() + labs(title="Title goes here", x="PC1",y="PC2") + 
  # I'm making the title in italics because it's usually the name of a species
  theme(plot.title = element_text(face = "italic")) #+ scale_color_brewer(palette="Set1")
plot(simple.pca)

# This will create another PCA plot.
# In this version, every point (or as many as possible) will have the sample ID assigned to it.
# It's neat if you want to see where exactly each sample is placed.
labeled.pca = ggplot(data = pca.vectors, aes(x=X1, y=X2, colour = location, label = sample_id)) + 
  geom_point() + labs(title="Title goes here", x="PC1",y="PC2") + 
  # I'm making the title in italics because it's usually the name of a species
  theme(plot.title = element_text(face = "italic")) + 
  geom_label_repel(show.legend = FALSE) #+ scale_color_brewer(palette="Set1")
plot(labeled.pca)

# This will output a PDF file with your plot, adjust the size and dpi to your liking.
#It will be created in your basedir.
ggsave(filename = paste0(basedir, "simple_pca_plot.pdf"), 
  plot = simple.pca, width = 28, height = 24, units = "cm", dpi = 600) 

# This will output a PDF with plot that has all the labels.
# It will be created in your basedir.
ggsave(filename = paste0(basedir, "labeled_pca_plot.pdf"), 
  plot = labeled.pca, width = 28, height = 24, units = "cm", dpi = 600)
