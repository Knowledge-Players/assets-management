import haxe.io.Path;
import neko.FileSystem;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

class RunScript{

	private static var isWindows: Bool = false;
	private static var absolute: Bool = true;

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
		else if(args.length == 4){
			absolute = args[2] == "true";
		}

		var assetsDir: String;
		var outputFile: String;
		if(absolute){
			assetsDir = new Path(args[args.length-1]+args[0]).toString();
			outputFile = new Path(args[args.length - 1] +args[1]).toString();
		}
		else{
			Sys.setCwd(args[args.length-1]);
			assetsDir = new Path(args[0]).toString();
			outputFile = new Path(args[1]).toString();
		}
		if(!FileSystem.exists(assetsDir)){
			Sys.println("Specified asset directory ("+assetsDir+") doesn't exist.");
			return;
		}

		var output = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<data>\n\t<group name=\"auto\">";
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
		Sys.println("dir: "+dir+", is sub: "+level);
		var output:StringBuf = new StringBuf();
		var sysFile:EReg = ~/^\..+/;
		var font:EReg = ~/.*\.[o|t]tf(.hash)?/;
		var spritesheet:EReg = ~/.*spritesheet.*/;
		var text:EReg = ~/.+\.[(xml)|(txt)]/;
		var img:EReg = ~/.+\.[(png)|(jpg)]/;
		var sound:EReg = ~/.+\.[(mp3)|(wav)]/;

		for(asset in FileSystem.readDirectory(dir)){
			if(!sysFile.match(asset) && !font.match(asset)){
				if(!FileSystem.isDirectory(dir + "/" + asset)){
					var node: String;
					if(absolute)
						node = "\n\t\t<asset id=\"" + Path.withoutExtension(asset) + "\" url=\"" + FileSystem.fullPath(dir+"/"+asset) + "\"";
					else if(level > 1){
						var subDir: String;
						if(isWindows)
							subDir = dir.substr(dir.indexOf("\\") + 1, dir.length - dir.indexOf("\\"));
						else
							subDir= dir.substr(dir.indexOf("/")+1, dir.length - dir.indexOf("/"));
						node = "\n\t\t<asset id=\"" + Path.withoutExtension(asset) + "\" url=\"" + subDir + "/" + asset + "\"";
					}
					else
						node = "\n\t\t<asset id=\"" + Path.withoutExtension(asset) + "\" url=\""  + asset + "\"";
					if(spritesheet.match(dir+"/"+asset)){
						if(text.match(asset))
							node += " type=\"spritesheet\"/>";
						else
							node = null;
					}
					else if(sound.match(asset))
						node += " type=\"sound\"/>";
					else if(text.match(asset))
						node += " type=\"text\"/>";
					else if(img.match(asset))
						node += " type=\"image\"/>";
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