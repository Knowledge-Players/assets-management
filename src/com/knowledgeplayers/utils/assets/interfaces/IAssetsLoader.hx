package com.knowledgeplayers.utils.assets.interfaces;

import haxe.ds.GenericStack;
import flash.events.IEventDispatcher;

interface IAssetsLoader extends IEventDispatcher {

	var total (default, null):Int;

	function load(list:GenericStack<IAsset>):Void;

}