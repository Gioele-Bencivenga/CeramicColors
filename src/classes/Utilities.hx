package classes;

class Utilities {
	/**
	 * Not needed anymore, use `ceramic.Extensions` `array.randomElement()`.  
	 * Returns a random color from the color array.
	 * @param _array the color array containing the color possibilities
	 */
	public static function random(_array:Array<MyColor>) {
		// generate random number between 0 and `array.length`
		var rNum = Std.random(_array.length);
		// return color at index `rNum`
		return _array[rNum];
	}
}
