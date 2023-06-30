Astrum is a multi-purpose love2d library made to simply the process of creating multi-platform apps (or possibly games) with love2d.



Notes:

When included in a project, all files contained here should be placed in a folder called "lib" placed next to the main.lua file. This behaviour may change to be dynamic in the future
When assets are required in a project, asset files should be placed in an "asset" folder placed next to the main.lua file
Script files placed in "asset/script" folder are ran as love2d threads, and should return any laoded assets to the named love2d channel "assets" in the following table format:
{
category="exampleCategory",
id="exampleAssetID",
asset=loadedAsset
}
category and id must be string values. 
asset may be of any type supported by love2d channels except for nil (because that would be pointless)

