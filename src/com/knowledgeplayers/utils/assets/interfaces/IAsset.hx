package com.knowledgeplayers.utils.assets.interfaces;

import flash.events.IEventDispatcher;

interface IAsset implements IEventDispatcher {
	var id (default, default):String;
	var url(default, default):String;

	function load(): Void;
	function dispose(): Void;
}