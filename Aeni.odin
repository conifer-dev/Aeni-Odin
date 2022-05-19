package aeni

import rl "vendor:raylib"
// =============================================== Structs ========================================================= 

// Sprite Type
Sprite :: struct #packed {
	spriteSheet: rl.Texture2D,
	frameDimensions: rl.Vector2,
	scale: rl.Vector2,
	position: rl.Vector2,
	spriteSize: rl.Vector2,
	sourceRect: rl.Rectangle,
	destRect: rl.Rectangle,
}

// Sprite Animation System Data
SpriteAnimation :: struct {
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
	timeSinceStart: f32,
	isAnimationFinished: bool,
}

// =============================================== Procedures ========================================================= 

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
createAnimation :: proc(animationMap: ^map[string]SpriteAnimation, animName: string, sprite: Sprite, origin: rl.Vector2, rotation: f32, startingFrame: u8, endingFrame: u8, column: u8, duration: f32, animSpeed: f32, repeatable: bool, tintColour: rl.Color, debugMode: bool) {
	map_insert(animationMap, animName, SpriteAnimation{
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
		0,
		false,
	})
}

// Main render function for the Sprite Animation system that unlike the Swift version, will accept values from the map "anims"
// that will hold the SpriteAnimator data which will essentially be the animation itself. We will then iterate through the map and render.
render :: proc(anim: ^SpriteAnimation) {

	// Internal sprite type rectangle assigned to renderer
	anim.sprite.sourceRect = rl.Rectangle{f32(anim.startingFrame) * f32(anim.sprite.frameDimensions.x), f32(anim.column) * f32(anim.sprite.frameDimensions.y), anim.sprite.spriteSize.x, anim.sprite.spriteSize.y}
	// Destination rectangle that is responsible for renbdering the position and scale of the Sprite.
	anim.sprite.destRect = rl.Rectangle{anim.sprite.position.x, anim.sprite.position.x, anim.sprite.frameDimensions.x * anim.sprite.scale.x, anim.sprite.frameDimensions.y * anim.sprite.scale.y}
		
	// Rendering the animation.
	rl.DrawTexturePro(anim.sprite.spriteSheet,
		anim.sprite.sourceRect,
		anim.sprite.destRect,
		rl.Vector2{anim.origin.x, anim.origin.y},
		anim.rotation,
		anim.tintColour)
		
	// If debugMode is enabled, we will render a box around the sprite that represents its hitbox for collision detection.
	// Highly recommended to enable in order to find the sweet spot for your origin point... SIZE of the hitbox will have to be re-done as they do seem to be too big for now.
	if anim.debugMode {
		rl.DrawRectangleLines(i32(anim.sprite.position.x), i32(anim.sprite.position.y), i32(anim.sprite.destRect.width), i32(anim.sprite.destRect.height), rl.RED)
	}
}

// Your animation goes bbrrrrrrr.
update :: proc(dt: f32, anim: ^SpriteAnimation) {
		
	// Run only when  animation is not finished.
	if !anim.isAnimationFinished {
		anim.timeSinceStart += dt
		anim.duration -= dt
			
		// Iterarte our startingFrame by one based on the speed provided.
		if anim.timeSinceStart >= anim.animSpeed {
			anim.timeSinceStart = 0
			anim.startingFrame += 1
		}
			
		// If our starting frame is greater than or equal to the ending frame, set it back to 0 and look through until duration reaches 0 unless animation is set as repeatable.
		anim.startingFrame = anim.startingFrame % anim.endingFrame
	}
		
	// If animation is not set as repeatable and once duration is less than or equal to 0, set animation to isFinished bool to true to end the animation.
	if !anim.repeatable && anim.duration <= 0 {
		anim.isAnimationFinished = true
		anim.duration = 0
	}
}

// Flip the sprite based on directional planes.
flipSprite :: proc(horizontal: bool, vertical: bool, anim: ^SpriteAnimation) {
	anim.sprite.spriteSize.x = abs(anim.sprite.spriteSize.x) * (horizontal ? -1 : 1)
	anim.sprite.spriteSize.y = abs(anim.sprite.spriteSize.y) * (vertical ? -1 : 1)
}

// hasCollided procedure require you to provide your a rectangle which in our case will be the destRect from our animation, to make it easier we went ahead and requested that
// an SpriteAnimation is passed as a parameter which internally will take the destRect and run collision check with a rectangle. After all we're checking for rectangle collions...
// As a second parameter you must pass another rectangle, we're requiring rl.Rectangle due to the fact that the second rectangle could be anything! Other sprite or projectile? Who knows.
hasCollided :: proc(firstSprite: SpriteAnimation, rectangle: rl.Rectangle) -> bool {
	if rl.CheckCollisionRecs(firstSprite.sprite.destRect, rectangle) {
		return true	
	} else {
		return false
	}
}

// =============================================== End-Of-File =========================================================  