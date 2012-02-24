package nl.jorisdormans.phantom2D.prefabs.players 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.editor.EditorOutlineRenderer;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingCircle;
	import nl.jorisdormans.phantom2D.prefabs.triggers.BoundingShapeSwitchRenderer;
	import nl.jorisdormans.phantom2D.prefabs.triggers.PositionMarker;
	import nl.jorisdormans.phantom2D.prefabs.triggers.TriggerActor;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class SafePoint extends GameObject
	{
		public function SafePoint() 
		{
			addComponent(new BoundingCircle(10));
			addComponent(new EditorOutlineRenderer(0x888888, 3));
			addComponent(new BoundingShapeSwitchRenderer(0x00ff00, 0x888888));
			addComponent(new SafePointComponent());
			addComponent(new TriggerActor(0, SafePointComponent.playerClass));
			doResponse = false;
		}
		
		
	}

}