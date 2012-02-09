package nl.jorisdormans.phantom2D.editor 
{
	import nl.jorisdormans.phantom2D.core.Layer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class LayerData 
	{
		public var layer:Layer;
		public var tool:int;
		public var editMode:int;
		
		public static const EDIT_NOTHING:int = 0; 
		public static const EDIT_OBJECTS:int = 1; 
		public static const EDIT_TILES:int = 2; 
		public static const EDIT_CURVES:int = 3; 
		
		
		public function LayerData(layer:Layer, editMode:int) 
		{
			this.layer = layer;
			this.tool = 0;
			this.editMode = editMode;
		}
		
	}

}