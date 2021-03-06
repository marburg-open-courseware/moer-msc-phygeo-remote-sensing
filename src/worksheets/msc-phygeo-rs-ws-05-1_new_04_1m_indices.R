# rs-ws-05-1
# MOC - Data Analysis (T. Nauss, C. Reudenbach)
# Compute spectral indices

# Set environment --------------------------------------------------------------
if(Sys.info()["sysname"] == "Windows"){
  source("C:/Users/tnauss/permanent/edu/msc-phygeo-remote-sensing/moer-msc-phygeo-remote-sensing/src/functions/set_environment.R")
} else {
  source("/media/permanent/active/moc/msc-ui/scripts/msc-phygeo-ei/src/functions/set_environment.R")
}


# Compute spectral indices -----------------------------------------------------
muf <- stack(paste0(path_muf_set1m, "ortho_muf_1m.tif"))

idx <- rgbIndices(muf, rgbi = c("GLI", "NGRDI", "TGI", "VVI"))
projection(idx) <- CRS("+init=epsg:25832")
writeRaster(idx, paste0(path_muf_set1m, "ortho_muf_", names(idx), ".tif"), 
                        bylayer = TRUE)
# idx <- stack(paste0(path_muf_set1m, "ortho_muf_", c("GLI", "NGRDI", "TGI", "VVI"), ".tif"))


# Compute glcm filters ---------------------------------------------------------
filenames <- c(list.files(path_muf_set1m_sample_non_segm, pattern = glob2rx("*rgb_idx*.tif"), 
                          full.names = TRUE), 
               list.files(path_muf_set1m_sample_non_segm, pattern = glob2rx("*I.tif"), 
                          full.names = TRUE))

filenames <- filenames[nchar(basename(filenames)) < 30]


windows <- c(3, 9, 15, 21)

for(name in filenames){
  
  for(win in windows){
    act <- raster(name)
    gt <- glcm(act, n_grey = 32, window = c(win, win),
               shift=list(c(0,1), c(1,1), c(1,0), c(1,-1)),
               statistics = c("mean", "variance", "correlation"))
    writeRaster(gt, 
                paste0(substr(name, 1, nchar(name)-4), "_", names(gt), "_w", win, ".tif"),
                bylayer = TRUE)
  }
}


