// read in files to "filesDir"
//dir = getDirectory("Choose a Directory");
//dir = "J:\\DATA_2017-2018\\Optic_nerve\\EAE_miR_AAV2\\2018.08.07\\ON_11\\ROIs\\"
//dir = "C:\\Users\\Neuroimmunology Unit\\Documents\\GitHub\\Optic Nerve\\Etienne\\Control Images\\"
//dir = "C:\\Users\\Neuroimmunology Unit\\Documents\\GitHub\\Optic Nerve\\Training Data\\New folder\\"
dir_raw = getDirectory("Choose raw Directory");
dir_output = getDirectory("Choos output Directory");
dir_save = getDirectory("Choo save Directory");
//setBatchMode(true);
// ***ALSO MUST OPEN AN IMAGE OF THE CORRECT SIZE WHICH NAME MATCHES LINE #96
//count = 0;

list_raw = getFileList(dir_raw);
first_raw = list_raw[0];
list_output = getFileList(dir_output);
first_output = list_output[0];

num_files = list_raw.length;
print(num_files);
print(dir_raw);
print(first_raw);


/// Load in the raw data
run("Image Sequence...", "open=[" + dir_raw + first_raw + "] sort");
getDimensions(width, height, channels, slices, frames);
print(slices);
new_slices = slices/num_files;
new_frames = num_files;
print(new_slices);
print(new_frames);
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + new_slices + " frames=" + new_frames + " display=Grayscale");
rename("original")

// might need to interpolate to make a bit smaller
run("Scale...", "x=0.75 y=0.75 z=1.0 interpolation=Bilinear average process create");
selectWindow("original");
close();
rename("raw")

/// Load in the output data
run("Image Sequence...", "open=[" + dir_output + "/" + first_output + "] sort");
run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=" + new_slices + " frames=" + new_frames + " display=Grayscale");
rename("original")

// might need to interpolate to make a bit smaller
selectWindow("original");
run("Scale...", "x=0.75 y=0.75 z=1.0 interpolation=Bilinear average process create");
selectWindow("original");
close();
rename("output")

// merge together to make RGB
// c4 == gray
// c5 == cyan
// c6 == magenta

run("Merge Channels...", "c2=raw c6=output create");
run("RGB Color", "slices frames");

getDimensions(width, height, channels, slices, frames);
name = first_raw;
print(frames);
for (i = 1; i <= frames; i+=1) {
		//run("Concatenate...", "open image1=[" + list[i] + "] image2=[" + list[i + 1] + "]");
		run("Make Substack...", "slices=1-" + new_slices + " frames=" + i);


		// Run correct 3 drift
		//run("Correct 3D drift", "1");

	
		// SAVE THE FILE
		//run("Make Substack...", "frames=1");
		num_check = i * 2 - 1;
		
		num = "" + num_check;
		if (num_check < 10) {
			num = "00" + num;
		}
		else if (num_check < 100) {
			num = "0" + num;
		}

			
		//tmpStr = substring(name, 0, lengthOf(name) - 4);
		sav_Name = "slice_" + num + ".tif";
		saveAs("Tiff", dir_save + sav_Name);
					
		run("Close");
		call("java.lang.System.gc");    // clears memory leak
	 	call("java.lang.System.gc"); 
	  	call("java.lang.System.gc"); 
	  	call("java.lang.System.gc"); 
	    call("java.lang.System.gc"); 
	    call("java.lang.System.gc"); 
	    call("java.lang.System.gc"); 
	    call("java.lang.System.gc"); 
	    call("java.lang.System.gc"); 
	    call("java.lang.System.gc"); 

}

