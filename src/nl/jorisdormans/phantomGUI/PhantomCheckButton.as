package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomCheckButton extends PhantomButton
	{
		private var _checked:Boolean;
		
		public function PhantomCheckButton(caption:String, action:Function, parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, checked:Boolean = true, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(caption, action, parent, x, y, width, height, showing, enabled);
			_checked = checked;
			_textField.x += height * 0.3;
		}
		
		override public function draw():void 
		{
			super.draw();
			var border:uint = PhantomGUISettings.colorSchemes[colorScheme].colorBorder;
			var face:uint = PhantomGUISettings.colorSchemes[colorScheme].colorWindow;
			if (!enabled) {
				border = PhantomGUISettings.colorSchemes[colorScheme].colorBorderDisabled;
				face = PhantomGUISettings.colorSchemes[colorScheme].colorWindowDisabled;
			}
			var dy:Number = _controlHeight * 0.5;
			var dx:Number = dy;
			var s:Number = dy * 1.6;
			graphics.beginFill(face);
			graphics.drawRoundRect(dx-s*0.35, dy-s*0.35, s*0.7, s*0.7, s*0.3);
			graphics.endFill();
			if (!_checked) return;
			graphics.beginFill(border);
			PhantomGlyph.drawGlyph(graphics, PhantomGlyph.CHECK, dx, dy, s);
			graphics.endFill();
		}
		
		public function get checked():Boolean { return _checked; }
		
		public function set checked(value:Boolean):void 
		{
			_checked = value;
			draw();
		}
		
		override protected function mouseUp(e:MouseEvent):void 
		{
			if (pressed && enabled) checked = !_checked;
			super.mouseUp(e);
		}
		
		
		
		
		
	}

}