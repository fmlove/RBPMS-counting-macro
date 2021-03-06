setBatchMode(true);

dir = getDirectory("Select your data folder");
files = getFileList(dir);
acceptable_ext = newArray(//selection of native formats - can add more as necessary
	"tif"
	,"tiff"
	,"gif"
	,"jpg"
	,"jpeg"
	,"png"
	,"bmp"
);
present_ext = newArray(0);
for(e = 0; e < acceptable_ext.length; e++){
	for(i = 0; i < files.length; i++){
		if( endsWith(files[i], "."+acceptable_ext[e]) ){
			present_ext = Array.concat(present_ext, acceptable_ext[e]);
			break();
			}
	}
}

Dialog.create("Options");
Dialog.addChoice("File extension", present_ext);//ADD MORE - adjust by folder
Dialog.addNumber("Gaussian blur sigma (radius)", 10);
Dialog.addNumber("Feature radius", 15);
Dialog.addMessage("More options for 3D Edge and Symmetry Filter:");
Dialog.addNumber("alpha Canny", 0.500);
Dialog.addNumber("Normalization", 10.00);
Dialog.addNumber("Scaling", 2.00);
Dialog.addCheckbox("Save points?", false);
Dialog.show();

ext = Dialog.getChoice();
sigma = Dialog.getNumber();
rad = Dialog.getNumber();
canny = Dialog.getNumber();
norm = Dialog.getNumber();
scal = Dialog.getNumber();
points = Dialog.getCheckbox();

images = newArray(0);
for(i = 0; i < files.length; i++){
	if( endsWith(files[i], "."+ext) ){
		images = Array.concat(images, files[i]);
	}
}


for(i = 0; i < images.length; i++){
		
	open(images[i]);
	
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

	if(points == true){
		//save points as well as count
		run("Find Maxima...", "prominence=10 output=[Point Selection]");
		run("Analyze Particles...", "add");
		roiManager("save", dir+images[i]+"_points.zip");
		close("ROI Manager");
	}
	
	
	setResult("File", i, images[i]);

	close("*");//should skip Results
	
}

	//save results
	//TODO - check if already exists and increment name
	saveAs("Results", dir + "results.csv");//saves to input folder
	