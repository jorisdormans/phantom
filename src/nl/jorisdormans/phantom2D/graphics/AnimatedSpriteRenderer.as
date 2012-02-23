package nl.jorisdormans.phantom2D.graphics 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AnimatedSpriteRenderer extends PhantomSpriteRenderer
	{
		private var animatedSprite:AnimatedSprite;
		private var currentAnimation:Animation;
		private var currentAnimationFrame:int;
		private var timer:Number;
		private var speed:Number;
		
		
		public function AnimatedSpriteRenderer(sprite:AnimatedSprite, animation:String = null) 
		{
			super(sprite);
			animatedSprite = sprite as AnimatedSprite;
			if (animation) {
				currentAnimation = animatedSprite.getAnimation(animation);
			} else {
				currentAnimation = animatedSprite.getAnimation("default");
			}
			setAnimation(currentAnimation);
		}
		
		private function setAnimation(animation:Animation):void 
		{
			currentAnimation = animation;
			if (currentAnimation) {
				timer = 0;
				speed = currentAnimation.fps;
				currentAnimationFrame = 0;
				frame = currentAnimation.frames[currentAnimationFrame];
				
			} else {
				frame = 0;
			}
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (currentAnimation) {
				timer += speed*elapsedTime;
				if (timer > 1) {
					timer -= 1;
					currentAnimationFrame++;
					currentAnimationFrame %= currentAnimation.frames.length;
					frame = currentAnimation.frames[currentAnimationFrame];
				}
			}
		}
		
		public function startAnimation(name:String, fps:Number = -1):void {
			setAnimation(animatedSprite.getAnimation(name));
			if (fps > 0) {
				speed = fps;
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "startAnimation":
					var fps:Number = -1;
					if (data.fps) fps = data.fps;
					startAnimation(data.name, fps);
					return Phantom.MESSAGE_CONSUMED;
			}
			return super.handleMessage(message, data);
		}
	}

}