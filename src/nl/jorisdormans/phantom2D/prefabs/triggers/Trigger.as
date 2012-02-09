package nl.jorisdormans.phantom2D.prefabs.triggers 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.ICollisionHandler;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Trigger extends Component implements ICollisionHandler
	{
		protected var timeOut:Number;
		protected var timer:Number;
		
		public function Trigger(timeOut:Number = 0) 
		{
			this.timeOut = timeOut;
			timer = 0;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@triggerTimeOut.length() > 0) timeOut = xml.@triggerTimeOut;
		}
		
		override public function setXML(xml:XML):void 
		{
			super.setXML(xml);
			xml.@triggerTimeOut = timeOut;
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IHandler */
		
		public function canCollideWith(other:GameObject):Boolean 
		{
			return true;
		}
		
		public function afterCollisionWith(other:GameObject):void 
		{
			this.activate();
		}
		
		override public function update(elapsedTime:Number):void 
		{
			if (timer > 0) {
				timer -= elapsedTime;
				if (timer <= 0) {
					timer = 0;
					gameObject.sendMessage("deactivate");
				}
			}
		}
		
		public function activate():void
		{
			if (timer == 0) {
				gameObject.sendMessage("activate");
			}
			timer = timeOut;
		}
		
	}

}