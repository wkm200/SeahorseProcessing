// Enable Bio-Formats Macro Extensions
run("Bio-Formats Macro Extensions");

function createOutputFolder(inputDir) {
    outputDir = inputDir + File.separator + "tiff";
    counter = 0;
    while (File.exists(outputDir)) {
        counter++;
        outputDir = inputDir + File.separator + "tiff." + counter;
    }
    File.makeDirectory(outputDir);
    return outputDir;
}

function getFileNameWithoutExtension(filePath) {
    // Get the file name from the full path
    slashIndex = lastIndexOf(filePath, File.separator);
    if (slashIndex >= 0) {
        fileName = substring(filePath, slashIndex + 1);
    } else {
        fileName = filePath; // No path separator found
    }
    // Remove the extension
    dotIndex = lastIndexOf(fileName, ".");
    if (dotIndex > -1) {
        return substring(fileName, 0, dotIndex);
    } else {
        return fileName; // No extension found
    }
}

function saveAsTiff(inputFile, outputDir) {
    // Get the base name of the file (remove path and extension)
    fileName = getFileNameWithoutExtension(inputFile);
    // Set the output path
    outputFile = outputDir + File.separator + fileName + ".tif";

    // Reset brightness and contrast to avoid black images
    resetMinAndMax();
    //run("Apply LUT", "stack");

    // Save the image
    saveAs("Tiff", outputFile);
    print("Saved: " + outputFile);
}

function processDirectory(directory, filterString) {
    fileList = getFileList(directory);
    outputDir = createOutputFolder(directory);
    print("Saving to output folder: " + outputDir);

    for (i = 0; i < fileList.length; i++) {
        filePath = directory + File.separator + fileList[i];

        // Check if the file name contains the filter string and ends with .ims
        if (endsWith(filePath, ".ims") && indexOf(fileList[i], filterString) >= 0) {
            print("Attempting to open: " + filePath);
            // Attempt to open the image
            Ext.openImagePlus(filePath);

            // Check if an image window is now active
            if (nImages() > 0) {
                // Save the active image as TIFF
                saveAsTiff(filePath, outputDir);
                close(); // Close the active image
            } else {
                print("Failed to open image: " + filePath);
            }
        }
    }
}

function main() {
    // Prompt user to select a directory
    inputDir = getDirectory("Choose a directory containing .ims files:");
    // Check if the user canceled or inputDir is invalid
    if ("" + inputDir == "null" || inputDir.length == 0) {
        print("No directory selected. Exiting.");
        return;
    }

    // Prompt user to enter a filter string
    filterString = getString("Enter the string to filter filenames:", "_deconvolved.ims");
    // Check if the user canceled or provided no filter string
    if ("" + filterString == "null" || filterString.length == 0) {
        print("No filter string provided. Exiting.");
        return;
    }

    print("Processing directory: " + inputDir);
    print("Filter string: " + filterString);

    // Process the selected directory
    processDirectory(inputDir, filterString);

    print("Processing complete.");
}

// Run the main function
main();
