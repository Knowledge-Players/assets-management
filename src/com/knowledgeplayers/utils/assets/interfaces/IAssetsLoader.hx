package com.knowledgeplayers.utils.assets.interfaces;

import haxe.FastList;
import flash.events.IEventDispatcher;

interface IAssetsLoader implements IEventDispatcher {

	var total (get_total, null):Int;
	var current (get_current, null):IAsset;

	function dispose():Void;
	function load(list:FastList<IAsset>):Void;

}