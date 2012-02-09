package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomBorder extends PhantomControl
	{
		
		public function PhantomBorder(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(parent, x, y, width, height, showing, enabled);
		}
		
		override public function draw():void 
		{
			var face:uint = PhantomGUISettings.colorSchemes[colorScheme].colorBorder;
			graphics.clear();
			graphics.beginFill(face);
			graphics.drawRect(0, 0, _controlWidth, _controlHeight);
			graphics.endFill();
		}
		
	}

}