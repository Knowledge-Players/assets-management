package com.knowledgeplayers.utils.assets.loaders;

#if flash
import flash.errors.IllegalOperationError;
#end
import flash.events.EventDispatcher;
import com.knowledgeplayers.utils.assets.interfaces.IAsset;

class Asset extends EventDispatcher implements IAsset {

	public var id (default, default):String;
	public var url (default, default):String;

	public function new(?id:String, ?url:String) {
		super();
		this.id = id;
		this.url = url;
	}

	public function dispose():Void {
		#if flash
		throw new IllegalOperationError("Error: dispose() is an abstract method. Overwrite it in concrete class.");
		#else
		throw "Error: dispose() is an abstract method. Overwrite it in concrete class.";
		#end
	}

	public function load():Void {
		#if flash
		throw new IllegalOperationError("Error: load() is an abstract method. Overwrite it in concrete class.");
		#else
		throw "Error: dispose() is an abstract method. Overwrite it in concrete class.";
		#end
	}

	override public function toString():String {
		return "[Asset id="+id+", url="+url+"]";
	}
}