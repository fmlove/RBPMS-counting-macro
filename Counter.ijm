setBatchMode(true);

dir = getDirectory("Select your data folder");

Dialog.create("Options");
Dialog.addChoice("File extension", newArray("tif"), "tif");//ADD MORE - adjust by folder
Dialog.addNumber("Gaussian blur sigma (radius)", 10);
Dialog.addNumber("Feature radius", 15);
Dialog.addMessage("More options for 3D Edge and Symmetry Filter:");
Dialog.addNumber("alpha Canny", 0.500);
Dialog.addNumber("Normalization", 10.00);
Dialog.addNumber("Scaling", 2.00);
Dialog.show();

ext = Dialog.getChoice();
sigma = Dialog.getNumber();
rad = Dialog.getNumber();
canny = Dialog.getNumber();
norm = Dialog.getNumber();
scal = Dialog.getNumber();

files = getFileList(dir);
for(i = 0; i < files.length; i++){
	//skip subdirectories
	if(endsWith(files[i], "/")){
		continue();
	}
	
	open(files[i]);//TODO - handle non-openable
	//no error handling - add option to specify format
	
	//skip non-image files
	if(nImages == 0){
		run("Close");
		continue();
	}
	
	
	rename("original");
	run("Duplicate...", "title=blur");
	run("Gaussian Blur...", "sigma="+sigma);
	
	imageCalculator("Subtract create 32-bit", "original","blur");
	rename("pseudo_corr");
	close("original");
	close("blur");
	
	run("Duplicate...", "title=mask");
	setAutoThreshold("Otsu");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	
	imageCalculator("Subtract create 32-bit", "pseudo_corr","mask");//pseudo_corr, mask
	rename("processed");
	close("pseudo_corr");
	close("mask");
	
	
	
	run("3D Edge and Symmetry Filter", "alpha="+canny+" compute_symmetry radius="+rad+" normalization="+norm+" scaling="+scal+" improved");
	selectWindow("Symmetry_smoothed_"+rad);//auto-generate based on radius input
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Watershed");
	run("Find Maxima...", "prominence=10 output=Count");

	setResult("File", i, files[i]);

	close("*");//should skip Results
	
}

	//save results
	//TODO - check if already exists and increment name
	saveAs("Results", dir + "results.csv");//saves to input folder
	