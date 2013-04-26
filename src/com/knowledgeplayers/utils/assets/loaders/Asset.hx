package com.knowledgeplayers.utils.assets.loaders;

import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import com.knowledgeplayers.utils.assets.interfaces.IAsset;

class Asset extends EventDispatcher, implements IAsset {

	public var id (default, default):String;
	public var url (default, default):String;

	public function new(?id:String, ?url:String) {
		super();
		this.id = id;
		this.url = url;
	}

	public function dispose():Void {
		throw new IllegalOperationError("Error: dispose() is an abstract method. Overwrite it in concrete class.");
	}

	public function load():Void {
		throw new IllegalOperationError("Error: load() is an abstract method. Overwrite it in concrete class.");
	}

	override public function toString():String {
		return "[Asset id="+id+", url="+url+"]";
	}
}