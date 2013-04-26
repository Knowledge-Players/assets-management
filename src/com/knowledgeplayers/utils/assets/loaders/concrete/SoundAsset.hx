package com.knowledgeplayers.utils.assets.loaders.concrete;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.media.Sound;
import flash.net.URLRequest;
import com.knowledgeplayers.utils.assets.loaders.Asset;

class SoundAsset extends Asset {

	private var loader:Sound;

	public function new(?id:String, ?url:String) {
		super(id, url);
		loader = new Sound();
	}

	private function loadEventHandler(event:Event):Void {
		dispatchEvent(event);
	}

	override public function load():Void {
		loader.addEventListener(Event.COMPLETE, loadEventHandler);
		loader.addEventListener(IOErrorEvent.IO_ERROR, loadEventHandler);
		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadEventHandler);
		loader.addEventListener(ProgressEvent.PROGRESS, loadEventHandler);

		loader.load(new URLRequest(url));
	}

	override public function dispose():Void {
		loader.removeEventListener(Event.COMPLETE, loadEventHandler);
		loader.removeEventListener(IOErrorEvent.IO_ERROR, loadEventHandler);
		loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadEventHandler);
		loader.removeEventListener(ProgressEvent.PROGRESS, loadEventHandler);
		loader.close();

		loader = null;

		dispatchEvent(new Event(Event.REMOVED));
	}

	public function getSound():Sound {
		return loader;
	}
}