package nl.jorisdormans.phantom2D.prefabs.items 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.ICollisionHandler;
	/**
	 * ...
	 * @author ...
	 */
	public class Lock extends Component implements ICollisionHandler
	{
		private var keyItem:String;
		public var keyCount:int;
		private var openTime:Number;
		public var closed:int;
		private var timer:Number;
		public var keysUsed:int;
		
		public function Lock(keyItem:String, closed:int = 1, keyCount:int = 1, openTime:Number = 0) 
		{
			this.keyItem = keyItem;
			this.keyCount = keyCount;
			this.openTime = openTime;
			this.closed = closed;
			this.timer = 0;
			this.keysUsed = 0;
		}
		
		override public function setXML(xml:XML):void 
		{
			super.setXML(xml);
			xml.@keyItem = keyItem;
			xml.@closed = closed;
			xml.@keyCount = keyCount;
			xml.@openTime = openTime;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@keyItem.length() > 0) keyItem = xml.@keyItem;
			if (xml.@closed.length() > 0) closed = xml.@closed;
			if (xml.@keyCount.length() > 0) keyCount = xml.@keyCount;
			if (xml.@openTime.length() > 0) openTime = xml.@openTime;
			this.timer = 0;
			this.keysUsed = 0;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "activate": 
					closed = 0;
					timer = openTime;
					return Phantom.MESSAGE_HANDLED;
				case "deactivate": 
					closed = 1;
					timer = 0;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IHandler */
		
		public function canCollideWith(other:GameObject):Boolean 
		{
			return (closed == 1);
		}
		
		public function afterCollisionWith(other:GameObject):void 
		{
			while (keysUsed < keyCount) {
				if (other.sendMessage("consume item", { item: keyItem, quantity: 1 } ) == Phantom.MESSAGE_CONSUMED) {
					keysUsed++;
				} else {
					break;
				}
			}
			if ((keyCount>0 && keysUsed == keyCount) || keyItem == null || keyItem == "") {
				timer = openTime;
				closed = 0;
			}
		}
		
		override public function update(elapsedTime:Number):void 
		{
			if (closed == 0 && timer > 0) {
				timer -= elapsedTime;
				if (timer <= 0) {
					timer = 0;
					closed = 1;
				}
			}
		}
		
		
	}

}