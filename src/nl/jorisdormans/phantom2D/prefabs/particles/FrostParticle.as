package nl.jorisdormans.phantom2D.prefabs.particles 
{
	import nl.jorisdormans.phantom2D.core.Camera;
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.graphics.Primitives;
	import nl.jorisdormans.phantom2D.particles.Particle;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class FrostParticle extends Particle
	{
		public function FrostParticle() 
		{
			
		}
		
		override public function initialize(life:Number, position:Vector3D, velocity:Vector3D):void 
		{
			super.initialize(life, position, velocity);
			velocity.x += (Math.random() - Math.random()) * 50;
			velocity.y += (Math.random() - Math.random()) * 50;
		}
		
		override public function render(graphics:Graphics, camera:Camera):void 
		{
			color = DrawUtil.lerpColor(0xffffff, 0x00ffff, Math.min(living*3, 1));
			graphics.beginFill(color, Math.min(1, life*6));
			Primitives.drawStar(graphics, position.x - camera.left, position.y - camera.top, Math.min(7, living * 20));
			//graphics.drawCircle(position.x - camera.left, position.y - camera.top, Math.min(5, life * 15));
			graphics.endFill();		
		}
		
		
	}

}