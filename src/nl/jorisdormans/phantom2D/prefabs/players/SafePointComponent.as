package nl.jorisdormans.phantom2D.prefabs.players 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class SafePointComponent extends Component
	{
		public static var playerClass:Class;
		public static var player:GameObject;
		private var _activated:Boolean;
		private var delay:Number = 1;
		private var timer:Number = 0;
		
		public function SafePointComponent() 
		{
			
		}
		
		public function get activated():Boolean 
		{
			return _activated;
		}
		
		public function set activated(value:Boolean):void 
		{
			if (value == _activated) return;
			_activated = value;
			if (_activated) {
				if (gameObject.layer) {
					for (var i:int = 0; i < gameObject.layer.objects.length; i++) {
						if (gameObject != gameObject.layer.objects[i]) {
							gameObject.layer.objects[i].sendMessage("deactivate", null, SafePointComponent);
						}
					}
				}
				gameObject.sendMessage("activate");
			} else {
				gameObject.sendMessage("deactivate");
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "activate": 
					activated = true;
					return Phantom.MESSAGE_HANDLED;
				case "deactivate": 
					activated = false;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		override public function readXML(xml:XML):void 
		{
			if (xml.@delay.length() > 0) delay = xml.@delay;
			activated = (xml.@activated == "1");
			super.readXML(xml);
		}
		
		override public function setXML(xml:XML):void 
		{
			xml.@delay = delay;
			xml.@activated = activated ? "1" : "0";
			super.setXML(xml);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			if (_activated && (!player || player.destroyed || !player.layer)) {
				timer += elapsedTime;
				if (timer > delay) {
					if (!player || player.destroyed) {
						player = new playerClass() as GameObject;
						player.initialize(gameObject.layer, gameObject.position.clone());
						player.shape.setOrientation(gameObject.shape.orientation);
					} else {
						player.position = gameObject.position.clone();
						player.shape.setOrientation(gameObject.shape.orientation);
						gameObject.layer.addGameObjectSorted(player);
					}
					gameObject.layer.gameScreen.camera.focusOn = player;
					gameObject.layer.gameScreen.sendMessage("addedPlayer", { player:player } );
					timer = 0;
				}
			}
		}
		
		
		
	}

}