package nl.jorisdormans.phantom2D.prefabs.adventure 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.Mover;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AdventureMover extends Mover
	{
		public var acceleration:Number;
		public var rotationSpeed:Number;
		public var wantOrientation:Number;
		public var turningSpeed:Number;
		public var moveX:Number;
		public var moveY:Number;
		private var groundFriction:Number;
		private var surface:Surface;
		
		public var lurch:Number;
		private var lurchX:Number;
		private var lurchY:Number;
		private var hitX:Number;
		private var hitY:Number;
		private var hit:Number;
		public var turning:Number;
		public var spinning:Number;
		public var spinningSpeed:Number;
		private var noTurn:Number;
		
		
		public function AdventureMover(velocity:Vector3D, acceleration:Number, rotationSpeed:Number, friction:Number = 2, bounceRestitution:Number = 1) 
		{
			super(velocity, friction, bounceRestitution, true);

			moveX = 0;
			moveY = 0;
			
			groundFriction = AdventureSettings.defaultGroundFriction;
			
			lurch = 0;
			lurchX = 0;
			lurchY = 0;
			
			hit = 0;
			hitX = 0;
			hitY = 0;
			
			spinning = 0;
			
			this.acceleration = acceleration;
			this.rotationSpeed = rotationSpeed;
			turningSpeed = 1;
			noTurn = 0;
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			wantOrientation = gameObject.shape.orientation;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			if (spinning > 0) {
				if (spinningSpeed>0) {
					gameObject.shape.rotateBy(Math.min(spinning * elapsedTime * 300, spinningSpeed * elapsedTime));
				} else {
					gameObject.shape.rotateBy(Math.max(spinning * elapsedTime * -300, spinningSpeed * elapsedTime));
				}
			}
			
			if (hit > 0) {
				velocity.x += hitX * acceleration * 4 * elapsedTime;
				velocity.y += hitY * acceleration * 4 * elapsedTime;
			} else if (lurch>0) {
				velocity.x += lurchX * acceleration * 6 * elapsedTime;
				velocity.y += lurchY * acceleration * 6 * elapsedTime;
			} else {
				velocity.x += moveX * acceleration * elapsedTime;
				velocity.y += moveY * acceleration * elapsedTime;
				//if ((moveX == 0 && moveY == 0) || lurchForward > 0 || lurchBackward > 0) {
				if (moveX == 0 && moveY == 0) {
					velocity.scaleBy(1 - 2 * groundFriction * groundFriction * elapsedTime);
				}
			}
			
			super.updatePhysics(elapsedTime);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			
			if (noTurn<=0) {
				turning = MathUtil.angleDifference(wantOrientation, gameObject.shape.orientation);
				turning = MathUtil.clamp(turning, -elapsedTime * rotationSpeed * turningSpeed, elapsedTime * rotationSpeed * turningSpeed);
				gameObject.shape.rotateBy(turning);
			}
			
			noTurn -= Math.min(elapsedTime, noTurn);
			lurch -= Math.min(elapsedTime, lurch);
			hit -= Math.min(elapsedTime, hit);
			spinning -= Math.min(elapsedTime, spinning);
			surface = gameObject.layer.getObjectAt(gameObject.position, Surface) as Surface;
			if (surface) {
				groundFriction = surface.friction;
				if (surface.message) gameObject.sendMessage(surface.message);
			} else {
				groundFriction = AdventureSettings.defaultGroundFriction;
			}
			
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "hit": 
					if (data.source is GameObject) {
						hitX = gameObject.position.x - (data.source as GameObject).position.x;
						hitY = gameObject.position.y - (data.source as GameObject).position.y;
						var d:Number = Math.sqrt(hitX * hitX + hitY * hitY);
						if (d > 0) {
							hitX /= d;
							hitY /= d;
							hit = 0.1;
							spinning = 0.5;
							spinningSpeed = 40;
							velocity.x += hitX * 150;
							velocity.y += hitY * 150;
						}
					}
					break;
				case "swing": 
					if (data.time) {
						spinning = data.time;
					} else {
						spinning = 0.5;
					}
					if (data.speed) {
						spinningSpeed = data.speed;
					} else {
						spinningSpeed = 40;
					}
					break;
				case "lurchforward": 
					if (data.time) {
						lurch = data.time;
					} else {
						lurch = 0.1;
					}
					noTurn = lurch + 0.2;
					if (data.force) {
						lurchX = gameObject.shape.orientationVector.x * data.force;
						lurchY = gameObject.shape.orientationVector.y * data.force;
					} else {
						lurchX = gameObject.shape.orientationVector.x;
						lurchY = gameObject.shape.orientationVector.y;
					}
					break;
				case "lurchbackward": 
					if (data.time) {
						lurch = data.time;
					} else {
						lurch = 0.1;
					}
					if (data.force) {
						lurchX = -gameObject.shape.orientationVector.x * data.force;
						lurchY = -gameObject.shape.orientationVector.y * data.force;
					} else {
						lurchX = -gameObject.shape.orientationVector.x;
						lurchY = -gameObject.shape.orientationVector.y;
					}
					break;
				case "drop": 
					lurch = 0.05;
					lurchX = gameObject.shape.orientationVector.x * -0.5;
					lurchY = gameObject.shape.orientationVector.y * -0.5;
					break;
				
			}
			return super.handleMessage(message, data);
		}
		
		
		/*public function turn(targetAngle:Number, elapsedTime:Number):Number {
			targetAngle = MathUtil.angleDifference(targetAngle, gameObject.shape.orientation);
			targetAngle = MathUtil.clamp(targetAngle, -elapsedTime * rotationSpeed, elapsedTime * rotationSpeed);
			gameObject.shape.rotateBy(targetAngle);
			return targetAngle;
		}*/
		
		/*public function moveForward(elapsedTime:Number):void {
			velocity.x += acceleration * elapsedTime * gameObject.shape.orientationVector.x;
			velocity.y += acceleration * elapsedTime * gameObject.shape.orientationVector.y;
		}*/		
		
	}

}