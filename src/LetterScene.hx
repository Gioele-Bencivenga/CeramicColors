import ceramic.AssetId;
import classes.MyColor;
import ceramic.Key;
import ceramic.Quad;
import ceramic.Color;
import ceramic.Scene;

using ceramic.Extensions;
using ceramic.VisualTransition;
using classes.Utilities;

class LetterScene extends Scene {
	/**
	 * Image displaying the `currentImage`.
	 */
	var currentImageQuad:Quad;

	/**
	 * How much the `currentColorQuad` rotates over time.
	 */
	var rotationAmount:Int;

	/**
	 * Whether the `currentColorQuad` rotates clockwise or anticlockwise.
	 */
	var rotateClockwise:Bool;

	var apple:MyImage;
	var cat:MyImage;
	var fish:MyImage;
	var moon:MyImage;
	var pig:MyImage;
	var rocket:MyImage;

	/**
	 * Image currently being displayed.
	 */
	var currentImage:MyImage;

	/**
	 * The list of color possibilities that might be assigned to the `currentImage`.
	 */
	var possibleImages:Array<MyImage>;

	/**
	 * Sound played when the `currentImage` is changed.
	 */
	var imageChangeSound:AssetId<String>;

	/**
	 * Called when the scene is preloading, before `create()`.
	 */
	override function preload() {
		assets.add(Images.CERAMIC);
        // load images
		assets.add(Images.IMAGES__LETTERS__A);
		assets.add(Images.IMAGES__LETTERS__C);
		assets.add(Images.IMAGES__LETTERS__F);
		assets.add(Images.IMAGES__LETTERS__M);
		assets.add(Images.IMAGES__LETTERS__P);
		assets.add(Images.IMAGES__LETTERS__R);
		// load statically generated sounds from assets
		assets.add(Sounds.SOUNDS__COLOR_CHANGE);
		assets.add(Sounds.SOUNDS__RED);
		assets.add(Sounds.SOUNDS__GREEN);
		assets.add(Sounds.SOUNDS__BLUE);
		assets.add(Sounds.SOUNDS__ORANGE);
	}

	override function create() {
		// created color change sound
		colorChangeSound = Sounds.SOUNDS__COLOR_CHANGE;
		// create colors with associated feedback sound
		apple = new MyImage(Color.RED, Sounds.SOUNDS__RED);
		cat = new MyImage(Color.GREEN, Sounds.SOUNDS__GREEN);
		fish = new MyImage(Color.BLUE, Sounds.SOUNDS__BLUE);
		moon = new MyImage(Color.ORANGE, Sounds.SOUNDS__ORANGE);
		pig = new MyImage(Color.ORANGE, Sounds.SOUNDS__ORANGE);
		rocket = new MyImage(Color.ORANGE, Sounds.SOUNDS__ORANGE);

		// set possible colors to created colors
		possibleImages = [apple, cat, fish, moon, pig, rocket];

		// start out with a random color from the possible ones
		currentImage = possibleImages.randomElement();

		// create quad (polygon made of 2 triangles)
		currentImageQuad = new Quad();
        currentImageQuad.texture = assets.texture(Images.HAXE_LOGO);
		// set size using method (can also set only width or height)
		currentImageQuad.size(height, height);
		currentImageQuad.color = currentImage.color;
		// set anchor to quad center (default is top left)
		currentImageQuad.anchor(0.5, 0.5);
		// position quad to center of scene
		currentImageQuad.pos(width * 0.5, height * 0.5);
		// add quad as child of scene
		add(currentImageQuad);

		rotationAmount = 60;

		input.onKeyDown(this, handleKeyPressed);
	}

	/**
	 * Code in here is executed at every frame after `create()` has been called and scene is not paused.
	 * @param delta the amount of elapsed time since last frame, in seconds
	 */
	override function update(delta:Float) {
		if (rotateClockwise) {
			currentImageQuad.rotation += delta * rotationAmount;
		} else {
			currentImageQuad.rotation -= delta * rotationAmount;
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
				changeCurrentImage();
			case ENTER:
				giveFeedback();
			case anythingElse:
		}
	}

	function givePrompt() {
		moveCurrentImage();
	}

	function changeCurrentImage() {
		var newImage = possibleImages.randomElement(); // get new random image
		if (newImage == currentImage) { // diminish the possibility of having the same image while still keeping it possible
			newImage = possibleImages.randomElement();
		}
		currentImage = newImage; // assign new image to current
		currentImageQuad.color = currentImage.color; // update quad image with current image
		assets.sound(imageChangeSound).play(); // play change sound
		moveCurrentImage();
	}

	function giveFeedback() {
		assets.sound(currentImage.feedback).play();
	}

	function moveCurrentImage() {
		// use transition API to move the quad at a random position/scale/rotation
		currentImageQuad.transition(LINEAR, 0.1, currentImageQuad -> {
			currentImageQuad.x = width * (0.1 + Math.random() * 0.8);
			currentImageQuad.y = height * (0.1 + Math.random() * 0.8);
			currentImageQuad.scaleX = 1 * (0.2 + 0.8 * Math.random());
			currentImageQuad.scaleY = currentImageQuad.scaleX;
			currentImageQuad.rotation = 360 * Math.random();
		});
		// change rotation direction
		rotateClockwise = !rotateClockwise;
	}
}
