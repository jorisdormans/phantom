package nl.jorisdormans.phantom2D.prefabs.platformer
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.objects.CollisionData;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.objects.Mover;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingLine;
	import nl.jorisdormans.phantom2D.particles.Particle;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PlatformerMover extends Mover implements IRenderable
	{
		public var gravity:Vector3D;
		public var currentGravity:Vector3D;
		private var gravityLength:Number;
		
		protected var _onFloor:Number;
		protected var _onSlope:Number;
		private var _onLadder:Number;
		private var _noLadder:Number;
		private var _onZSlope:Number;
		private var _skidSlopeY:Number;
		
		private var _dropping:Number;
		
		public var standingOn:GameObject;
		private var _threshold:Number;
		
		public var jumpingPower:Number;
		private var executedJumps:int;
		public var doubleJumps:int;
		
		private var acceleration:Number;
		public var accelerating:Boolean = false;
		private var direction:int = 0;

		private var _emitParticle:Number;
		private var trail:Number;
		
		public var energy:Number = 100;
		public var maxEnergy:Number = 100;
		
		public function PlatformerMover(velocity:Vector3D, gravity:Vector3D, friction:Number = 0.3, bounceRestitution:Number = 1, initiateCollisionCheck:Boolean = true) 
		{
			this.gravity = gravity;
			super(velocity, friction, bounceRestitution, initiateCollisionCheck);
			
			jumpingPower = 0.4;
			
			_threshold = 0.3;
			_onFloor = 0;
			_onSlope = 0;
			_onZSlope = 0;
			_skidSlopeY = 0;
			_onLadder = 0;
			_noLadder = 0;
			_dropping = 0;
			
			doubleJumps = 0;
			executedJumps = 0;
			
			currentGravity = gravity.clone();
			gravityLength = currentGravity.length;
			
			_emitParticle = 0;
			trail = 0;
			
			acceleration = 300;
			direction = 1;
		}
		
		override public function updatePhysics(elapsedTime:Number):void 
		{
			super.updatePhysics(elapsedTime);
			
			var f:Number
			
			if (_onLadder >= _threshold) {
				//on a ladder
				//only apply friction when not accelarting
				if (!accelerating) {
					f = 4;
					f = 1 - 2 * f * f * elapsedTime;
					velocity.x *= f;
					velocity.y *= f;
				}
			} else if (_onZSlope >= _threshold && velocity.y > -100) {
				//on a ZSlope
				//standing costs energy
				energy -= Math.min(energy, elapsedTime * 10);
				
				//friction from the slope
				f = 2.0;
				f = 1 - 2 * f * f * elapsedTime;
				
				//sliding own or out of energy
				if (_dropping>0 || energy<=0) {
					velocity.x += elapsedTime * gravity.x;
					velocity.y += elapsedTime * gravity.y;
					_emitParticle -= elapsedTime;
				} 
				
				if (!accelerating || energy<=0) {
					velocity.x *= f;
				} else {
					//moving costs extra energy
					energy -= Math.min(energy, elapsedTime * 15);
					//automaticly move up;
					velocity.x -= elapsedTime * gravity.x*0.3;
					velocity.y -= elapsedTime * gravity.y*0.3;
					velocity.x *= 1 - 2 * 1 * 1 * elapsedTime;
					//create dust particles
					_emitParticle -= elapsedTime*2;
				}
				
				velocity.y *= f;
			} else if (_onSlope > _threshold) {
				//apply gravity
				velocity.x += elapsedTime * currentGravity.x;
				velocity.y += elapsedTime * currentGravity.y;
				
				//standing on a sloped platform costs energy
				energy -= Math.min(energy, elapsedTime * 10);
				if (energy <= 0 || (accelerating && direction * currentGravity.x < 0)) {
					//no energy left or moving down: slide
					_emitParticle -= elapsedTime;
					currentGravity.x = gravity.x;
					currentGravity.y = gravity.y;
					f = 0.2;
					f = 1 - 2 * f * f * elapsedTime;
					velocity.x *= f;
					velocity.y *= f;
				} else if (	accelerating) {
					//moving up
					_emitParticle -= elapsedTime;
					energy -= Math.min(energy, elapsedTime * 15);
					if (standingOn) f = (standingOn as ProtoPlatform).friction;
					else f = 3;
					f = 1 - 2 * f * f * elapsedTime;
					velocity.x *= f;
					velocity.y *= f;
				} else {
					//standing still
					f = 3;
					f = 1 - 2 * f * f * elapsedTime;
					velocity.x *= f;
					velocity.y *= f;
				}
			} else if (_onFloor >= _threshold) {
				//standing on a platform
				//apply gravity
				velocity.x += elapsedTime * currentGravity.x;
				velocity.y += elapsedTime * currentGravity.y;
				//regain energy
				energy += Math.min(maxEnergy - energy, elapsedTime * 100);
				
				_onZSlope = 0;
				
				if (standingOn is ProtoPlatform) {
					if (standingOn.mover) {
						gameObject.shape.position.x += standingOn.mover.velocity.x * elapsedTime;
						gameObject.shape.position.y += standingOn.mover.velocity.y * elapsedTime;
					}
					if (accelerating) {
						//apply friction when moving
						f = (standingOn as ProtoPlatform).friction;
						f = 1 - 2 * f * f * elapsedTime;
						velocity.x *= f;
						velocity.y *= f;
					} else {
						//not moving apply: friction to stop (called grip)
						f = (standingOn as ProtoPlatform).grip;
						f = 1 - 2 * f * f * elapsedTime;
						velocity.x *= f;
						velocity.y *= f;
					}
				}
			} else {
				//in the air: so fall down;
				standingOn = null;
				velocity.x += elapsedTime * gravity.x;
				velocity.y += elapsedTime * gravity.y;
			}			
			
			//determine ladder and ZSlope settings based on position
			if (_onFloor < _threshold) {
				//TODO: This can be improved to get only one test if ProtoSlidingSlope and ProtoLadder share a common ancestor
				var o:GameObject = gameObject.layer.getObjectAt(gameObject.shape.position, ProtoSlidingSlope);
				if (o is ProtoSlidingSlope && _skidSlopeY<gameObject.shape.position.y && (velocity.y>100 || _onZSlope>=_threshold)) {
					if (_onZSlope < _threshold) {
						createDust(Math.min(velocity.y*0.03, 5), velocity.y*0.002, 10, 0xbbff88);
					}
					_onZSlope = 1;
					executedJumps = 0;	
					_skidSlopeY = 0;
					if (standingOn == null) standingOn = o;
				}
				o = gameObject.layer.getObjectAt(gameObject.shape.position, ProtoLadder);
				if (o is ProtoLadder) {
					_onLadder = 1;
					executedJumps = 0;				
					if (standingOn == null) standingOn = o;
				}
			}
			
			//apply end weight on flags
			_onFloor *= 0.9;
			_onSlope *= 0.9;
			_onZSlope *= 0.9;
			_onLadder *= 0.9;
			
			//update timers
			_noLadder -= Math.min(_noLadder, elapsedTime);
			_dropping -= Math.min(_dropping, elapsedTime);
			
			//create trail after a jump
			if (trail > 0) {
				trail -= elapsedTime;
				_emitParticle-= elapsedTime;
				if (_emitParticle<0) {
					createDust(1, trail+0.1, 1);
					_emitParticle += 0.06 - trail * 0.15;
				}
			}
			
			//should I be creating dust?
			if (_emitParticle < 0) {
				_emitParticle += 0.2;
				//TODO: take dust color from protoPlatformer
				createDust(1, 0.3, 4, 0xbbff88);
			}
			
		}
		
		private function createDust(n:int, life:Number, spread:Number, color:uint = 0xffffff):void {
			for (var i:int = 0; i < n; i++) { 
				var particle:Particle = new Particle();
				var p:Vector3D = gameObject.shape.position.clone();
				p.y += 2;
				p.x += (Math.random() - Math.random()) * spread;
				var v:Vector3D = new Vector3D((Math.random() - Math.random()) * 40, (Math.random() + Math.random()) * -20);
				particle.initialize(life + Math.random() * life, p, v);
				particle.color = color;
				gameObject.layer.gameScreen.addParticle(particle);
			}
		}
		
		override public function respondToCollision(collision:CollisionData, other:GameObject, factor:Number):void 
		{
			super.respondToCollision(collision, other, factor);
			if (collision.normal.y > 0.65) {
				if (collision.normal.y < 0.8) {
					_onSlope = 1;
					if (energy <= 0) {
						return;
					}
				}
				if (velocity.dotProduct(gravity) >= 0) {
					if (_onFloor < _threshold) {
						createDust(Math.min(velocity.y * 0.02, 5), velocity.y * 0.001, 10, 0x88bbff);
						if (velocity.y>100) {
							gameObject.sendMessage("land");
						}
					}
				}
				_onFloor = 1;
				standingOn = other;
				executedJumps = 0;
				if (standingOn is ProtoPlatform && (standingOn as ProtoPlatform).grip>0) {
					currentGravity.x = collision.normal.x * gravityLength;
					currentGravity.y = collision.normal.y * gravityLength;
				}
			}
		}
		
		
		
		public function move(elapsedTime:Number, direction:int):void {
			if (_onSlope > _threshold) {
				velocity.x += elapsedTime * acceleration * 0.5 * direction * (currentGravity.y / gravityLength);
				velocity.y -= elapsedTime * acceleration * 0.5 * direction * (currentGravity.x / gravityLength);
				
			} else {
				velocity.x += elapsedTime * acceleration * direction * (currentGravity.y / gravityLength);
				velocity.y -= elapsedTime * acceleration * direction * (currentGravity.x / gravityLength);
			}
			this.direction = direction;
			accelerating = true;
		}
		
		public function climbLadder(elapsedTime:Number, direction:int):void {
			velocity.y += elapsedTime * acceleration * direction * 0.7;
			accelerating = true;
		}
		
		public function jump():void {
			if (executedJumps==0 && _onZSlope < _threshold && _onLadder < _threshold && _onFloor < _threshold && _onSlope < _threshold) {
				executedJumps++;
			}
			if (_onZSlope >= _threshold || _onLadder >= _threshold || _onFloor >= _threshold || _onSlope >= _threshold || executedJumps <= doubleJumps) {
				_noLadder = 0.2;
				if (_onZSlope >= _threshold) {
					velocity.y = -gravity.y * jumpingPower;
					_skidSlopeY = gameObject.shape.position.y;
				} else {
					velocity.y = -gravity.y * jumpingPower;
				}
				_onFloor = 0;
				_onLadder = 0;
				_onZSlope = 0;
				_onSlope = 0;
				standingOn = null;
				currentGravity.x = gravity.x;
				currentGravity.y = gravity.y;
				executedJumps++;
				createDust(5, 0.3, 10);
				gameObject.sendMessage("land");
				trail = 0.2;
			}
		}
		public function dropDown():void {
			if (_onFloor >= _threshold || _onZSlope >= _threshold) _dropping = 0.15;
		}
		
		public function get onFloor():Boolean {
			return (_onFloor >= _threshold);
		}
		
		public function get onSlope():Boolean {
			return (_onSlope >= _threshold);
		}

		
		public function get onLadder():Boolean {
			return (_onLadder >= _threshold);
		}
		
		public function get onZSlope():Boolean {
			return (_onZSlope >= _threshold);
		}
		
		override public function canCollideWith(other:GameObject):Boolean 
		{
			if (_dropping > 0 && other.shape is BoundingLine && (other.shape as BoundingLine).oneWay > 0) return false;
			return super.canCollideWith(other);
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			if (energy<maxEnergy) {
				graphics.beginFill(0xffffff);
				graphics.drawRect(x - 25, y - 50, 50, 8);
				graphics.drawRect(x - 24, y - 49, 48, 6);
				graphics.endFill();
				
				graphics.beginFill(0x00bb00);
				graphics.drawRect(x - 23, y - 48, 46 * Math.max(0, energy) / maxEnergy, 4);
				graphics.endFill();
			}
		}
		
	}

}