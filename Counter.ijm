setBatchMode(true);

dir = getDirectory("Select your data folder");
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
	run("Gaussian Blur...", "sigma=10");
	
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
	
	
	
	run("3D Edge and Symmetry Filter", "alpha=0.500 compute_symmetry radius=15 normalization=10 scaling=2 improved");
	selectWindow("Symmetry_smoothed_15");//auto-generate based on radius input
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
	