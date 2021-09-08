package classes;

import ceramic.AssetId;
import ceramic.Color;

/**
 * Color class containing a color and feedback sound associated with it.
 */
class MyColor {
	/**
	 * The color of this color.
	 */
	public var color(default, null):Color;

	/**
	 * The AssetId of the feedback audio file for this color.
	 */
	public var feedback(default, null):AssetId<String>;

	public function new(_color:Color, _feedback:AssetId<String>) {
		color = _color;
		feedback = _feedback;
	}
}
