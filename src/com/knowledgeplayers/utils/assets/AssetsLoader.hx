package com.knowledgeplayers.utils.assets;

import Lambda;
import haxe.FastList;
import com.knowledgeplayers.utils.assets.interfaces.IAsset;
import com.knowledgeplayers.utils.assets.interfaces.IAssetsLoader;

import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.IOErrorEvent;
import nme.events.SecurityErrorEvent;

class AssetsLoader extends EventDispatcher, implements IAssetsLoader {

	public var autoSkip:Bool = false;
	public var total (get_total, null): Int;
	public var current (get_current, null):IAsset;

	private var queue:FastList<IAsset>;
	private var busy:Bool = false;

	public function new()
	{
		super();
		this.queue = new FastList<IAsset>();
	}

	public function load(list:FastList<IAsset>):Void
	{
		for(item in list)
			queue.add(item);

		if(!busy){
			busy = true;
			loadCurrent();
		}
	}

	public function get_total():Int {
		return Lambda.count(queue);
	}

	public function get_current():Null<IAsset> {
		return queue.first();
	}

	public function dispose():Void {

		var asset: IAsset = null;
		while(!queue.isEmpty()){
			asset = queue.pop();
			asset.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			asset.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
			asset.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);
			asset.dispose();
		}

		queue = new FastList<IAsset>();
	}

	private function loadCompleteHandler(e:Event):Void
	{
		var asset:IAsset = cast(e.currentTarget, IAsset);
		AssetsStorage.setAsset(asset);
		queue.pop();

		loadNext();
	}

	private function loadErrorHandler(e:Event):Void {
		dispatchEvent(new IOErrorEvent("An error occuring loading asset " + current.url + (autoSkip ? ". Skip to next asset." : ".")));
		if(autoSkip)
			skip();
	}

	private function loadCurrent():Void {
		var asset:IAsset = current;

		asset.addEventListener(Event.COMPLETE, loadCompleteHandler, false, 0, true);
		asset.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler, false, 0, true);
		asset.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler, false, 0, true);
		asset.load();
	}

	private function skip():Void {
		queue.pop().dispose();

		loadNext();
	}

	private function loadNext():Void {
		if(total > 0){
			if(!AssetsStorage.hasAsset(current.id) && autoSkip){
				dispatchEvent(new IOErrorEvent("An asset " + current.id + " was found in the AssetsStorage. Skip to next asset."));
				skip();
			}else {
				loadCurrent();
			}
		}else {
			busy = false;
			complete();
		}
	}

	private function complete():Void {
		dispatchEvent(new Event(Event.COMPLETE));
	}
}
