package com.knowledgeplayers.utils.assets;

#if nme
import com.knowledgeplayers.utils.assets.loaders.concrete.SpritesheetAsset;
import aze.display.SparrowTilesheet;
import aze.display.TilesheetEx;
#end
import nme.Assets;
import flash.media.Sound;
import com.knowledgeplayers.utils.assets.loaders.concrete.SoundAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.TextAsset;
import com.knowledgeplayers.utils.assets.loaders.concrete.ImageAsset;
import flash.display.BitmapData;
import com.knowledgeplayers.utils.assets.interfaces.IAsset;
import com.knowledgeplayers.utils.assets.loaders.Asset;
import flash.events.Event;

class AssetsStorage {

	private static var container:Map<String, IAsset> = new Map<String, IAsset>();

	public static function setAsset(asset:IAsset):Void
	{
		container.set(asset.id, asset);
		asset.addEventListener(Event.REMOVED, removedAssetHandler, false, 0, true);
	}

	private static function removedAssetHandler(event:Event):Void
	{
		var id:String = cast(event.target, IAsset).id;

		if(hasAsset(id))
			container.remove(id);
	}

	public static function hasAsset(id:String):Bool
	{
		return container.exists(id);
	}

	public static function getAsset(id:String):IAsset
	{
		return container.get(id);
	}

	public static function getBitmapData(id:String):Null<BitmapData>
	{
		#if flash
		if(container.exists(id) && Std.is(container.get(id), ImageAsset)){
			return cast(container.get(id), ImageAsset).getBitmap().bitmapData;
		}
		else{
			trace("[Assets] There is no BitmapData asset with an ID of \"" + id + "\"");
		}
		return null;
		#else
		return Assets.getBitmapData(id);
		#end
	}

	public static function getText(id:String):Null<String>
	{
		#if flash
		if(container.exists(id) && Std.is(container.get(id), TextAsset)){
			return cast(container.get(id), TextAsset).getText();
		}
		else{
			trace("[Assets] There is no Text asset with an ID of \"" + id + "\"");
		}
		return null;
		#else
		return Assets.getText(id);
		#end
	}

	public static function getXml(id:String):Null<Xml>
	{
		#if flash
		if(container.exists(id) && Std.is(container.get(id), TextAsset)){
			return cast(container.get(id), TextAsset).getXml();
		}
		else{
			trace("[Assets] There is no XML asset with an ID of \"" + id + "\"");
		}
		return null;
		#else
		return Xml.parse(Assets.getText(id));
		#end
	}

	public static function getSound(id:String):Null<Sound>
	{
		#if flash
		if(container.exists(id) && Std.is(container.get(id), SoundAsset)){
			return cast(container.get(id), SoundAsset).getSound();
		}
		else{
			trace("[Assets] There is no Sound asset with an ID of \"" + id + "\"");
		}
		return null;
		#else
		return Assets.getSound(id);
		#end
	}

	#if nme
	public static function getSpritesheet(id: String):Null<TilesheetEx>
	{
		#if flash
			if(container.exists(id) && Std.is(container.get(id), SpritesheetAsset)){
				return cast(container.get(id), SpritesheetAsset).getTilesheet();
			}
			else{
				trace("[Assets] There is no Spritesheet asset with an ID of \"" + id + "\"");
			}
			return null;
		#else
			var image: BitmapData = Assets.getBitmapData(id.substr(0, id.lastIndexOf("."))+".png");
			var tilesheet: TilesheetEx = new SparrowTilesheet(image, getText(id));
			return tilesheet;
		#end
	}
	#end

	public static function removeAsset(id:String):Void
	{
		var asset:IAsset = getAsset(id);
		asset.dispose();

		container.remove(id);
		asset.removeEventListener(Event.REMOVED, removedAssetHandler);
	}
}