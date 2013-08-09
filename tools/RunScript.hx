import EReg;
import haxe.io.Path;
#if haxe3
import sys.FileSystem;
#else
import neko.FileSystem;
#end

import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

class RunScript{

	private static var isWindows: Bool = false;
	// private static var rootDir: EReg;
	private static var assetsDir:String;

	static var relPath:Bool;

	public static function main():Void
	{
		if(new EReg ("window", "i").match(Sys.systemName())){
			isWindows = true;
		}

		var args:Array <String> = Sys.args();

		// Check args
		if(args.length < 2){
			Sys.println("You must specified a path to your assets and an outputfile.\nhaxelib run ExAM ASSETS_DIR OUTPUT_FILE");
			return ;
		}

		var outputFile: String;
		
		assetsDir = new Path(args[0]).toString();
		outputFile = new Path(args[1]).toString();

		relPath = (args[2] == "--relPath");

		Sys.setCwd(assetsDir);

		if(!FileSystem.exists(assetsDir)){
			Sys.println("Specified asset directory ("+assetsDir+") doesn't exist.");
			return;
		}

		var output = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<data>\n\t<group name=\"auto\">";
		// if(assetsDir.indexOf("/") == assetsDir.length-1) 	assetsDir = assetsDir.substr(0, assetsDir.length-1);
		// rootDir = new EReg(Path.withoutDirectory(assetsDir)+"/?", "");//.substr(assetsDir.lastIndexOf("/"));
		output += createOutput(assetsDir);
		output += "\n\t</group>\n</data>";

		if(FileSystem.exists(outputFile)){
			File.saveContent(outputFile, output);
		}
		else{
			var fileIn = File.write(outputFile);
			fileIn.writeString(output);
		}

		Sys.println("Assets library created successfully in "+outputFile);
	}

	private static function createOutput(dir: String, level: Int = 1):String
	{
		var output:StringBuf = new StringBuf();
		var sysFile:EReg = ~/^\..+/;
		var font:EReg = ~/.*\.[o|t]tf(.hash)?/;
		var spritesheet:EReg = ~/.*spritesheet.*/;
		var text:EReg = ~/.+\.xml|txt|json/;
		var img:EReg = ~/.+\.png|jpg|jpeg/;
		var sound:EReg = ~/.+\.mp3|wav/;

		//remove assetsDir from basePath if relPath option has been set
		// the "/" at the end of the path pattern is optional
		var basePath = (relPath) ? new EReg(assetsDir+"/?","").replace(dir,"") : assetsDir;
		if (basePath!="") basePath += "/";


		for(asset in FileSystem.readDirectory(dir)){
			if(!sysFile.match(asset) && !font.match(asset)){
				if(!FileSystem.isDirectory(dir + "/" + asset)){

					
					var node: String;
					// var dirOnly = rootDir.replace(dir, "");
					// if(dirOnly != "")
					// 	dirOnly += "/";

					node = "\n\t\t<asset id=\"" + basePath +asset + "\" url=\"" + basePath +asset + "\"";
					if(spritesheet.match(dir+"/"+asset)){
						if(text.match(asset))
							node += " type=\"spritesheet\"/>";
						else
							node = null;
					}
					else if(img.match(asset))
					{
						node += " type=\"image\"/>";

					}
					else if(sound.match(asset))
						node += " type=\"sound\"/>";
					else if(text.match(asset))
						node += " type=\"text\"/>";
					else
						node += " type=\"raw\"/>";


					if(node != null)
						output.add(node);

				}
				else{
					output.add(createOutput(dir+"/"+asset, level+1));
				}
			}
		}

		return output.toString();
	}



}