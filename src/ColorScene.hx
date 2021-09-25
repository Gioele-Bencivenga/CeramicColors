import ceramic.AssetId;
import classes.MyColor;
import ceramic.Key;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Scene;

using ceramic.Extensions;
using ceramic.VisualTransition;
using classes.Utilities;

class ColorScene extends Scene {
	/**
	 * Image displaying the `currentColor`.
	 */
	var currentColorQuad:Quad;

	/**
	 * How much the `currentColorQuad` rotates over time.
	 */
	var rotationAmount:Int;

	/**
	 * Whether the `currentColorQuad` rotates clockwise or anticlockwise.
	 */
	var rotateClockwise:Bool;

	var red:MyColor;
	var green:MyColor;
	var blue:MyColor;
	var yellow:MyColor;

	/**
	 * Color currently being displayed.
	 */
	var currentColor:MyColor;

	/**
	 * The list of color possibilities that might be assigned to the `currentColor`.
	 */
	var possibleColors:Array<MyColor>;

	/**
	 * Sound played when the `currentColor` is changed.
	 */
	var colorChangeSound:AssetId<String>;

	/**
	 * Called when the scene is preloading, before `create()`.
	 */
	override function preload() {
		assets.add(Images.CERAMIC);
		// load statically generated sounds from assets
		assets.add(Sounds.SOUNDS__COLORS__RED);
		assets.add(Sounds.SOUNDS__COLORS__GREEN);
		assets.add(Sounds.SOUNDS__COLORS__BLUE);
		assets.add(Sounds.SOUNDS__COLORS__YELLOW);
		// color change sound
		assets.add(Sounds.SOUNDS__CHANGE);
	}

	override function create() {
		// created color change sound
		colorChangeSound = Sounds.SOUNDS__CHANGE;
		// create colors with associated feedback sound
		red = new MyColor(Color.RED, Sounds.SOUNDS__COLORS__RED);
		green = new MyColor(Color.GREEN, Sounds.SOUNDS__COLORS__GREEN);
		blue = new MyColor(Color.BLUE, Sounds.SOUNDS__COLORS__BLUE);
		yellow = new MyColor(Color.YELLOW, Sounds.SOUNDS__COLORS__YELLOW);

		// set possible colors to created colors
		possibleColors = [red, green, blue, yellow];

		// start out with a random color from the possible ones
		currentColor = possibleColors.randomElement();

		// create quad (polygon made of 2 triangles)
		currentColorQuad = new Quad();
		// assign current color to quad
		currentColorQuad.color = currentColor.color;
		// set size using method (can also set only width or height)
		currentColorQuad.size(height, height);
		// set anchor to quad center (default is top left)
		currentColorQuad.anchor(0.5, 0.5);
		// position quad to center of scene
		currentColorQuad.pos(width * 0.5, height * 0.5);
		// add quad as child of scene
		add(currentColorQuad);

		rotationAmount = 60;

		input.onKeyDown(this, handleKeyPressed);
	}

	/**
	 * Code in here is executed at every frame after `create()` has been called and scene is not paused.
	 * @param delta the amount of elapsed time since last frame, in seconds
	 */
	override function update(delta:Float) {
		if (rotateClockwise) {
			currentColorQuad.rotation += delta * rotationAmount;
		} else {
			currentColorQuad.rotation -= delta * rotationAmount;
		}
	}

	override function resize(width:Float, height:Float) {
		// Called everytime the scene size has changed
	}

	override function destroy() {
		// Perform any cleanup before final destroy

		super.destroy();
	}

	function handleKeyPressed(_key:Key) {
		switch (_key.keyCode) {
			case SPACE:
				givePrompt();
			case RIGHT:
				changeCurrentColor();
			case ENTER:
				giveFeedback();
			case LCTRL:
				app.scenes.main = new LetterScene();
			case anythingElse:
		}
	}

	function givePrompt() {
		moveCurrentColor();
	}

	function changeCurrentColor() {
		var newColor = possibleColors.randomElement(); // get new random color
		if (newColor == currentColor) { // diminish the possibility of having the same color while still keeping it possible
			newColor = possibleColors.randomElement();
		}
		currentColor = newColor; // assign new color to current
		currentColorQuad.color = currentColor.color; // update quad color with current color
		assets.sound(colorChangeSound).play(); // play change sound
		moveCurrentColor();
	}

	function giveFeedback() {
		assets.sound(currentColor.feedback).play();
	}

	function moveCurrentColor() {
		// use transition API to move the quad at a random position/scale/rotation
		currentColorQuad.transition(LINEAR, 0.1, currentColorQuad -> {
			currentColorQuad.x = width * (0.1 + Math.random() * 0.8);
			currentColorQuad.y = height * (0.1 + Math.random() * 0.8);
			currentColorQuad.scaleX = 1 * (0.2 + 0.8 * Math.random());
			currentColorQuad.scaleY = currentColorQuad.scaleX;
			currentColorQuad.rotation = 360 * Math.random();
		});
		// change rotation direction
		rotateClockwise = !rotateClockwise;
	}
}
