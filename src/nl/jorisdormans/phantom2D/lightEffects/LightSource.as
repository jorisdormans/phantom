package nl.jorisdormans.phantom2D.lightEffects 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class LightSource 
	{
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		public var color:uint;
		public var strength:Number;
		
		public function LightSource(x:Number, y:Number, radius:Number, strength:Number=1, color:uint=0xffffff) 
		{
			this.x = x;
			this.y = y;
			this.radius = radius;
			this.strength = strength;
			this.color = color;
		}
		
		public function setLight(x:Number, y:Number, radius:Number, strength:Number=1, color:uint=0xffffff):void {
			this.x = x;
			this.y = y;
			this.radius = radius;
			this.strength = strength;
			this.color = color;
		}
		
		public function draw(graphics:Graphics, graphics2:Graphics, pass:Number):void {
			if (strength < pass) return;
			var c:uint = DrawUtil.lerpColor(0x000000, color, pass);
			var r:Number = Math.max(radius - (pass-strength) * 60 + 15, 0);
			graphics.beginFill(c);
			graphics.drawCircle(x, y, r);
			graphics.endFill();
			graphics2.beginFill(c);
			graphics2.drawCircle(x*0.1, y*0.1, r*0.1);
			graphics2.endFill();
		}		
	}

}