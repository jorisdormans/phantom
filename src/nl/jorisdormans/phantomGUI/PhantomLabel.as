package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomLabel extends PhantomControl
	{
		
		public function PhantomLabel(caption:String, parent:DisplayObjectContainer, x:Number, y:Number, width:Number = 88, height:Number = 20, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(parent, x, y, width, height, showing, enabled);
			this.caption = caption;
		}
		
		override public function get enabled():Boolean { return super.enabled; }
		
		override public function set enabled(value:Boolean):void 
		{
			super.enabled = value;
			draw();
		}
		
		override public function draw():void 
		{
			if (_textField!=null) {
				if (enabled) _textField.textColor = PhantomGUISettings.colorSchemes[colorScheme].colorBorder;
				else _textField.textColor = PhantomGUISettings.colorSchemes[colorScheme].colorBorderDisabled;
			}
		}
		
	}

}