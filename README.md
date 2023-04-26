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
