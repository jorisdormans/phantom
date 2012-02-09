package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomRadioButton extends PhantomButton
	{
		private var _checked:Boolean;
		
		public function PhantomRadioButton(caption:String, action:Function, parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, checked:Boolean = true, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(caption, action, parent, x, y, width, height, showing, enabled);
			_checked = checked;
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
			graphics.drawCircle(dx, dy, s*0.3);
			graphics.endFill();
			if (!_checked) return;
			graphics.beginFill(border);
			graphics.drawCircle(dx, dy, s*0.2);
			graphics.endFill();
		}
		
		public function get checked():Boolean { return _checked; }
		
		public function set checked(value:Boolean):void 
		{
			_checked = value;
			
			if (_checked && parent != null) {
				var i:int = 0;
				while (i < parent.numChildren) {
					var other:PhantomRadioButton = parent.getChildAt(i) as PhantomRadioButton;
					if (other != null && other != this) other.checked = false;
					i++;
				}
			}
		
			draw();
		}
		
		override protected function mouseUp(e:MouseEvent):void 
		{
			if (pressed && enabled) checked = !_checked;
			super.mouseUp(e);
		}
		
		
		
		
		
	}

}