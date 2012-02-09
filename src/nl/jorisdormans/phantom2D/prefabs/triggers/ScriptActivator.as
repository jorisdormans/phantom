package nl.jorisdormans.phantom2D.prefabs.triggers 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ScriptActivator extends Component
	{
		private var onActivate:String;
		private var onDeactivate:String;
		
		public function ScriptActivator() 
		{
			onActivate = "";
			onDeactivate = "";
		}
		
		override public function setXML(xml:XML):void 
		{
			super.setXML(xml);
			xml.@onActivate = onActivate;
			xml.@onDeactivate = onDeactivate;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@onActivate.length() > 0) {
				onActivate = xml.@onActivate;
			} else {
				onActivate = "";
			}
			if (xml.@onDeactivate.length() > 0) {
				onDeactivate = xml.@onDeactivate;
			} else {
				onDeactivate = "";
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "activate":
					gameObject.layer.executeScript(onActivate, gameObject);
					return Phantom.MESSAGE_HANDLED;
				case "deactivate":
					gameObject.layer.executeScript(onDeactivate, gameObject);
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
	}

}