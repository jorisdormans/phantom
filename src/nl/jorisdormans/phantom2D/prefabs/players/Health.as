package nl.jorisdormans.phantom2D.prefabs.players
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Health extends Component implements IHudComponent
	{
		public static const E_DIED:String = "died";
		
		public var maxHealth:Number;
		public var health:Number;
		public var damageSpeed:Number;
		public var healingSpeed:Number;
		private var immunityTime:Number;
		private var immunity:Number;
		private var healing:Number;
		private var damaging:Number;
		
		public function Health(maxHealth:Number, initialHealth:Number = -1) 
		{
			this.maxHealth = maxHealth;
			if (initialHealth <= 0) {
				health = maxHealth;
			} else {
				health = initialHealth;
			}
			healing = 0;
			damaging = 0;
			immunity = 0;
			immunityTime = 0.5;
			damageSpeed = 500;
			healingSpeed = 100;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "burn":
				case "freeze":
				case "damage":
					if (immunity <= 0) {
						damaging += data.damage;
						//health -= data.damage;
						immunity = immunityTime;
						gameObject.sendMessage("hit", data);
						return Phantom.MESSAGE_HANDLED;
					}
					break;
				case "heal":
					if (health < maxHealth) {
						healing += data.damage;
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
				var n:Number = Math.min(healingSpeed * elapsedTime, healing);
				healing -= n;
				health += n;
				if (health > maxHealth) {
					health = maxHealth
				}
			}
			if (damaging > 0) {
				n = Math.min(damageSpeed * elapsedTime, damaging);
				damaging -= n;
				health -= n;
				if (health <= 0) {
					gameObject.sendMessage(E_DIED);
				}
			}
		}
		
		/* INTERFACE phantom2D.prefabs.player.IHudComponent */
		
		public function drawToHud(graphics:Graphics):void
		{
			graphics.lineStyle(1, 0xffffff);
			graphics.drawRect(10, 10, 102, 8);
			graphics.lineStyle(1, 0xbb0000);
			graphics.beginFill(0xff0000);
			if (health>0 && !(immunity>0 && immunity%0.1>0.05)) {
				graphics.drawRect(11, 11, Math.max(0, Math.min(100, health*100/maxHealth)), 6);
			}
			graphics.endFill();
			graphics.lineStyle();				
		}
		
		
		
	}

}