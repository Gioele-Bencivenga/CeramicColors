package;

import ceramic.Entity;
import ceramic.Color;
import ceramic.InitSettings;

class Project extends Entity {
	function new(settings:InitSettings) {
		super();

		settings.antialiasing = 2;
		settings.background = Color.BLACK;
		settings.targetWidth = 1280;
		settings.targetHeight = 720;
		settings.scaling = FIT;
		settings.resizable = true;

		app.onceReady(this, ready);
	}

	function ready() {
		// prevent unloading of assets when a scene is destroyed
		// beware that if you load a lot of different assets in different scenes with that option, it will keep every loaded asset in memory even if they are not used anymore.
		app.scenes.keepAssetsForNextMain = true;
		// Set MainScene as the current scene
		app.scenes.main = new ColorScene();
	}
}
