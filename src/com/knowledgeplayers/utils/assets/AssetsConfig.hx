package com.knowledgeplayers.utils.assets;

#if (nme || openfl)
import com.knowledgeplayers.utils.assets.loaders.concrete.SpritesheetAsset;
#end
import com.knowledgeplayers.utils.assets.interfaces.IAsset;
import haxe.xml.Fast;
import haxe.ds.GenericStack;
import com.knowledgeplayers.utils.assets.loaders.Asset;
import com.knowledgeplayers.utils.assets.loaders.concrete.ImageAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.RawDataAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.SoundAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.TextAsset;

import flash.events.Event;

class AssetsConfig extends TextAsset {

	public var list (default, null):GenericStack<IAsset>;

	private var groups:GenericStack<String>;
	private var loaders:Map<String, Class<Asset>>;

	public function new(id:String, url:String, ?groups:GenericStack<String>) {
		super(id, url);

		this.groups = groups;
		list = new GenericStack<IAsset>();
		loaders = new Map<String, Class<Asset>>();

		registerType("image", ImageAsset);
		#if (nme || openfl)
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

