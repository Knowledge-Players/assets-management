package com.knowledgeplayers.utils.assets;

#if nme
import com.knowledgeplayers.utils.assets.loaders.concrete.SpritesheetAsset;
#end
import com.knowledgeplayers.utils.assets.interfaces.IAsset;
import haxe.xml.Fast;
import haxe.FastList;
import com.knowledgeplayers.utils.assets.loaders.Asset;
import com.knowledgeplayers.utils.assets.loaders.concrete.ImageAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.RawDataAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.SoundAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.TextAsset;

import flash.events.Event;
//import flash.utils.Dictionary;

/*
<!-- example file assets.xml -->
<?xml version="1.0" encoding="utf-8" ?>
<data>
 <group name="common">
	 <asset id="db" url="assets/data/db.csv" type="text" />
	 <asset id="lang" url="assets/data/lang.xml" type="text" />
	 <asset id="music" url="assets/sounds/music.mp3" type="sound" />
 </group>

<group name="x1">
	<asset id="bg" url="assets/textures/bg@x1.jpg" type="image" />
	<asset id="logotype" url="assets/textures/logotype@x1.jpg" type="image" />

	<asset id="atlas" url="assets/textures/atlas@x1.png" type="image" />
	<asset id="atlas_xml" url="assets/textures/atlas@x1.xml" type="text" />

	<asset id="compressed_texture" url="assets/textures/compressed_texture@x1.atf" type="raw" />
</group>

<group name="x2">
	<asset id="bg" url="assets/textures/bg@x2.jpg" type="image" />
	<asset id="logotype" url="assets/textures/logotype@x2.jpg" type="image" />

	<asset id="atlas" url="assets/textures/atlas@x2.png" type="image" />
	<asset id="atlas_xml" url="assets/textures/atlas@x2.xml" type="text" />

	<asset id="compressed_texture" url="assets/textures/compressed_texture@x2.atf" type="raw" />
 </group>
</data>
*/

class AssetsConfig extends TextAsset {

	public var list (default, null):FastList<IAsset>;

	private var groups:FastList<String>;
	private var loaders:Hash<Class<Asset>>;

	public function new(id:String, url:String, ?groups:FastList<String>) {
		super(id, url);

		this.groups = groups;
		list = new FastList<IAsset>();
		loaders = new Hash<Class<Asset>>();

		registerType("image", ImageAsset);
		#if nme
		registerType("spritesheet", SpritesheetAsset);
		#end
		registerType("text", TextAsset);
		registerType("sound", SoundAsset);
		registerType("raw", RawDataAsset);
	}

	public function registerType(type:String, loaderClass:Class<Asset>): Void
	{
		loaders.set(type, loaderClass);
	}

	override private function loadEventHandler(e:Event): Void
	{
		if(e.type == Event.COMPLETE){
			parse();
		}
		super.loadEventHandler(e);
	}

	private function parse():Void
	{
		var xml:Fast = new Fast(getXml().firstElement());
		var asset:IAsset;

		var skip:Bool = false;

		for(group in xml.nodes.group){
			if(groups != null){
				skip = true;
				for(g in groups){
					if(g == group.att.name){
						skip = false;
						break;
					}
				}
			}

			if(!skip){
				for(a in group.nodes.asset){
					asset = createAsset(a.att.type);
					asset.id = a.att.id;
					asset.url = a.att.url;
					list.add(asset);
				}
			}
		}
	}

	private function createAsset(type:String):IAsset
	{
		var loaderClass:Class<Asset> = loaders.get(type);

		if(loaderClass == null)
			throw "Error: Asset type '" + type + "' is unknown.";
		else
			return cast(Type.createInstance(loaderClass, []), IAsset);

		return null;
	}

	override public function dispose():Void {
		list = null;
		groups = null;
		loaders = null;

		super.dispose();
	}
}

