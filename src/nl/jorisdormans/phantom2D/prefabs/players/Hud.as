package nl.jorisdormans.phantom2D.prefabs.players
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Hud extends Layer
	{
		public var player:GameObject;
		
		public function Hud(player:GameObject = null) 
		{
			this.player = player;
		}
		
		override public function render(camera:Camera):void 
		{
			super.render(camera);
			if (!player) return;
			
			for (var i:int = 0; i < player.components.length; i++) {
				if (player.components[i] is IHudComponent) {
					(player.components[i] as IHudComponent).drawToHud(sprite.graphics);
				}
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			if (message == "addedPlayer") {
				player = data.player;
				return Phantom.MESSAGE_CONSUMED;
			}
			return super.handleMessage(message, data);
		}
		
	}

}