package classes;

import ceramic.AssetId;

/**
 * Image class containing an image and feedback sound associated with it.
 */
class MyImage {
	/**
	 * The color of this color.
	 */
	public var image(default, null):String;

	/**
	 * The AssetId of the feedback audio file for this image.
	 */
	public var feedback(default, null):AssetId<String>;

	public function new(_image:String, _feedback:AssetId<String>) {
		image = _image;
		feedback = _feedback;
	}
}
