package classes;

import ceramic.AssetId;

/**
 * Image class containing an image and feedback sound associated with it.
 */
class MyImage {
	/**
	 * The image of this image.
	 */
	public var image(default, null):AssetId<String>;

	/**
	 * The AssetId of the feedback audio file for this image.
	 */
	public var feedback(default, null):AssetId<String>;

	public function new(_image:AssetId<String>, _feedback:AssetId<String>) {
		image = _image;
		feedback = _feedback;
	}
}
