package nl.jorisdormans.phantom2D.tweening 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class LayerTweener extends Component
	{
		public static const P_IS_TWEENING:String = "isTweening";
		public static const M_RESET_TWEEN:String = "resetTween";
		public static const M_REVERSE_TWEEN:String = "reverseTween";
		public static const M_SET_TWEEN_TIME:String = "setTweenTime";
		public static const M_SET_TWEEN_DELAY:String = "setTweenDelay";
		public static const M_PAUSE:String = "pauseTween";
		public static const M_CONTINUE:String = "continueTween";
		public static const M_START:String = "startTween";
		
		private var start:Object;
		private var end:Object;
		private var current:Number;
		private var speed:Number;
		private var delay:Number;
		private var tweenFunction:Function;
		private var layer:Layer;
		private var target:Number;
		private var onFinish:Function;
		private var onReversed:Function;
		
		private var paused:Boolean;
		
		public function LayerTweener(start:Object, end:Object, time:Number = 1, delay:Number = 0, tweenFunction:Function = null, onFinish:Function = null, onReverse:Function = null) 
		{
			this.start = start;
			this.end = end;
			this.speed = 1/time;
			this.delay = delay;
			this.tweenFunction = tweenFunction;
			this.onFinish = onFinish;
			this.onReversed = onReverse;
			current = 0;
			target = 1;
			paused = false;
			if (this.tweenFunction == null) this.tweenFunction = TweenFunctions.sine;
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			layer = composite as Layer;
			if (!layer) {
				throw(new Error("LayerTweener added to an object that is not a Layer"));
			}
			doTween(0);
		}
		
		private function interpolate(start:Number, end:Number, f:Number):Number {
			return start + (end - start) * f;
		}
		
		private function doTween(value:Number):void {
			if (tweenFunction != null) value = tweenFunction(value);
			if (start.alpha != undefined && end.alpha != undefined ) {
				layer.sprite.alpha = interpolate(start.alpha, end.alpha, value);
			}
			if (start.x != undefined && end.x != undefined ) {
				layer.sprite.x = interpolate(start.x, end.x, value);
			}
			if (start.y != undefined && end.y != undefined ) {
				layer.sprite.y = interpolate(start.y, end.y, value);
			}
			if (start.scale != undefined && end.scale != undefined ) {
				layer.sprite.scaleX = layer.sprite.scaleY = interpolate(start.scale, end.scale, value);
			}
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (paused) return;
			if (delay > 0) {
				delay -= elapsedTime;
			} else {
				var d:Number = MathUtil.clamp(target - current, -elapsedTime * speed, elapsedTime * speed);
				if (d != 0) {
					current += d;
					doTween(current);
					//callbacks?
					if (current == target) {
						if (target == 1 && onFinish != null) {
							 onFinish();
						}
						if (target == 0 && onReversed != null) {
							 onReversed();
						}
					}
				}
			}
		}
		
		
		override public function getProperty(property:String, componentClass:Class = null):Object 
		{
			if (property == P_IS_TWEENING) {
				if (current != target) return true;
				else return null;
			}
			return super.getProperty(property, componentClass);
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case M_RESET_TWEEN:
					target = 1;
					current = 0;
					doTween(current);
					return Phantom.MESSAGE_HANDLED;
				case M_REVERSE_TWEEN:
					target = 1 - target;
					return Phantom.MESSAGE_HANDLED;
				case M_SET_TWEEN_TIME:
					speed = 1/data.time;
					return Phantom.MESSAGE_HANDLED;
				case M_SET_TWEEN_DELAY:
					delay = data.delay;
					return Phantom.MESSAGE_HANDLED;
				case M_START:
					target = 1;
					current = 0;
					paused = false;
					return Phantom.MESSAGE_HANDLED;
				case M_PAUSE:
					paused = true;
					return Phantom.MESSAGE_HANDLED;
				case M_CONTINUE:
					paused = false;
					return Phantom.MESSAGE_HANDLED;
					
			}
			return super.handleMessage(message, data);
			
		}
		
		
		
	}

}