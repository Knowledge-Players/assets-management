package com.knowledgeplayers.utils.assets;

import haxe.ds.GenericStack;
import com.knowledgeplayers.utils.assets.interfaces.IAsset;
import com.knowledgeplayers.utils.assets.interfaces.IAssetsLoader;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;

class AssetsLoader extends EventDispatcher implements IAssetsLoader {

	public var total (default, null):Int;

	private var loaded:Int = 0;

	public function new()
	{
		super();
	}

	public function load(list:GenericStack<IAsset>):Void
	{
		total = Lambda.count(list);
		for(asset in list){
			asset.addEventListener(Event.COMPLETE, loadCompleteHandler, false, 0, true);
			asset.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler, false, 0, true);
			asset.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler, false, 0, true);
			asset.load();
		}
	}

	private function loadCompleteHandler(e:Event):Void
	{
		var asset:IAsset = cast(e.currentTarget, IAsset);
		AssetsStorage.setAsset(asset);
		asset.removeEventListener(Event.COMPLETE, loadCompleteHandler);
		asset.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
		asset.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);
		loaded++;
		if(total == loaded){
			complete();
		}
	}

	private function loadErrorHandler(e:Event):Void
	{
		dispatchEvent(new IOErrorEvent("An error occuring loading asset " + cast(e.target, IAsset).url + "."));
	}

	private function complete():Void
	{
		dispatchEvent(new Event(Event.COMPLETE));
	}
}
