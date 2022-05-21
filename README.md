<p align="center">
  <img src="https://i.imgur.com/uYwVATH.png" />
</p>

# About
*A simple spritesheet animation system* based on [Aeni for Swift](https://github.com/conifer-dev/Aeni) Ported over to Odin!

Aeni allows you to quickly and easily animate your spritesheet with uniform dimensions in your Raylib for Odin project! It divides the process into two simple steps to create a working animation.

*Aeni is a shortened word for *"aenimeisheon"* in Korean which translates to "Animation".*

I would like to remind the potential users that this is a barebones & simplistic spritesheet animation library meant for small games, learning how to develop games with Raylib or game jams, not **professional game development.** 

Instructions
=====
Getting Aeni set up and running is easy, firstly make sure you import it into your code:

```odin
import "aeni"
```

The creation of the animation from your spritesheet is split into two parts. Firstly you have to create a sprite using createSprite procedure that takes in a spritesheet (Texture2D), frame dimensions (as Vector2), and the scale (as Vector2) which is later used to determine its size if need be, and lastly the position (as Vector2).

Once our Sprite is created, we can start animating it by passing a createAnimation procedure with the requested parameters. All Animations need to be stored in a map of SpriteAnimation (you will see in an example below how to do that if you're unsure.)

Check the example below to see how to easily set it up:

```odin
package main

import rl "vendor:raylib"
import "aeni"

main :: proc() {

  rl.InitWindow(800, 400, "Aeni Example")
  defer rl.CloseWindow()
  rl.SetTargetFPS(60)

  // Creating our map that will hold our animations.
  animations := make(map[string]aeni.SpriteAnimation)
  defer delete(animations)

  // We're loading our texture here.
  spriteSheet: rl.Texture2D = rl.LoadTexture("PlayerSheet.png")
  defer rl.UnloadTexture(spriteSheet)

  // Let's hold our sprites in an array for simplicity.You can of course optout from placing it in array and create them as variables!
  spriteArray := [dynamic]aeni.Sprite{ aeni.createSprite(spriteSheet, rl.Vector2{24, 24}, rl.Vector2{2, 2}, rl.Vector2{50, 50}) }
  defer delete(spriteArray)

  // Passing the createAnimation procedure with the required parameters, as you can see our sprite is passed through. Those two animations are created from a single sprite, one plays the idle animation while other plays the running animation.
  aeni.createAnimation(&animations, "idle", spriteArray[0], rl.Vector2{0, 3}, 0, 0, 4, 0, 0, 0.13, true, rl.WHITE, true) 
  aeni.createAnimation(&animations, "run", spriteArray[0], rl.Vector2{0, 3}, 0, 0, 6, 1, 0, 0.11, true, rl.WHITE, true)

  // We select our current animation.
  currentAnim := animations["run"]

  for !rl.WindowShouldClose() {
    deltaTime := rl.GetFrameTime()
    rl.BeginDrawing()

      rl.ClearBackground(rl.RAYWHITE)

      // Here we pass the aeni.render() procedure which takes in ^SpriteAnimation, which would be one of our animations from our animations map.
      aeni.render(&currentAnim)
      // Time to pass through the aeni.update() procedure! This will allow us to play the animation. It requires delta time as f32 and our animation (^SpriteAnimation) we want to update.
      aeni.update(deltaTime, &currentAnim)

    rl.EndDrawing()
  }

}
```

A very barebones example of how to get Aeni running! Yes, this is all you need!

Let's go through Sprite and SpriteAnimator one by one and the properties mean:

### Sprite

| Property    | Example               | Description                                                                                                                                                                               |
| ----------|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| __spriteSheet - Texture2D__ | `spriteSheet`  | Required path to the spritesheet itself.
| __frameDimensions - Vector2__ | `rl.Vector2(x: 24, y: 24)`   | These are the dimensions of the animation frames stored in a Vector2 type, x representing width and y representing height. These dimensions will be the same size as your character. In our example, the character is 24x24. |
| __scale - Vector2__   | `rl.Vector2(x: 2, y: 2)` | The scale represents how much we would like to scale up our sprite by. If you don't want to scale up your sprite you can simply put 1 on both x & y.                                              |
| __position - Vector2__ | `rl.Vector2(x: 50, y: 50)`  | Position property represents the location of your sprite, its x & y properties can be used to move the sprite in your window/game.| 


### Sprite Animation

| Property    | Example               | Description                                                                                                                                                                               |
| ----------|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| __animationMap - ^map[string]SpriteAnimation__ | `&animations`  | Passing the map where our animations will be inserted.
| __animName - string__ | `"idle"`  | Name of our animation.
| __sprite - Sprite__ | `player (or in our example spriteArray[0])`  | Sprite type required to for the Sprite Animation to work.
| __origin - Vector2__ | `Vector2(x: 0, y: 3)`   | The origin point of the Sprite (rotation/scale point and your hitboxes) will usually be 0 on both axies, however. It's worth nothing that this highly depends on your sprite. Its highly recommended to turn on debug mode and align your origin appropriately. |
| __rotation - f32__ | `0`  | A value that determines the rotation of our animation. If you were to for example pass delta time, it would constantly rotate, if you don't want it to rotate, pass 0 as value.
| __startingFrame - u8__   | `0` | The starting point of your animation.                                              |
| __endingFrame - u8__ | `4`  | The last frame in the row of your animation is where your animation will end or begin looping through if repeatable is set to true.| 
| __column - u8__ | `0`  | Which column you would like to animate through. Every spritesheet starts from 0, therefore your first row of animation will be on column 0.| 
| __duration - f32__ | `3`  | How long you would like your animation to last. It's counted in seconds. If repeatable flag is set to true, duration will be ignored!| 
| __animationSpeed - f32__ | `0.13`  | How fast you would like to have your sprite to be animated.| 
| __repeatable - bool__ | `true`  | This value when set to true will loop your animation.| 
| __tintColor - rl.Color__ | `rl.WHITE`  | Tint color of your sprite, if you don't want to include any, use white.| 
| __debugMode - bool__ | `true`  | Debug mode will render out the destination rectangle/hitbox of your animation.| 

Future plans
=====
There are many things I want to add to Aeni. If you have any suggestions on what to add please let me know and I will do my best!

Closing notes
=====
This is a port from [Aeni for Swift](https://github.com/conifer-dev/Aeni) which I will sadly no longer be working on due to the fact that Swift development outside Apples ecosystem is disastrous.
