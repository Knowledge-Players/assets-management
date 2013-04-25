package com.knowledgeplayers.utils.assets.loaders.concrete;

import nme.events.Event;
import nme.events.IOErrorEvent;
import nme.events.ProgressEvent;
import nme.events.SecurityErrorEvent;
import nme.net.URLLoader;
import nme.net.URLLoaderDataFormat;
import nme.net.URLRequest;
import com.knowledgeplayers.utils.assets.loaders.Asset;

class TextAsset extends Asset {
	private var loader:URLLoader;

	public function new(?id:String, ?url:String)
	{
		super(id, url);

		loader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.TEXT;
	}

	private function loadEventHandler(event:Event):Void
	{
		dispatchEvent(new Event(Event.COMPLETE));
	}

	override public function load():Void {
		loader.addEventListener(Event.COMPLETE, loadEventHandler);
		//loader.addEventListener(ProgressEvent.PROGRESS, loadEventHandler);
		loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

		loader.load(new URLRequest(url));
	}

	private function onError(e:Event):Void
	{
		nme.Lib.trace("Error during TextAsset loading: "+e);
	}

	override public function dispose():Void {
		loader.removeEventListener(Event.COMPLETE, loadEventHandler);
		loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		loader.removeEventListener(ProgressEvent.PROGRESS, loadEventHandler);

		loader.close();

		loader = null;

		dispatchEvent(new Event(Event.REMOVED));
	}

	public function getText(): String {
		return cast(loader.data, String);
	}

	public function getXml():Xml {
		return Xml.parse(getText());
	}
}