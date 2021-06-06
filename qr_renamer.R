library(magick)
library(tesseract)
library(tidyverse)
library(stringr)

rm(list =ls())

# IMAGE UPLOADING AND CROPPING

img_list <- list.files("./qr", pattern = "\\.png$", full.names = TRUE)
all_images <- lapply(img_list, image_read)

width <- image_info(all_images[[1]])[2]

all_images_cropped <- lapply(all_images, image_crop, geometry_area(width = width, height = 50, y_off = 420))


# IMAGE TO TEXT

engine <- tesseract("eng")
texts_from_img <- lapply(all_images_cropped, ocr, engine = engine)

final_data <- texts_from_img %>%
    str_split(pattern = " ", n = 4, simplify = TRUE) %>%
    as_tibble() %>%
    select(1, 2) %>%
    mutate(
        full_name = paste(V1, V2, sep = " ")
    )

names <- paste("./qr/", final_data$full_name, ".png", sep = "")

file.rename(img_list, names)