package nl.jorisdormans.phantom2D.prefabs.players 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Resource extends Component implements IHudComponent
	{
		private var amount:Number;
		private var max:Number;
		private var name:String;
		private var regainRate:Number;
		private var regaining:Number;
		
		public function Resource(name:String, max:Number, amount:Number = -1) 
		{
			this.name = name;
			this.max = max;
			if (amount<0) {
				this.amount = max;
			} else {
				this.amount = amount;
			}
			regaining = 0;
			regainRate = 100;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "has " + name:
					if (data.amount <= amount) {
						return Phantom.MESSAGE_CONSUMED;
					}
					break;
				case "gain " + name:
					if (amount<max) {
						amount += data.amount;
						amount = Math.min(amount, max);
						return Phantom.MESSAGE_CONSUMED;
					}
					break;
				case "regain " + name:
					if (amount<max) {
						regaining += data.amount;
						return Phantom.MESSAGE_CONSUMED;
					}
					break;
				case "drain " + name:
					amount -= data.amount;
					amount = Math.max(amount, 0);
					return Phantom.MESSAGE_CONSUMED;
				case "try drain " + name:
					if (data.amount <= amount) {
						amount -= data.amount;
						return Phantom.MESSAGE_CONSUMED;
					}
					break;
					
			}
			return super.handleMessage(message, data);
		}
		
		override public function getProperty(property:String, componentClass:Class = null):Object 
		{
			if (property == name) {
				return {value:amount};
			}
			return super.getProperty(property, componentClass);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			if (regaining> 0) {
				var n:Number = Math.min(regainRate * elapsedTime, regaining);
				regaining -= n;
				amount += n;
				if (amount > max) {
					amount = max
				}
			}
			super.update(elapsedTime);
			
		}
		
		/* INTERFACE phantom2D.prefabs.player.IHudComponent */
		
		public function drawToHud(graphics:Graphics):void
		{
			var drawX:Number = 10;
			var drawY:Number = 20;
			graphics.lineStyle(1, 0xffffff);
			graphics.drawRect(drawX, drawY, 102, 8);
			graphics.lineStyle(1, 0x006688);
			graphics.beginFill(0x00bbff);
			if (amount>0) {
				graphics.drawRect(drawX + 1, drawY + 1, Math.max(0, Math.min(100, amount*100/max)), 6);
			}
			graphics.endFill();
			graphics.lineStyle();				
			
		}
		
		public function add(value:Number):void {
			amount += value;
			amount = Math.min(max, Math.max(0, amount));
		}
		
		public function getAmount():Number {
			return amount;
		}
		
		public function setAmount(value:Number):void {
			amount = Math.min(max, Math.max(0, value));
		}

		
	}

}