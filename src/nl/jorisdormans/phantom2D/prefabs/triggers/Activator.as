package nl.jorisdormans.phantom2D.prefabs.triggers 
{
	import nl.jorisdormans.phantom2D.objects.Component;
	/**
	 * ...
	 * @author ...
	 */
	public class Activator extends Component
	{
		private var objectId:int;
		
		public function Activator() 
		{
			objectId = 0;
		}
		
		override public function setXML(xml:XML):void 
		{
			super.setXML(xml);
			xml.@activateObject = objectId;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@activateObject.length()>0) objectId = xml.@activateObject;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "activate":
					if (objectId>0 && objectId!=gameObject.id) {
						gameObject.layer.passMessageToObjects(objectId, "activate", null);
					}
					return MESSAGE_HANDLED;
				case "deactivate":
					if (objectId>0 && objectId!=gameObject.id) {
						gameObject.layer.passMessageToObjects(objectId, "deactivate", null);
					}
					return MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
	}

}