package nl.jorisdormans.phantom2D.graphics 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AnimatedSprite extends PhantomSprite
	{
		private var animations:Dictionary;
		private var defaultAnimation:Animation;
		
		public function AnimatedSprite( img:Class, width:int, height:int ) 
		{
			super(img, width, height);
			animations = new Dictionary();
		}
		
		public function addAnimation(name:String, fps:Number, ... frames):void {
			var f:Vector.<int> = new Vector.<int>();
			for (var i:int = 0; i < frames.length; i++) {
				f.push(parseInt(frames[i]));
			}
			var animation:Animation = new Animation(fps, f);
			animations[name] = animation;
			if (!defaultAnimation) defaultAnimation = animation;
		}
		
		public function getAnimation(name:String):Animation {
			if (animations[name] != null) return animations[name];
			else return defaultAnimation;
		}
		
	}

}