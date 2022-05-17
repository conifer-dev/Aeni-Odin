package aeni

import rl "vendor:raylib"

@(private)
spriteSize: rl.Vector2

anims := make(map[string]Sprite)
timeSinceStart:f32 = 0

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
	animationSpeed: f32,
	repeatable: bool,
	tintColor: rl.Color,
	debugMode: bool,
}

memoryCleanup :: proc() {
	delete(anims)
}