var inputFolder = 
"lib/forms/OptionsWindow";

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// inputFolder edited externally. Do not change the file to this comment line.
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// progect_patch you must tell yourself
var progect_path = "file:///D|/main/open-flash-windows-lib/"
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


inputFolder = progect_path + inputFolder

var nameFolderArray = inputFolder.split("/")
var nameFolder = nameFolderArray[nameFolderArray.length - 1]

var doc = fl.createDocument();

images = FLfile.listFolder( inputFolder+"/"+"*.png", "files");
library:library = doc.library;
library.newFolder(nameFolder);

for(var i = 0; i < images.length; i++)
{
	doc.importFile(inputFolder+"/"+images[i], true );
	library.selectItem(images[i]);
	
	var imageName = images[i].split(".")[0];
	library.renameItem(imageName);
	library.moveToFolder(nameFolder);
	
	var image = fl.getDocumentDOM().library.getSelectedItems()[0];
	image.linkageExportForAS = true;
	image.linkageExportInFirstFrame = true;
	image.linkageIdentifier = nameFolder + "_" + imageName;
}

doc.importPublishProfile(progect_path + 'python/toSWC.xml');
doc.currentPublishProfile = "toSWC";
fl.saveDocument(fl.documents[0], progect_path + "lib/" + nameFolder + ".fla");
doc.exportSWF(progect_path + "lib/" + nameFolder + ".swf");
doc.close(false);

//fl.quit();