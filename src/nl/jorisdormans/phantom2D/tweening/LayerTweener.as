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
		private var start:Object;
		private var end:Object;
		private var current:Number;
		private var speed:Number;
		private var delay:Number;
		private var tweenFunction:Function;
		private var layer:Layer;
		private var target:Number;
		
		
		public function LayerTweener(start:Object, end:Object, time:Number = 1, delay:Number = 0, tweenFunction:Function = null) 
		{
			this.start = start;
			this.end = end;
			this.speed = 1/time;
			this.delay = delay;
			this.tweenFunction = tweenFunction;
			current = 0;
			target = 1;
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
			return start + (end - start) * MathUtil.clamp(f, 0, 1);
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
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			var d:Number = MathUtil.clamp(target - current, -elapsedTime * speed, elapsedTime * speed);
			if (d != 0) {
				current += d;
				doTween(current);
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "resetTween":
					target = 1;
					current = 0;
					doTween(current);
					return Phantom.MESSAGE_HANDLED;
				case "reverseTween":
					target = 1 - target;
					return Phantom.MESSAGE_HANDLED;
				case "setTweenTime":
					speed = 1/data.time;
					return Phantom.MESSAGE_HANDLED;
					
			}
			return super.handleMessage(message, data);
			
		}
		
		
		
	}

}