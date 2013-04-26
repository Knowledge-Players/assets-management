package com.knowledgeplayers.utils.assets.loaders.concrete;

import flash.display.BitmapData;
import aze.display.SparrowTilesheet;
import haxe.xml.Fast;
import aze.display.TilesheetEx;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import com.knowledgeplayers.utils.assets.loaders.Asset;

class SpritesheetAsset extends TextAsset {
	private var tilesheet:TilesheetEx;

	public function new(?id:String, ?url:String)
	{
		super(id, url);
	}

	override private function loadEventHandler(event:Event):Void
	{
		var fast = new Fast(getXml().firstElement());
		var image: ImageAsset = new ImageAsset(id+"_image", fast.att.imagePath);

		image.addEventListener(Event.COMPLETE, onImageLoaded, false, 0, true);
		image.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
		image.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
		image.load();
	}

	override public function dispose():Void
	{
		tilesheet = null;
		super.dispose();
	}

	public function getTilesheet():TilesheetEx
	{
		return tilesheet;
	}

	private function onImageLoaded(e: Event):Void
	{
		var image: BitmapData = e.target.getBitmap().bitmapData;
		tilesheet = new SparrowTilesheet(image, getText());
		dispatchEvent(new Event(Event.COMPLETE));
	}
}