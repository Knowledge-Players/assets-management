package com.knowledgeplayers.utils.assets;

#if nme
import com.knowledgeplayers.utils.assets.loaders.concrete.SpritesheetAsset;
import aze.display.TilesheetEx;
#end
import flash.media.Sound;
import com.knowledgeplayers.utils.assets.loaders.concrete.SoundAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.TextAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.ImageAsset;
import flash.display.BitmapData;
import com.knowledgeplayers.utils.assets.interfaces.IAsset;
import com.knowledgeplayers.utils.assets.loaders.Asset;
import flash.events.Event;

class AssetsStorage{

	private static var container:Hash<IAsset> = new Hash<IAsset>();

	public static function setAsset(asset:IAsset):Void {
		container.set(asset.id, asset);
		asset.addEventListener(Event.REMOVED, removedAssetHandler, false, 0, true);
	}

	private static function removedAssetHandler(event:Event):Void {
		var id:String = cast(event.target, IAsset).id;

		if(hasAsset(id))
			container.remove(id);
	}

	public static function hasAsset(id:String):Bool {
		return container.exists(id);
	}

	public static function getAsset(id:String):IAsset {
		return container.get(id);
	}

	public static function getBitmapData(id:String):Null<BitmapData>
	{
		if(container.exists(id) && Std.is(container.get(id), ImageAsset)){
			return cast(container.get(id), ImageAsset).getBitmap().bitmapData;
		}
		else{
			trace("[Assets] There is no BitmapData asset with an ID of \"" + id + "\"");
		}
		return null;
	}

	public static function getText(id:String):Null<String>
	{
		if(container.exists(id) && Std.is(container.get(id), TextAsset)){
			return cast(container.get(id), TextAsset).getText();
		}
		else{
			trace("[Assets] There is no Text asset with an ID of \"" + id + "\"");
		}
		return null;
	}

	public static function getXml(id:String):Null<Xml>
	{
		if(container.exists(id) && Std.is(container.get(id), TextAsset)){
			return cast(container.get(id), TextAsset).getXml();
		}
		else{
			trace("[Assets] There is no XML asset with an ID of \"" + id + "\"");
		}
		return null;
	}

	public static function getSound(id:String):Null<Sound>
	{
		if(container.exists(id) && Std.is(container.get(id), SoundAsset)){
			return cast(container.get(id), SoundAsset).getSound();
		}
		else{
			trace("[Assets] There is no Sound asset with an ID of \"" + id + "\"");
		}
		return null;
	}

	#if nme
	public static function getSpritesheet(id: String):Null<TilesheetEx>
	{
		if(container.exists(id) && Std.is(container.get(id), SpritesheetAsset)){
			return cast(container.get(id), SpritesheetAsset).getTilesheet();
		}
		else{
			trace("[Assets] There is no Spritesheet asset with an ID of \"" + id + "\"");
		}
		return null;
	}
	#end

	public static function removeAsset(id:String):Void {
		var asset:IAsset = getAsset(id);
		asset.dispose();

		container.remove(id);
		asset.removeEventListener(Event.REMOVED, removedAssetHandler);
	}
}