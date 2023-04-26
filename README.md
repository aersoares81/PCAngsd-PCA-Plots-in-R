# PCAngsd PCA Plots in R

This is how I use R to plot PCAs from PCAngsd

The [PCAngsd](http://www.popgen.dk/software/index.php/PCAngsd) software can be used to create PCA plots for population genetics data. You can read more about it [here]((http://www.popgen.dk/angsd/index.php/ANGSD). It comes with an example R code to see the plot, but I wanted to create plots that I thought looked a bit nicer, with some additional layered information on them. So here's how I plot PCAngsd results in R.

## Input required

You will need the output from [ANGSD](http://www.popgen.dk/angsd/index.php/PCA) in the beagle format, which will have the genotype likelihood for variable sites in your input BAM file. It then can be used in [PCAngsd](http://www.popgen.dk/software/index.php/PCAngsd) (you can also use a PLINK file). In the end you will have an estimated covariance matrix, `output.cov`. You will need that file for plotting. You will also need a second file with the location and sample ID for your samples, separated by a tab. Let's call this file `pop.info`. Here's an example of how it should look:

```
"Location 1"	Sample1
"Location 2"	Sample2
"Another one"	Sample3
```

That will be helpful to add labels to your plot, and shouldn't be too complicated to generate. If you're using quotations marks you will be able to have multiple words as location in your plot in the end.

## Plotting

Now you're ready to plot. Here's the code I use:

```
library(RcppCNPy)
library(ggfortify)
library(tidyverse)
library(ggrepel)
#library(RColorBrewer)

# Make sure you're in the right place
basedir <- "~/Your/path/here/" # Make sure to edit this to match your $BASEDIR

# Load the output from PCAangsd
cov_quad <- as.matrix(read.table(paste0(basedir, "output.cov"), header = F))

# Now it will perform the PCA
mme.pca <- eigen(cov_quad)

# Here is the information from your population: location and name of the samples
samplemat <- as.matrix(read.table(paste0(basedir, "pop.info"), header = F))
sampleheaders <- c("location","sample_id")
colnames(samplemat) <- sampleheaders

# Extract the eigenvectors and turn them into a dataframe for plotting
eigenvectors = mme.pca$vectors #extract eigenvectors 
# Combining the information from the populations/samples
pca.vectors = as_tibble(cbind(samplemat, data.frame(eigenvectors))) 
legend_title <- "Location"

# This will create a "simple" PCA plot. It will have a legend with the location of the samples next to it.
# Adjust the title, of course.
# Please notice that I commented the RColorBrewer.
# Uncomment and use the palette your like the most if you want to change the colors.
# Don't forget to uncomment the library in in the beginning of the script too.
simple.pca = ggplot(data = pca.vectors, aes(x=X1, y=X2, colour = location, label = sample_id)) + 
geom_point() + 
labs(title="Homo sapiens", x="PC1",y="PC2",fill = "Location", colour ="Location", labels="Location") + 
theme(plot.title = element_text(face = "italic")) #+ scale_color_brewer(palette="Set1")
plot(simple.pca)

# This will create another PCA plot.
# In this version, every point (or as much as possible considering their density) will have the sample ID assigned to it.
# It's neat if you want to see where exactly each sample is placed.
labeled.pca = ggplot(data = pca.vectors, aes(x=X1, y=X2, colour = location, label = sample_id)) + 
geom_point() + labs(title="Homo sapiens", x="PC1",y="PC2",fill = "Location", colour ="Location", labels="Location") + 
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

```

You can download it from this repo too, of course.
