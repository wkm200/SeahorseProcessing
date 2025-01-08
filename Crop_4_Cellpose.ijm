inputDir = getDirectory("Choose a Directory");
outputDir = inputDir + "toCellpose/";
File.makeDirectory(outputDir);

// Retrieve all images in the directory
list = getFileList(inputDir);

setOption("ScaleConversions", true);

for (i = 0; i < list.length; i++) {
    // Open the current image
    open(inputDir + list[i]);
    originalTitle = getTitle();

    // Prompt to draw an ROI
    waitForUser("Draw a circular ROI between posts, then click OK.");
    
    // Save a cropped image
    run("Duplicate...", " ");
    	setBackgroundColor(255, 255, 255);
		run("Clear Outside");
		saveAs("Tiff", outputDir + replace(originalTitle, ".tif", "") + "_Cropped.tif");

    // Close all images
    while (nImages > 0) {
        selectImage(nImages);
        close();
    }
}