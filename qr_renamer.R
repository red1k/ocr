library(magick)
library(tesseract)
library(tidyverse)
library(purrr)

rm(list =ls())

# LIST OF ALL DRIVERS
driver_list <- readxl::read_excel('driver_list.xlsx')

# IMAGE UPLOADING AND CROPPING
img_files   <- list.files("qr/", pattern = "\\.png$", full.names = TRUE)
all_images  <- map(img_files, image_read)

width       <- image_info(all_images[[1]])[2]
all_images_cropped <- lapply(all_images, image_crop, geometry_area(width = width, height = 50, y_off = 420))

# IMAGE TO TEXT
engine <- tesseract("eng")
texts_from_img <- lapply(all_images_cropped, ocr, engine = engine)

# DATA CLEANING
final_data <- texts_from_img %>%
    str_split(pattern = " ", n = 4, simplify = TRUE) %>%
    as_tibble() %>%
    select(1, 2) %>%
    mutate(
        full_name = paste(V2, V1, sep = " ") %>% 
        str_replace("\n", "") %>% 
        toupper()
    ) %>% 
    left_join(driver_list) %>%
    select(-1, -2) %>%
    mutate(
        full_name = paste(Company, full_name, sep = " ")
    )

names <- paste("qr/", final_data$full_name, ".png", sep = "")

file.rename(img_files, names)
