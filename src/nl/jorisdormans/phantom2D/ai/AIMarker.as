package nl.jorisdormans.phantom2D.ai 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.editor.EditorOutlineRenderer;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingCircle;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AIMarker extends GameObject 
	{
		
		public function AIMarker() 
		{
			addComponent(new BoundingCircle(10));
			addComponent(new EditorOutlineRenderer(0x00bbff, 3));
			doResponse = false;
		}
		
	}

}