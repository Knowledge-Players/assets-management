ExAM (assets-management port)
=============================

Assets management for Haxe/NME. Very similar to nme.Assets but don't embed assets in the SWF (for smaller files).

Prepare your assets
===================

With ExAM, you organize your library in an XML file. You can specify groups of assets to manage multi-resolution assets.
To create the XML file, use the script generateAssets.sh :
  `./generateAssets.sh $ASSETS_DIR $OUTPUT_FILE`
where $ASSETS_DIR is the directory where you store your assets and $OUTPUT_FILE is the name of your XML library that will be created (if the file exists, it will be crushed !).

Use your assets
===============

Basically, you will have to create an AssetsConfig instance which will link to your XML library. Then, give it to an AssetsLoader object, aaaand done !
When you receive the "go" signal (an Event.COMPLETE), your assets will be waiting for you in the AssetsStorage static class: `AssetsStorage.getAsset(id)`

Typed assets
------------

If you know the type of an asset, you can use specific functions: 
* getBitmapData(id: String): BitmapData
* getText(id: String): String
* getXml(id: String): Xml
* getSound(id: String): Sound

Try it yourself
===============

Go see the example in the sample directory. You can compile it with juste Haxe, or with NME.

**Special thanks to Krecha Games for the original library**
