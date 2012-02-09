package nl.jorisdormans.phantom2D.objects.misc 
{
	import nl.jorisdormans.phantom2D.core.Component;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class LimitedLife extends Component
	{
		private var life:Number;
		
		public function LimitedLife(life:Number) 
		{
			this.life = life;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			life-= elapsedTime;
			if (life <= 0) {
				gameObject.destroyed = true;
				gameObject.sendMessage("died");
			}
		}
		
	}

}