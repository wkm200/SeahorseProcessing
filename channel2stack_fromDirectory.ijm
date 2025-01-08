// --------------- BEGIN UPDATED MACRO WITH RESIZING ---------------

// Prompt user for folder containing .tif files
inputDir = getDirectory("Choose a folder with .tif files:");
// Exit if no folder selected
if ("" + inputDir == "null" || inputDir.length == 0) {
    exit("User canceled. No folder selected.");
}

// Get list of .tif files in the folder
fileList = getFileList(inputDir);
largestWidth = 0;
largestHeight = 0;

// Determine the largest image size
for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".tif")) {
        open(inputDir + fileList[i]);
        imageWidth = getWidth();
        imageHeight = getHeight();
        if (imageWidth > largestWidth) largestWidth = imageWidth;
        if (imageHeight > largestHeight) largestHeight = imageHeight;
        close();
    }
}

print("Largest image size: " + largestWidth + " x " + largestHeight);

// Resize all images to the largest dimensions
resizedDir = inputDir + "resized/";
File.makeDirectory(resizedDir);

for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".tif")) {
        open(inputDir + fileList[i]);
        // Resize the image to the largest dimensions
        run("Canvas Size...", "width=" + largestWidth + " height=" + largestHeight + " position=Center zero");
        saveAs("Tiff", resizedDir + fileList[i]);
        close();
    }
}

// Open the resized image sequence as a stack
print("Opening resized image sequence from: " + resizedDir);
run("Image Sequence...", "open=[" + resizedDir + "] sort");

// Determine total stack size
stackSize = nSlices;
print("Total stack size: " + stackSize);

// Prompt user to input the correct dimensions
channels = getNumber("Enter the number of channels:", 1);
slices = getNumber("Enter the number of slices per channel:", 1);
frames = getNumber("Enter the number of frames:", stackSize / (channels * slices));

// Validate that the dimensions match the stack size
if (channels * slices * frames != stackSize) {
    exit("Error: channels x slices x frames must equal the total stack size (" + stackSize + ").");
}

// Convert stack to hyperstack with the provided dimensions
run("Stack to Hyperstack...", "order=xyczt(default) channels=" + channels + " slices=" + slices + " frames=" + frames + " display=Color");

// Split the hyperstack into individual channels
run("Split Channels");

// --------------- END UPDATED MACRO WITH RESIZING ---------------
