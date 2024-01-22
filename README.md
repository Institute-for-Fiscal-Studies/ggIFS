
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggIFS

<!-- badges: start -->
<!-- badges: end -->

ggplot2 is the standard package for creating graphs in R. ggIFS is a
package that adds on to ggplot2 to make graphs that are consistent with
the IFS’s branding.

For those that are not familiar with the structure of ggplot2, ‘theme’
and colours are dealt with separately. Theme refers on the graph that is
not the data - i.e. the axis ticks and lines, the plot background, the
title, the size of the text, etc. Adding `theme_ifs()` to a ggplot2
graph adds the standard IFS theme elements.

Colours are applied separately. Unhelpfully, ggplot2 has two ways to
apply colour: ‘fill’ and ‘colour’. Fill is for things you want to fill,
such as bar graphs and area graphs, and colour is for things you want to
outline, such as line graphs and scatter graphs. Colours are applied
separately. `scale_colour_ifs()` and `scale_fill_ifs()` are wrappers for
`scale_colour_manual()` and `scale_fill_manual()` respectively, and
apply the IFS colour scheme to graphs.

Click [here](https://ggplot2-book.org/) for a more general guide to
ggplot2.

## Installation

You can install the development version of ggIFS from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Institute-for-Fiscal-Studies/ggIFS")
```

## Examples

### Standard bar chart

This is an example which applies the IFS theme and colour to a bar plot.

``` r
# Creating an example dataframe, which has the mean variable for each species. Iris is a built-in dataset used for examples. 
iris_clean <- iris %>%
  group_by(Species) %>%
  summarize(across(.cols = everything(), mean, na.rm = T)) %>% 
  pivot_longer(cols = !Species) %>%
  arrange(name)
#> Warning: There was 1 warning in `summarize()`.
#> ℹ In argument: `across(.cols = everything(), mean, na.rm = T)`.
#> ℹ In group 1: `Species = setosa`.
#> Caused by warning:
#> ! The `...` argument of `across()` is deprecated as of dplyr 1.1.0.
#> Supply arguments directly to `.fns` through an anonymous function instead.
#> 
#>   # Previously
#>   across(a:b, mean, na.rm = TRUE)
#> 
#>   # Now
#>   across(a:b, \(x) mean(x, na.rm = TRUE))

head(iris_clean)
#> # A tibble: 6 × 3
#>   Species    name         value
#>   <fct>      <chr>        <dbl>
#> 1 setosa     Petal.Length 1.46 
#> 2 versicolor Petal.Length 4.26 
#> 3 virginica  Petal.Length 5.55 
#> 4 setosa     Petal.Width  0.246
#> 5 versicolor Petal.Width  1.33 
#> 6 virginica  Petal.Width  2.03
```

Without putting in any arguments, `scale_fill_ifs()` (we are using fill
because we want a bar chart), will automatically apply the IFS standard
colour palette (mid-primary colours).

``` r

ggplot(iris_clean) +
  geom_bar(aes(x = Species, y = value, fill = name), stat = "identity") +
  # theme_ifs() adds the theme elements
  theme_ifs() +
  # scale_fill_ifs() without any options adds the colours
  scale_fill_ifs()
```

<img src="man/figures/README-example2-1.png" width="80%" height="80%" />

### Standard line graph

Creating a line graph is pretty similar to creating a bar chart, except
you have to use the colour aesthetic and `scale_colour_ifs()` .

``` r
#create another dummy dataset
iris_clean2 <- iris %>%
  mutate(row_number = row_number()) %>%
  pivot_longer(cols = Sepal.Length:Petal.Width)

ggplot(iris_clean2) +
  # Note - row thickness is not dealt with by theme, so has to be set manually
  geom_line(aes(x = row_number, y = value, colour = name), size = 0.75) +
  theme_ifs() +
  scale_colour_ifs() 
#> Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
#> ℹ Please use `linewidth` instead.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="80%" height="80%" />

### Choosing a specific palette

We can choose a custom palette, e.g. greens. Palettes can be greens,
greys, yellows, reds, blues, purples.

``` r
ggplot(iris_clean2) +
  geom_bar(aes(x = Species, y = value, fill = name), stat = "identity") +
  theme_ifs() +
  scale_fill_ifs(palette = "greens")
```

<img src="man/figures/README-example3-1.png" width="80%" height="80%" />

### User-specified palette

We can choose custom colour values, using the ‘values’ argument. The
potential values are dark_X_2, dark_X_1, mid_X, light_X_1, light_X_2,
light_X_3, substituting X for green, grey, yellow, red, blue or purple
(following the IFS naming convention).

``` r
ggplot(iris_clean2) +
  geom_bar(aes(x = Species, y = value, fill = name), stat = "identity") +
  theme_ifs() +
  scale_fill_ifs(values = c("Petal.Length" = "dark_green_2", "Petal.Width" = "dark_purple_1", "Sepal.Length" = "mid_yellow", "Sepal.Width" = "light_grey_3"))
```

<img src="man/figures/README-example4-1.png" width="80%" height="80%" />

### Bar Chart - Single Colours

The `scale_fill_ifs` and `scale_colour_ifs` commands are designed to map
to the `fill` or `colour` aesthetics. This makes it awkward if you want
a graph with a single colour, as there will be nothing to put in the
`fill/colour` aesthetic.

There are two options to get around this. The first is just to set
`fill or colour = ""` in the `aes()` call, and then manually suppress
the legend ggplot will try to create.

``` r
ggplot(iris_clean2) +
  geom_bar(aes(x = Species, y = value, fill = ""), stat = "identity") +
  theme_ifs() +
  theme(legend.position = "none") +
  scale_fill_ifs()
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="80%" height="80%" />

Alternatively, you can forget about using `scale_fill_ifs()` and just
manually specify the colour. The hex value for the standard IFS is
\#309E75. Because we are manually specifying the colour and not linking
it to a variable, ggplot needs you to put it outside of the `aes()`
call.

``` r
# This will create the same code as above. 
ggplot(iris_clean2) +
  geom_bar(aes(x = Species, y = value), fill = "#307E75", stat = "identity")+
  theme_ifs()
```

### Scatter Plot

You can also add gradients, in which case the palette or user-specified
values are taken as start, end and mid points of the gradient.

``` r
ggplot(iris) +
  geom_point(aes(x = Sepal.Length, y = Sepal.Width, col = Petal.Width)) +
  theme_ifs() +
  scale_colour_ifs(palette = "greens", gradient = TRUE)
```

<img src="man/figures/README-example6-1.png" width="80%" height="80%" />

## Saving

Unlike Excel, R graph elements do not scale with size. Say you
originally save a graph as 50mm x 100mm. Later, you decide to save the
same graph as 100mm x 200mm. Although the graph has quadrupled in size,
the axis labels, axis numbers, legend, etc. will stay the same size.
This means everything will look really small when you increase the size
of the graph, and really compressed when you decrease the size of the
graph.

To deal with this, this package includes the function `ggsave_ifs()`,
which is a wrapper for `ggsave()` that has a default height of 100mm, a
default width of 150mm and saves at 320dpi.

Using the default options would be as so.

``` r
ggsave_ifs(filename = "example1.png", plot = gg_object, path = "C:/this_directory")
```

If you want to manually adjust heights and widths (for example, if you
have a graph with a lot going on), you can use:

``` r
ggsave_ifs(filename = "example1.png", plot = gg_object, path = "C:/this_directory", height = 200, width = 300)
```

See the help file for more options for ggsave_ifs.
