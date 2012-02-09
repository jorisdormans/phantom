package nl.jorisdormans.phantom2D.prefabs.triggers 
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class TriggerLimited extends Trigger
	{
		private var triggerCount:int;
		private var triggersLeft:int;
		
		public function TriggerLimited(triggerCount:int = 1, timeOut:Number = 0, actorClass:Class = null) 
		{
			super(timeOut, actorClass);
			this.triggerCount = triggerCount;
			triggersLeft = triggerCount;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@triggerCount.length() > 0) {
				triggerCount = xml.@triggerCount;
				triggersLeft = triggerCount;
			}
		}
		
		override public function setXML(xml:XML):void 
		{
			super.setXML(xml);
			xml.@triggerCount = triggerCount;
		}
		
		override public function afterCollisionWith(other:GameObject):void 
		{
			if (actorClass == null || other is actorClass) {
				if (timer == 0 && triggersLeft>0) {
					gameObject.handleMessage("activate");
					triggersLeft--;
				}
				timer = timeOut;
			}
		}
		
	}

}