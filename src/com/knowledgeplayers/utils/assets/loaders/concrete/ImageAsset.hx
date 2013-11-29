package com.knowledgeplayers.utils.assets.loaders.concrete;

#if flash
import flash.system.ImageDecodingPolicy;
import flash.system.LoaderContext;
#end
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import com.knowledgeplayers.utils.assets.loaders.Asset;

class ImageAsset extends Asset {
	private var loader:Loader;

	public function new(?id:String, ?url:String) {
		super(id, url);

		loader = new Loader();
	}

	private function loadEventHandler(event:Event):Void {
		dispatchEvent(event);
	}

	override public function load():Void {
		#if flash
		var loaderContext:LoaderContext = new LoaderContext();
		//loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
		#end

		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadEventHandler);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadEventHandler);
		loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadEventHandler);
		loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadEventHandler);

		#if flash
		loader.load(new URLRequest(url), loaderContext);
		#else
		loader.load(new URLRequest(url));
		#end
	}

	override public function dispose():Void {
		loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadEventHandler);
		loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadEventHandler);
		loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadEventHandler);
		loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadEventHandler);

		if(Std.is(loader.content, Bitmap)){
			getBitmap().bitmapData.dispose();
		}

		#if flash
		loader.close();
		loader.unloadAndStop();
		#end

		loader = null;

		dispatchEvent(new Event(Event.REMOVED));
	}

	public function getBitmap():Bitmap {
		return cast(loader.content, Bitmap);
	}

	public function getSWF():MovieClip {
		return cast(loader.content, MovieClip);
	}
}