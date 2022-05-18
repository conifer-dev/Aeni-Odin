package aeni

import rl "vendor:raylib"

timeSinceStart:f32 = 0
isAnimationFinished: bool = false

// Sprite Type
Sprite :: struct {
	spriteSheet: rl.Texture2D,
	frameDimensions: rl.Vector2,
	scale: rl.Vector2,
	position: rl.Vector2,
	spriteSize: rl.Vector2,
	sourceRect: rl.Rectangle,
	destRect: rl.Rectangle,
}

// Sprite Animation System Data
SpriteAnimator :: struct {
	sprite: Sprite,
	origin: rl.Vector2,
	rotation: f32,
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
		frameDimensions,
		rl.Rectangle{},
		rl.Rectangle{},
	}
}

// Create and insert element of SpriteAnimator to the passed map which will hold the animations for the sprite.
// Overall, this procedure creates the animation from the spritesheet.
createAnimation :: proc(animationMap: ^map[string]SpriteAnimator, animName: string, sprite: Sprite, origin: rl.Vector2, rotation: f32, startingFrame: u8, endingFrame: u8, column: u8, duration: f32, animSpeed: f32, repeatable: bool, tintColour: rl.Color, debugMode: bool) {
	map_insert(animationMap, animName, SpriteAnimator{
		sprite,
		origin,
		rotation,
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
render :: proc(animMap: ^map[string]SpriteAnimator) {
// PURELY EXPERIMENTAL AND UNTESTED. ONLY ODIN KNOWS IF THIS WILL WORK.
	for _, anim in animMap {
		anim.sprite.sourceRect = rl.Rectangle{f32(anim.startingFrame) * f32(anim.sprite.frameDimensions.x), f32(anim.column) * f32(anim.sprite.frameDimensions.y), f32(anim.sprite.spriteSize.x), f32(anim.sprite.spriteSize.y)}
		anim.sprite.destRect = rl.Rectangle{anim.sprite.position.x, anim.sprite.position.x, anim.sprite.frameDimensions.x * anim.sprite.scale.x, anim.sprite.frameDimensions.y * anim.sprite.scale.y}
		
		rl.DrawTexturePro(anim.sprite.spriteSheet,
		anim.sprite.sourceRect,
		anim.sprite.destRect,
		rl.Vector2{anim.origin.x, anim.origin.y},
		anim.rotation,
		anim.tintColour)
	}
}
