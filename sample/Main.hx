package ;

import flash.Lib;
import flash.display.Bitmap;
import haxe.FastList;
import com.knowledgeplayers.utils.assets.interfaces.IAsset;
import flash.events.ErrorEvent;
import flash.media.Sound;
import flash.display.Bitmap;
import flash.events.SecurityErrorEvent;
import flash.events.IOErrorEvent;
import com.knowledgeplayers.utils.assets.AssetsStorage;
import flash.events.Event;
import com.knowledgeplayers.utils.assets.AssetsConfig;
import com.knowledgeplayers.utils.assets.AssetsLoader;

class Main{

		/**
	 * Assets loader
	 */
	public var loader:AssetsLoader;

		/**
	 * Config file (optional)
	 */
	public var config:AssetsConfig;

	public static function main():Void
	{
		new Main();
	}

	public function new() {
		init();
	}

		/**
	 * Initialize
	 * @param e
	 */
	private function init():Void {

			//assets loader and pass it to storage after load complete
		loader = new AssetsLoader();
		loader.addEventListener(Event.COMPLETE, loadAssetsCompleteHandler, false, 0, true);
		loader.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler, false, 0, true);

		config = new AssetsConfig("config", "assets/assets.xml", null); //load all assets from any group
			//config = new AssetsConfig("config", "./assets/assets.xml", Vector.(["common", "x2"])); //or load particular groups:
		config.addEventListener(Event.COMPLETE, loadConfigCompleteHandler);
		config.addEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
		config.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);
		config.load();
	}

	/**
	 * Assets to load
	 * @param list
	 */
	private function loadAssets(list:FastList<IAsset>):Void {
		loader.load(list);
	}

	/**
	 * Assets have been loaded
	 * @param event
	 */
	private function loadAssetsCompleteHandler(event:Event):Void {
		var git:Bitmap = new Bitmap(AssetsStorage.getBitmapData("octocat"));
		var myXml:Xml = AssetsStorage.getXml("struct");
		var music:Sound = AssetsStorage.getSound("music");

		music.play();
		Lib.current.addChild(git);
		trace(myXml);
	}

		/**
	 * Config file has been loaded
	 * @param event
	 */
	private function loadConfigCompleteHandler(event:Event):Void {
		//load assets
	loadAssets(config.list);

		//clear config
	config.dispose();
	config.removeEventListener(Event.COMPLETE, loadConfigCompleteHandler);
	config.removeEventListener(IOErrorEvent.IO_ERROR, loadErrorHandler);
	config.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loadErrorHandler);
	config = null;
	}

	/**
	 * Error, asset not found!
	 * @param event
	 */
	private function loadErrorHandler(event:ErrorEvent):Void {
		trace("Error: ", event);
	}
}