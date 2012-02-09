package nl.jorisdormans.phantom2D.particles 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	/**
	 * A Component that emmits particles at a regular interval
	 * @author Joris Dormans
	 */
	public class ParticleEmiter extends Component
	{
		private var speedFactor:Number;
		private var randomVelocity:Number;
		private var randomPosition:Number;
		private var life:Number;
		private var randomLife:Number;
		private var particleType:Class;
		private var timer:Number;
		private var delay:Number;
		private var layer:int;
		private var particleLayer:ParticleLayer;
		
		/**
		 * Creates an instance of the ParticleEmitter class
		 * @param	particleType	The class indicating the type of emitted particles
		 * @param	frequency		The number of particles to be emitted every second
		 * @param	layer			An integer indicating the particle layer the particles are created on (0 is the lowest layer of the current screen).
		 * @param	life			The average time a particle will live (in seconds)
		 * @param	randomLife		The maximum amount of time randomly added or subtracted from the average life 
		 * @param	randomPosition	The maximum random distance the particle is created away from the GameObject's position
		 * @param	randomVelocity  The maximum random change applied to the particles initial velocity
		 * @param	speedFactor		The multiplication factor applied to the GameObject's velocity (if it has a mover) in order to get the particle�s initial velocity.
		 */
		public function ParticleEmiter(particleType:Class, frequency:Number = 10, layer:int = 0, life:Number = 1, randomLife:Number = 0, randomPosition:Number = 0, randomVelocity:Number = 0, speedFactor:Number = 1) 
		{
			this.timer = 0;
			this.particleType = particleType;
			this.delay = 1/frequency;
			this.life = life;
			this.randomLife = randomLife;
			this.randomPosition = randomPosition;
			this.randomVelocity = randomVelocity;
			this.speedFactor = speedFactor;
			this.layer = layer;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			timer -= elapsedTime;
			if (timer < 0) {
				if (!particleLayer) {
					particleLayer = gameObject.layer.gameScreen.getParticleLayer(layer);
					if (!particleLayer) {
						trace("WARNING: ParticleLayer " + layer + " not found for " + gameObject.toString());
					}
				}
				timer += delay;
				var particle:Particle = (new particleType() as Particle);
				if (particle) {
					var l:Number = life + (Math.random() - Math.random()) * randomLife;
					var p:Vector3D = gameObject.shape.position.clone();
					p.x += randomPosition * (Math.random() - Math.random());
					p.y += randomPosition * (Math.random() - Math.random());
					var v:Vector3D = new Vector3D();
					if (gameObject.mover) {
						v.x += gameObject.mover.velocity.x * speedFactor;
						v.y += gameObject.mover.velocity.y * speedFactor;
					}
					v.x += randomVelocity * (Math.random() - Math.random());
					v.y += randomVelocity * (Math.random() - Math.random());
					particle.initialize(l, p, v);
					particleLayer.addParticle(particle);
				}
			}
			
		}
		
		
	}

}