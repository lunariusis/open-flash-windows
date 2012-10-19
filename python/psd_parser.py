# -*- coding: utf8 -*-
"ЙЦУКЕНйцукен"

import win32com.client
import os
import sys
import time
import shutil


jsfl_path = "..\\..\\python\\include_in_swc.jsfl"
jsfl_imput_folder_path_string = '"lib/forms/'
parsed_forms_path = "..\\forms"

def knvt(s_tring, codeutf="utf8", code="utf8"):
	return s_tring.encode(code)


def toSWC(nameFolder):
	file_jsfl = open(jsfl_path, "r")
	file_lines = file_jsfl.readlines()

	new_line = jsfl_imput_folder_path_string + '%s";'%(nameFolder)
	file_lines[1] = new_line + "\n"
	file_jsfl.close()

	file_jsfl = open(jsfl_path, "w")
	for line in file_lines:
		file_jsfl.writelines(line)


def exportToXML(doc, layerSets, folderName, docLayers):
	doc.Trim(0, True, True, True, True)
	layersParams = []
	outputXmlString = ""
	outputXmlString += "<data>\n"
	for layer in docLayers:
		if "noexport" in layer.Name:
			layer.Visible = False
			continue
		if layer not in layerSets:
			layer.Visible = False
			x, y, x2, y2 = layer.Bounds
			lsName = layer.Name.lower().strip().replace(" ", "_")
			outputXmlString += '    <layer name="%s" x="%s" y="%s" w="%s" h="%s" tp="L"/>\n'%( lsName,int(x),int(y),int(x2-x),int(y2-y) )
			print knvt( 'exporting to xml: %s'%(lsName) )
		else:
			LL = [ll for ll in layer.Layers]
			LL.reverse()
			xM, yM, x2, y2 = layer.Bounds
			xM = int(xM)
			yM = int(yM)
			wM = int(x2-xM)
			hM = int(y2-yM)
			outputXmlString += '    <layer name="%s" x="%s" y="%s" w="%s" h="%s" tp="LS">\n'%(layer.Name,xM,yM,wM,hM)
			for layerS in LL:
				layerS.Visible = False
				x, y, x2, y2 = layerS.Bounds
				xN = int(x)
				yN = int(y)
				x = int(x) - xM
				y = int(y) - yM
				w = int(x2-xN)
				h = int(y2-yN)
				lsName = layerS.Name.lower().strip().replace(" ", "_")
				outputXmlString += '        <layer name="%s" x="%s" y="%s" w="%s" h="%s" tp="LIS"/>\n'%( lsName,x,y,w,h )
				print knvt( 'exporting to xml: %s'%(lsName) )
			outputXmlString += '    </layer>\n'
	outputXmlString += "</data>\n"
	
	xmlfile = open("%s.xml"%folderName, "w")
	xmlfile.write(knvt(outputXmlString))
	xmlfile.close()

def exportToPNG(doc, layerSets, folderName, docLayers):
	for layer in docLayers:
		if "noexport" in layer.Name or "textmarker_" in layer.Name:
			print knvt( '#1 NO exporting to png: %s'%layer.Name )
			continue
		if layer not in layerSets:
			layer.Visible = True
			doc.Trim(0, True, True, True, True)
			lsName = layer.Name.lower().strip().replace(" ", "_")
			pngFile = folderName + "\\" + lsName + '.png'
			doc.Export(ExportIn=pngFile, ExportAs=2)
			doc.ActiveHistoryState = doc.HistoryStates[len(doc.HistoryStates)-2]
			layer.Visible = False
			print knvt( 'exporting to png: %s'%pngFile )
	
	for layerSet in layerSets:
		if "noexport" in layerSet.Name or "textmarker_" in layerSet.Name:
			print knvt( '#2 NO exporting to png: %s'%layer.Name )
			continue
		LL = [ll for ll in layerSet.Layers]
		LL.reverse()
		for layer in LL:
			if "noexport" in layer.Name or "textmarker_" in layer.Name:
				print knvt( '#3 NO exporting to png: %s'%layer.Name )
				continue
			
			layer.Visible = True
			doc.Trim(0, True, True, True, True)
			lsName = layer.Name.lower().strip().replace(" ", "_")
			pngFile = folderName + "\\" + lsName + '.png'
			doc.Export(ExportIn=pngFile, ExportAs=2)
			doc.ActiveHistoryState = doc.HistoryStates[len(doc.HistoryStates)-2]
			layer.Visible = False
			print knvt( 'exporting to png: %s'%pngFile )

def main(psdFile, toswc):
	##############################################################
	folderName = os.path.splitext(psdFile)[0]
	try:
		shutil.rmtree(folderName)
	except:
		pass
	time.sleep(0.1)
	try:
		os.mkdir(folderName)
	except:
		print "Not make dir: %s"%(folderName)
		sys.exit();
	##############################################################
	psApp = win32com.client.Dispatch("Photoshop.Application")
	psApp.Visible = False
	
	doc = psApp.Open(psdFile)

	layerSets = [ll for ll in doc.LayerSets]
	layerSets.reverse()

	docLayers = [ll for ll in doc.Layers]
	docLayers.reverse()
	
	exportToXML(doc, layerSets, folderName, docLayers)
	
	exportToPNG(doc, layerSets, folderName, docLayers)
	
	doc.Close(2)
	psApp.Visible = True
	
	#################################################################################################################
	try:
		shutil.rmtree(parsed_forms_path + "\\%s"%(folderName.split("\\")[-1]  )   )
	except:
		pass
	try:
		os.remove(parsed_forms_path + "\\%s.xml"%(folderName.split("\\")[-1]  )   )
	except:
		pass
	
	if toswc == "toswc":
		time.sleep(0.2)
		shutil.move(folderName, parsed_forms_path)
		time.sleep(0.2)
		shutil.move("%s.xml"%folderName, parsed_forms_path)
		toSWC(folderName.split("\\")[-1])
		
	
if __name__ == '__main__':
	print sys.argv
	if len(sys.argv) == 3 :
		inputfile = sys.argv[1]
		toswc = sys.argv[2]
	else :
		sys.stderr.write("Usage: python %s inputPSDfile toswc/noswc \n"%sys.argv[0])
		raw_input()
		raise SystemExit(1)
		
	main(inputfile, toswc)
	
	#raw_input("Press Enter ...")
	
	
	