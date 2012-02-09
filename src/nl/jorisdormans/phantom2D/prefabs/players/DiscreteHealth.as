package nl.jorisdormans.phantom2D.prefabs.players 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class DiscreteHealth extends Component implements IHudComponent
	{
		private var health:int;
		private var maxHealth:int;
		private var healing:int;
		private var healingSpeed:Number;
		private var healingTime:Number;
		private var immunityTime:Number;
		private var immunity:Number;
		
		public function DiscreteHealth(maxHealth:int, health:int=-1) 
		{
			this.maxHealth = maxHealth;
			if (health < 0) {
				this.health = maxHealth;
			} else {
				this.health = health;
			}
			healing = 0;
			healingSpeed = 0.3;
			healingTime = 0;
			immunity = 0;
			immunityTime = 0.5;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "burn":
				case "freeze":
				case "damage":
					if (immunity<=0) {
						health -= data.damage;
						immunity = immunityTime;
						gameObject.sendMessage("hit", data);
						if (health <= 0) {
							gameObject.sendMessage("died", data);
						}
						return Phantom.MESSAGE_HANDLED;
					}
					break;
				case "heal":
					if (health < maxHealth) {
						healing += data.damage;
						healingTime = 0;
						return Phantom.MESSAGE_HANDLED;
					}
					break;
			}
			return super.handleMessage(message, data);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			if (immunity > 0) {
				immunity -= elapsedTime;
			}
			if (healing > 0) {
				healingTime -= elapsedTime;
				while (healingTime<=0) {
					if (health < maxHealth) {
						health++;
					}
					healing--;
					healingTime += healingSpeed;
				}
			}
			
		}
		
		/* INTERFACE phantom2D.prefabs.player.IHudComponent */
		
		public function drawToHud(graphics:Graphics):void
		{
			graphics.lineStyle(1, 0xffffff);
			graphics.drawRect(10, 10, 101, 8);
			graphics.lineStyle(1, 0xbb0000);
			var w:Number = 100 / maxHealth;
			for (var i:int = 0; i < health; i++) {
				graphics.beginFill(0xff0000);
				graphics.drawRect(11+w*i, 11, w-1, 6);
				graphics.endFill();
			}
			graphics.lineStyle();				
			
		}
		
	}

}