package nl.jorisdormans.phantom2D.prefabs.platformer 
{
	import nl.jorisdormans.phantom2D.core.Camera;
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AnimatedHumanoid extends Component implements IRenderable
	{
		private var legLength:Number = 12;
		private var torsoLength:Number = 6;
		private var feetWidth:Number = 14;
		private var shoulderWidth:Number = 3;
		private var armLength:Number = 8;
		private var neckLength:Number = 5;
		private var walkingCycle:Number = 0;
		private var slidingCycle:Number = 0;
		private var balancingCycle:Number = 0;
		private var direction:int;
		private var hipWidth:Number = 1.5;
		private var headForward:Number = 2;
		
		private var running:Number;
		private var falling:Number;
		private var landing:Number;
		private var climbing:Number;
		private var sliding:Number;
		private var blink:Number;
		private var balancing:Number = 0;
		public var drawPhysics:Boolean = false;
		
		public function AnimatedHumanoid() 
		{
			super();
			running = 0;
			falling = 0;
			landing = 0;
			sliding = 0;
			walkingCycle = 0;
			direction = 1;
			blink = 2;
			climbing = 0;
			balancing = 0;
			balancingCycle = 0;
		}
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			//super.render(graphics, camera);
			if (drawPhysics) {
				graphics.lineStyle(1, 0xffffff);
				gameObject.shape.drawShape(graphics, x, y, angle, zoom);
				graphics.lineStyle();
			}
			
			var feetX:Number, feetY:Number;
			var lowerTorsoX:Number, lowerTorsoY:Number;
			var upperTorsoX:Number, upperTorsoY:Number;
			var shoulderX:Number, shoulderY:Number;
			var headX:Number, headY:Number;
			var handLX:Number, handLY:Number;
			var handRX:Number, handRY:Number;
			var cos:Number;
			var sin:Number;
			var runCycleSpeed:Number = 16;
			var climbingCycle:Number = 0;
			if (climbing > 0.1) {
				climbingCycle = Math.cos(runCycleSpeed * walkingCycle);
			}
			
			//calculate feet
			feetX = x;
			feetY = y;
			//feetY += legLength - running * feetWidth * 0.4;
			feetY += legLength*0.3 - running * feetWidth * 0.4;
			
			var wobble:Number = 0.6 * (Math.cos(walkingCycle * runCycleSpeed * 2) + running * 0.5) * running;
			//feetY -= 0.3 * legLength * Math.abs((Math.sin(walkingCycle * runCycleSpeed)) * running);
			wobble += sliding * Math.cos(slidingCycle * runCycleSpeed) * 0.5;
			wobble += landing * 1;
			
			var wobbleX:Number = 0;
			if (balancing > 0) wobbleX += (MathUtil.clamp(Math.sin(balancingCycle*2)*2, -1.5, 1.5))*0.3*direction;
			
			//lowerTorso
			lowerTorsoX = feetX + direction*running*legLength*0.2 + wobbleX*legLength*0.1;
			lowerTorsoY = feetY-legLength + wobble*legLength*0.1;
			//upperTorso
			upperTorsoX = lowerTorsoX + direction*running*torsoLength*0.2 + wobbleX*torsoLength*0.1;
			upperTorsoY = lowerTorsoY-torsoLength*0.5 - running*torsoLength*0.1;
			//shoulder
			shoulderX = upperTorsoX + direction*running*torsoLength*0.2 + wobbleX*torsoLength*0.1;
			shoulderY = upperTorsoY - torsoLength * 0.5 - running * torsoLength * 0.1;
			//head
			headX = shoulderX + direction*running*neckLength*0.2 + direction*headForward + wobbleX*neckLength*0.2;
			headY = shoulderY - neckLength - running * neckLength * 0.2 + wobble*neckLength;
			
			if (climbing > 0.1) {
				handLX = shoulderX + shoulderWidth*direction*2;
				handLY = shoulderY + climbingCycle*armLength*0.6;
				handRX = shoulderX - shoulderWidth*direction*2;
				handRY = shoulderY - climbingCycle*armLength*0.6;
			} else {
				//hands
				handLX = shoulderX + shoulderWidth*direction;
				handLY = shoulderY;
				var a:Number = Math.sin(walkingCycle * runCycleSpeed) * running * direction * 2 * (1 - falling) - falling * 4 * direction;
				if (balancing > 0.1) a = direction * ( -3 - MathUtil.clamp(Math.sin(balancingCycle)*3, -0.7, 0.7))  * balancing + (1 - balancing) * a;

				a += sliding * Math.sin(slidingCycle * runCycleSpeed * 0.8) * 0.3;
				cos = -Math.sin(a);
				sin = Math.cos(a);
				handLX += cos * armLength;
				handLY += sin * armLength;
				
				handRX = shoulderX - shoulderWidth*direction;
				handRY = shoulderY;
				a = -Math.sin(walkingCycle * runCycleSpeed) * running * direction * 2 * (1 - falling) + falling * 4 * direction;
				if (balancing > 0.1) a = direction * (3 - MathUtil.clamp(Math.sin(balancingCycle)*3, -0.7, 0.7)) * balancing + (1 - balancing) * a;
				a += sliding * Math.sin(slidingCycle * runCycleSpeed * 1.0) * 0.3;
				cos = -Math.sin(a);
				sin = Math.cos(a);
				handRX += cos * armLength;
				handRY += sin * armLength;
			}
			
			//draw back hand
			drawHand(graphics, handLX, handLY);
			
			//draw feet
			if (climbing > 0.1) {
				drawFoot(graphics, feetX - hipWidth, feetY + climbingCycle * legLength * 0.4);
				drawFoot(graphics, feetX + hipWidth, feetY - climbingCycle * legLength * 0.4);
			} else {
				a = walkingCycle * runCycleSpeed;
				cos = Math.cos(a) * direction * (1-falling);
				sin = Math.sin(a) * direction * (1-falling);
				drawFoot(graphics, feetX + cos * feetWidth * running - hipWidth, feetY + sin * feetWidth * 0.3 * running);
				drawFoot(graphics, feetX - cos * feetWidth * running + hipWidth, feetY - sin * feetWidth * 0.3 * running);
			}
			
			//draw lowerTorso
			drawLowerTorso(graphics, lowerTorsoX, lowerTorsoY);
			//drawLowerTorso(graphics, upperTorsoX, upperTorsoY);
			drawUpperTorso(graphics, shoulderX, shoulderY);
			
			//draw Head
			drawHead(graphics, headX, headY);

			
			//draw back front
			drawHand(graphics, handRX, handRY);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			
			//decay
			running *= 0.9;
			falling *= 0.9;
			landing *= 0.8;
			climbing *= 0.7;
			balancing *= 0.9;
			sliding *= 0.9;
			
			//blinkling;
			blink -= elapsedTime;
			if (blink < 0) {
				if (Math.random() < 0.1) blink += 0.5;
				else blink += 2 + Math.random();
			}
		}
		
		public function doSlide(elapsedTime:Number):void {
			sliding = sliding * 0.9 + 0.1;
			falling = falling * 0.9 + 0.1;
			slidingCycle += elapsedTime;
		}
		
		public function doRun(elapsedTime:Number, direction:int, onFloor:Boolean, onLadder:Boolean):void {
			running = running * 0.9 + 0.1;
			if (onFloor || balancing>0.3) walkingCycle += elapsedTime * direction * running;
			this.direction = direction;
		}
		
		public function doClimb(elapsedTime:Number, direction:int):void {
			climbing = climbing * 0.7 + 0.3;
			walkingCycle += elapsedTime * direction * climbing;
		}
		
		public function doBalance(elapsedTime:Number):void {
			balancing = balancing * 0.9 + 0.1;
			balancingCycle += elapsedTime * balancing*6;
		}
		
		
		public function doFall(elapsedTime:Number):void {
			var dy:Number = gameObject.mover.velocity.y;
			if (dy > -100) {
				falling = falling * 0.9 + 0.1;
			}
		}
		public function doLand():void {
			landing = 1;
		}
		
		private function drawFoot(graphics:Graphics, dx:Number, dy:Number):void {
			graphics.beginFill(0xbb4400);
			graphics.drawEllipse(dx-5+direction*2, dy-5, 10, 6);
			graphics.endFill();
		}
		
		private function drawLowerTorso(graphics:Graphics, dx:Number, dy:Number):void {
			graphics.beginFill(0x00aa00);
			graphics.drawCircle(dx, dy, 4);
			graphics.endFill();
		}
		
		private function drawUpperTorso(graphics:Graphics, dx:Number, dy:Number):void {
			graphics.beginFill(0x00bb00);
			graphics.drawCircle(dx+direction, dy+1, 5);
			graphics.endFill();
		}
		
		private function drawHand(graphics:Graphics, dx:Number, dy:Number):void {
			graphics.beginFill(0xffcc55);
			graphics.drawCircle(dx, dy, 4);
			graphics.endFill();
		}
		
		private function drawHead(graphics:Graphics, dx:Number, dy:Number):void {
			dy -= 2;
			graphics.beginFill(0xff4400);
			graphics.drawCircle(dx, dy-2, 7);
			graphics.endFill();
			
			graphics.beginFill(0xffbb44);
			graphics.drawCircle(dx+direction, dy+1, 6);
			graphics.endFill();
			
			graphics.beginFill(0x885522);
			graphics.drawCircle(dx+direction*4, dy, 2.5);
			graphics.drawCircle(dx+direction*-1, dy, 2.5);
			graphics.endFill();
			if (blink > 0.3) {
				graphics.beginFill(0xffffff);
				graphics.drawCircle(dx+direction*4, dy, 2);
				graphics.drawCircle(dx+direction*-1, dy, 2);
				graphics.endFill();
				graphics.beginFill(0x000000);
				graphics.drawCircle(dx+direction*5, dy, 1.5);
				graphics.drawCircle(dx+direction*0, dy, 1.5);
				graphics.endFill();
				graphics.beginFill(0xffffff);
				graphics.drawCircle(dx+direction*5.5, dy-0.5, 1);
				graphics.drawCircle(dx+direction*0.5, dy-0.5, 1);
				graphics.endFill();
			}
			graphics.beginFill(0xaa7722);
			graphics.drawEllipse(dx+direction*2-2.5, dy+4, 5, 2);
			graphics.endFill();
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "land":
					doLand();
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
	}

}