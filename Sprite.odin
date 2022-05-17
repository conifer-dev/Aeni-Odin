package aeni

import rl "vendor:raylib"

@(private)
spriteSize: rl.Vector2

timeSinceStart:f32 = 0
isAnimationFinished: bool = false

// Sprite Type
Sprite :: struct {
	spriteSheet: rl.Texture2D,
	frameDimensions: rl.Vector2,
	scale: rl.Vector2,
	position: rl.Vector2,
	sourceRect: rl.Rectangle,
	destRect: rl.Rectangle,
}

// Sprite Animation System Data
SpriteAnimator :: struct {
	sprite: Sprite,
	origin: rl.Vector2,
	startingFrame: u8,
	endingFrame: u8,
	column: u8,
	duration: f32,
	animSpeed: f32,
	repeatable: bool,
	tintColour: rl.Color,
	debugMode: bool,
}

// Creates and returns a Sprite based on parameters provided which will be then passed to the SpriteAnimator.
createSprite :: proc(spriteSheet: rl.Texture2D, frameDimensions: rl.Vector2, scale: rl.Vector2, position: rl.Vector2) -> Sprite {
	return Sprite{
		spriteSheet,
		frameDimensions,
		scale,
		position,
		rl.Rectangle{},
		rl.Rectangle{},
	}
}

// Create and insert element of SpriteAnimator to the passed map which will hold the animations for the sprite.
// Overall, this procedure creates the animation from the spritesheet.
createAnimation :: proc(animationMap: ^map[string]SpriteAnimator, animName: string, sprite: Sprite, origin: rl.Vector2, startingFrame: u8, endingFrame: u8, column: u8, duration: f32, animSpeed: f32, repeatable: bool, tintColour: rl.Color, debugMode: bool) {
	map_insert(animationMap, animName, SpriteAnimator{
		sprite,
		origin,
		startingFrame,
		endingFrame,
		column,
		duration,
		animSpeed,
		repeatable,
		tintColour,
		debugMode,
	})
}

// Main render function for the Sprite Animation system that unlike the Swift version, will accept values from the map "anims"
// that will hold the SpriteAnimator data which will essentially be the animation itself. We will then iterate through the map and render.
render :: proc() {
	
}