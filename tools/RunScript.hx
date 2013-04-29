import haxe.io.Path;
import neko.FileSystem;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

class RunScript{

	public static function main():Void
	{

		var args:Array <String> = Sys.args();

		// Check args
		if(args.length < 2){
			Sys.println("You must specified a path to your assets and an outputfile.\nhaxelib run ExAM ASSETS_DIR OUTPUT_FILE");
			return ;
		}
		var assetsDir = new Path(args[2]+args[0]).toString();
		var outputFile = new Path(args[2] +args[1]).toString();
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

	private static function createOutput(dir: String):String
	{
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
					var node:String = "\n\t\t<asset id=\"" + Path.withoutExtension(asset) + "\" url=\"" + FileSystem.fullPath(dir+"/"+asset) + "\"";
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
					output.add(createOutput(dir+"/"+asset));
				}
			}
		}

		return output.toString();
	}
}