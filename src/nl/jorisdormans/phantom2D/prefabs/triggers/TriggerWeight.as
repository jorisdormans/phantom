package nl.jorisdormans.phantom2D.prefabs.triggers 
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class TriggerWeight extends Trigger
	{
		private var triggerWeight:Number;
		
		public function TriggerWeight(triggerWeight:Number = 1, timeOut:Number = 0) 
		{
			super(timeOut);
			this.triggerWeight = triggerWeight;
		}
		
		override public function setXML(xml:XML):void 
		{
			super.setXML(xml);
			xml.@triggerWeight = triggerWeight;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@triggerWeight.length()>0) triggerWeight = xml.@triggerWeight
		}
		
		override public function canCollideWith(other:GameObject):Boolean 
		{
			return (other.mass >= triggerWeight);
		}
		
		override public function onAdd():void 
		{
			super.onAdd();
			gameObject.initiateCollisionCheck = true;
		}
		
	}

}