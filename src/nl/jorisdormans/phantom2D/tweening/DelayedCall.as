package nl.jorisdormans.phantom2D.tweening 
{
	import nl.jorisdormans.phantom2D.core.Component;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class DelayedCall extends Component
	{
		private var timer:Number;
		private var callBack:Function;
		
		public function DelayedCall(delay:Number, callBack:Function) 
		{
			timer = delay;
			this.callBack = callBack;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			if (timer>0) {
				timer -= elapsedTime;
				if (timer <= 0) {
					if (callBack != null) callBack();
					destroyed = true;
				}
			}
		}
		
	}

}