package nl.jorisdormans.phantom2D.prefabs.triggers 
{
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class TriggerDamage extends Trigger
	{
		private var damage:int;
		
		public function TriggerDamage(damage:int, timeOut:Number = 0) 
		{
			super(timeOut);
			this.damage = damage;
		}
		
		override public function setXML(xml:XML):void 
		{
			super.setXML(xml);
			xml.@triggerDamage = damage;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@triggerDamage.length() > 0) damage = xml.@triggerDamage;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "freeze": 
				case "burn": 
				case "damage": 
					if (data.damage >= damage) {
						this.activate();
					}
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
			
		}
		
		override public function afterCollisionWith(other:GameObject):void 
		{
			//no code here
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			gameObject.initiateCollisionCheck = true;
		}
		
		
		
	}

}