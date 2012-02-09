package nl.jorisdormans.phantom2D.prefabs.triggers 
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class TriggerActor extends Trigger
	{
		protected var actorClass:Class;
		
		public function TriggerActor(timeOut:Number = 0, actorClass:Class = null) 
		{
			super(timeOut);
			this.actorClass = actorClass;
		}
		
		override public function afterCollisionWith(other:GameObject):void 
		{
			if (actorClass == null || other is actorClass) {
				super.afterCollisionWith(other);
			}
		}
		
	}

}