

#' Add the IFS graph theme
#'
#' \code{theme_ifs} adds the standard IFS graph theme, (but not the
#' IFS colour scheme) to a ggplot graph. \code{theme_ifs} can be overwritten
#' by personal theme preferences below the \code{theme_ifs} call.
#'
#' @param base_size Base font size, given in pts.
#'
#' @return
#' @export
#'
#' @examples
#' ggplot(mtcars, aes(x = disp, y = mpg)) +
#' theme_ifs()

theme_ifs <- function(base_size = 10, ...) {

  ggplot2::theme_bw() +
    theme(panel.border = element_blank(),
          plot.title = element_text(color = "black", size = 12),
          axis.line = element_line(color = "#b3b3b3", size = 0.5),
          axis.text = element_text(color = "black", size = base_size),
          axis.title.x = element_text(color = "black", size = base_size, margin = margin(6, 0, 0, 0)),
          axis.title.y = element_text(color = "black", size = base_size, margin = margin(0, 6, 0, 0)),
          axis.ticks = element_line(color = "#b3b3b3"),
          legend.text = element_text(color = "black", size = base_size),
          legend.title = element_text(color = "black"),
          strip.background = element_rect(fill = 'white', color = 'white'),
          strip.text = element_text(color = "black", size = base_size),
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.major.y = element_line(linetype = "dashed", color = "#b3b3b3", size = 0.325))

}


#' Title Return hex codes for a vector of IFS colour names
#'
#' @param values A vector of colour names (e.g. "mid_green", "dark_green_2", "light_purple_1")
#'
#' @return
#' @export
#'
#' @examples ifs_colour_wheel(c("dark_green_1", "mid_green", "dark_red_1"))
ifs_colour_wheel <- function(values) {
  colour_wheel <- list(
    "dark_green_2" = "#184F3B", "dark_green_1" = "#247658", "mid_green" = "#309E75",
    "light_green_1" = "#73D4B0", "light_green_2" = "#A2E3CA", "light_green_3" = "#D0F1E5",
    "dark_grey_2" = "#243D40", "dark_grey_1" = "#334F56", "mid_grey" = "#40646D",
    "light_grey_1" = "#80AAB4", "light_grey_2" = "#AAC6CD", "light_grey_3" = "#D5E3E6",
    "dark_red_2" = "#87220E", "dark_red_1" = "#CB3315", "mid_red" = "#EB5C40", "light_red_1" = "#F39D8C",
    "light_red_2" = "#F7BEB3", "light_red_3" = "#FBDED9", "dark_blue_2" = "#123C63",
    "dark_blue_1" = "#1B5A95", "mid_blue" = "#2478C7", "light_blue_1" = "#73AEE6",
    "light_blue_2" = "#A2C9EE", "light_blue_3" = "#D0E4F7", "dark_yellow_2" = "#7D5C07",
    "dark_yellow_1" = "#BC8B0B", "mid_yellow" = "#F2B517", "light_yellow_1" = "#F7D374",
    "light_yellow_2" = "#FAE1A2", "light_yellow_3" = "#FCF0D1", "dark_purple_2" = "#471931",
    "dark_purple_1" = "#6B264A", "mid_purple" = "#8F3363", "light_purple_1" = "#CD73A2", "light_purple_2" = "#DEA2C1",
    "light_purple_3" = "#EED0E0"
  )

  colour_df <- data.frame(colour_names =names(colour_wheel), colour_hex = unlist(colour_wheel), row.names = NULL)

  colours_out <- sapply(values, function(v) {
    if (v %in% colour_df$colour_names) {
      out <- colour_df$colour_hex[colour_df$colour_names == v]
    } else {
      return(NA)
    }})

  return(unlist(colours_out))
}

#' Title Find the hex codes associated with a palette name
#'
#' @param palette The palette (can take one of "default", "greens", "greys", "reds", "blues", "yellows" or "purples") the user wants.
#'
#' @return
#' @export
#'
#' @examples ifs_palettes("greens")
ifs_palettes <- function(palette = "default") {
  palette_list <- list(
    "default" = c("mid_green", "mid_grey", "mid_yellow", "mid_purple", "mid_red", "mid_blue"),
    "greens" = c("dark_green_2", "dark_green_1", "mid_green", "light_green_1", "light_green_2", "light_green_3"),
    "greys" = c("dark_grey_2", "dark_grey_1", "mid_grey", "light_grey_1", "light_grey_2", "light_grey_3"),
    "reds"   =  c("dark_red_2", "dark_red_1", "mid_red", "light_red_1", "light_red_2", "light_red_3"),
    "blues" = c("dark_blue_2", "dark_blue_1", "mid_blue", "light_blue_1", "light_blue_2", "light_blue_3"),
    "yellows" = c("dark_yellow_2", "dark_yellow_1", "mid_yellow", "light_yellow_1", "light_yellow_2", "light_yellow_3"),
    "purples" = c("dark_purple_2", "dark_purple_1", "mid_purple", "light_purple_1", "light_purple_2", "light_purple_3")
  )

  if (is.null(palette_list[[palette]])) {
    return(NULL)
  } else {
    return(ifs_colour_wheel(palette_list[[palette]]))
  }

}

#' Title Internal function for concatenating the colour list
#'
#' @param direction Whether colours should be reversed (-1) or not.
#' @param desired_cols The list of desired colours
#'
#' @return
#' @export
#'
#' @examples
ifs_pal_finder <- function (direction, desired_cols) {
  force(direction)
  function(n) {
    pal <- desired_cols[1:n]
    if (direction == -1) {
      pal <- rev(pal)
    }
    pal
  }
}


#' Title Add IFS colours to a ggplot
#' A wrapper for \code{scale_colour_manual} / \code{scale_fill_manual} that allows the user to specify a
#' certain colour palette, or ask for specific IFS colours.
#'
#' @param palette The default option are the IFS mid-colours. Accepted values are \code{"greens",
#' "greys", "blues", "reds", "yellows", "purples"}.
#' @param values For manually entering colour values. The allowed values are \code{"dark_X_2", "dark_X_1", "mid_X", "light_X_1", "light_X_2", "light_X_3"}.
#' Replace X with green, grey, blue, red, yellow, purple.
#' @param gradient If true, acts as a wrapper for \code{scale_colour_gradientn} or \code{scale_fill_gradientn}.
#' @param ... Other values to pass to \code{scale_colour_manual} or \code{scale_fill_manual}
#'
#' @return
#' @export
#'
#' @examples
#' ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, colour = Species)) +
#' geom_point() +
#' scale_colour_ifs()
#'
#' ggplot(iris, aes(x = Sepal.Width, y= Sepal.Length, colour = Species)) +
#' geom_point() +
#' scale_colour_ifs(values = c("dark_green_2", "mid_red", "light_yellow_3"))
#'
#' ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, colour = Petal.Length)) +
#' geom_point() +
#' scale_colour_ifs(palette = "greys", gradient = TRUE)
scale_colour_ifs <- function(palette = "default", values = NA, gradient = FALSE, ...) {

  # If User didn't specify values
  if (is.na(values[1]) == TRUE) {

    # Will give the 6 colours that corrrespond to the palette selected
    desired_cols <- ifs_palettes(palette = palette)
    # discrete_scale doesnt' seem to be able to deal with names vectors
    desired_cols <- unname(desired_cols)

    if (is.null(desired_cols)) {
      stop(paste0("Couldn't find IFS colour palette '", palette, "'. Valid palettes are: default, greens, greys, blues, reds, yellows, purples"))
    }

  } else { # Manual values

    desired_cols <- ifs_colour_wheel(values)
    if (any(is.na(desired_cols) == T)) {
      na_colour <- names(desired_cols)[is.na(desired_cols)]
      stop(paste("Couldn't find IFS colour(s):", paste(na_colour, collapse = '; ')))
    }
    # discrete_scale doesnt' seem to be able to deal with names vectors
    desired_cols <- unname(desired_cols)
  }

  if (gradient == FALSE) {
    ggplot2::discrete_scale("colour", "ifs", ifs_pal_finder(direction = -1, desired_cols), ...)
  } else if (gradient == TRUE) {
    ggplot2::scale_colour_gradientn(colours = desired_cols, ...)
  }

}

#' @describeIn scale_colour_ifs Equivalent wrapper for scale_fill_manual
scale_fill_ifs <- function(palette = "default", values = NA, gradient = FALSE, ...) {

  # User didn't specify values
  if (is.na(values[1]) == TRUE) {

    # Will give the 6 colours that corrrespond to the palette selected
    desired_cols <- ifs_palettes(palette = palette)
    # discrete_scale doesnt' seem to be able to deal with names vectors
    desired_cols <- unname(desired_cols)

    if (is.null(desired_cols)) {
      stop(paste0("Couldn't find IFS colour palette '", palette, "'. Valid palettes are: default, greens, greys, blues, reds, yellows, purples"))
    }

  } else { # Manual values

    # Converts desired colours from names to hex values
    desired_cols <- ifs_colour_wheel(values)
    if (any(is.na(desired_cols) == T)) {
      na_colour <- names(desired_cols)[is.na(desired_cols)]
      stop(paste("Couldn't find IFS colour(s):", paste(na_colour, collapse = '; ')))
    }

  }

  # Gradient is dealt with
  if (gradient == FALSE) {

    # If no assigned names are provided
    if (is.null(names(desired_cols))) {
      ggplot2::discrete_scale("fill", "ifs", ifs_pal_finder(direction = -1, unname(desired_cols)), ...)
    } else { #
      ggplot2::scale_fill_manual(values = desired_cols, ...)
    }

  } else if (gradient == TRUE) {
   ggplot2::scale_fill_gradientn(colours = unname(desired_cols), ...)
  }
}

#' Save a ggplot with IFS base dimensions
#'
#' This is a wrapper for \code{ggsave} which saves ggplots in default IFS
#' dimensions for Word documents.
#'
#' @param filename Filename to create on disk (including .png)
#' @param plot Plot to save
#' @param path Path of the directory to save plot to: path and filename are
#' combined to create the fully qualified file name. Defaults to current working directory.
#' @param widescreen Default plot size is 100mm x 150mm. If \code{TRUE}, saves to 100mm x 60mm.
#' @param save_data If \code{TRUE}, then it saves the data associated with the ggplot as a .csv file. This is not recommended for histograms / density plots.
#' @param data_dir The directory to store the data if \code{save_data == TRUE}. The default is the directory entered in \code{path}.
#' @param data_name The directory to
#' @param height The height of the plot (default in mm)
#' @param width The width of the plot (default in mm)
#' @param units The units for height and width (can take one of "mm", "in", "cm", or "px")).
#' @param dpi Plot resolution. Also accepts a string input: "retina" (320), "print" (300), or "screen" (72). Applies only to raster output types.
#' @param device Device to use, defaults to ".png". Can also be one of "eps", "ps", "tex" (pictex), "pdf", "jpeg", "tiff", "png", "bmp", "svg" or "wmf" (windows only).
#' @param ... Any other arguments for \code{ggsave}.
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{g <- ggplot(mtcars, aes(mpg, wt)) + geom_point()
#' ggsave_ifs("a_graph.png", g, "~/output")}
ggsave_ifs <- function(filename, plot = last_plot(), path = getwd(), widescreen = FALSE, save_data = FALSE, data_dir = path, data_name = filename, height = NA, width = NA, units = "mm", dpi = 320, device = "png", ...) {

  if (widescreen == FALSE) {
    if (is.na(height)) {
      height <- 100
    }
    if (is.na(width)) {
      width <- 150
    }
  } else if (widescreen == TRUE) {
    if (is.na(height)) {
      height <- 60
    }
    if (is.na(width)) {
      width <- 100
    }
  }

  if (save_data == TRUE) {
    plot_data <- plot$data
    if (data_name == filename) {
      # Find everything that precedes the dot.
      data_name <- stringr::str_extract(data_name, ".*(?=\\.)")
    }
    readr::write_csv(plot_data, paste0(data_dir, "/", data_name, ".csv"))
  }

  ggplot2::ggsave(filename = filename, plot = plot, path = path, height = height, width = width, units = units, dpi = dpi, device = device, ...)
}
