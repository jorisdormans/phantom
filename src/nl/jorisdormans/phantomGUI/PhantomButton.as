package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomButton extends PhantomControl
	{
		protected var _action:Function;
		protected var _edge:Number = PhantomGUISettings.press;
		protected var _hover:Boolean = false;
		protected var _pressed:Boolean = false;
		protected var _glyph:int = 0;
		public var drawImage:Function = null;
		//protected var _tooltipShown:Boolean = false;
		protected var _toolTip:PhantomToolTip;
		
		public function PhantomButton(caption:String, action:Function, parent:DisplayObjectContainer, x:Number, y:Number, width:Number = 88, height:Number = 24, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(parent, x, y, width, height, showing, enabled); 
			_action = action;
			_captionAlign = ALIGN_CENTER;
			this.caption = caption;
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			buttonMode = enabled;
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			if (_toolTip != null && _toolTip.parent!=null) {
				_toolTip.dispose();
				_toolTip = null;
			}			
		}
		
		protected function mouseUp(e:MouseEvent):void 
		{
			if (pressed) {
				pressed = false;
				if (_action != null) _action(this);
			}
		}
		
		protected function mouseDown(e:MouseEvent):void 
		{
			if (enabled) pressed = true;
		}
		
		protected function mouseOut(e:MouseEvent):void 
		{
			hover = false;
			if (pressed) pressed = false;
			if (_toolTip != null) {
				_toolTip.dispose();
				_toolTip = null;
			}
		}
		
		protected function mouseOver(e:MouseEvent):void 
		{
			if (enabled) hover = true;
			if (_toolTip == null && drawImage!=null) {
				_toolTip = new PhantomToolTip(_caption, stage); 
			}
		}
		
		override public function draw():void 
		{
			var border:uint = PhantomGUISettings.colorSchemes[colorScheme].colorBorder;
			var face:uint = _hover?PhantomGUISettings.colorSchemes[colorScheme].colorFaceHover:PhantomGUISettings.colorSchemes[colorScheme].colorFace;
			if (!enabled) {
				border = PhantomGUISettings.colorSchemes[colorScheme].colorBorderDisabled;
				face = PhantomGUISettings.colorSchemes[colorScheme].colorFaceDisabled;
			}
			if (_textField != null) _textField.textColor = border;
			buttonMode = enabled;
			
			var cornerOuter:Number = PhantomGUISettings.cornerOuter;
			var cornerInner:Number = PhantomGUISettings.cornerInner;
			
			if (_controlHeight * 0.5 < cornerOuter || _controlWidth * 0.5 < cornerOuter) {
				cornerOuter = PhantomGUISettings.borderWidth;
				cornerInner = 0;
			}
			
			graphics.clear();
			graphics.beginFill(border);
			graphics.drawRoundRect(_edge, _edge, _controlWidth, _controlHeight, cornerOuter);
			graphics.endFill();
			
			graphics.beginFill(border);
			graphics.drawRoundRect(0, 0, _controlWidth, _controlHeight, cornerOuter);
			graphics.endFill();
			
			graphics.beginFill(face);
			graphics.drawRoundRect(PhantomGUISettings.borderWidth, PhantomGUISettings.borderWidth, _controlWidth-PhantomGUISettings.borderWidth*2, _controlHeight-PhantomGUISettings.borderWidth*2, cornerInner);
			graphics.endFill();
			
			if (_glyph > 0) {
				var dy:Number = _controlHeight * 0.5;
				var dx:Number = dy;
				var s:Number = dy * 1.6;
				graphics.beginFill(border);
				PhantomGlyph.drawGlyph(graphics, _glyph, dx, dy, s);
				graphics.endFill();				
			}
			
			if (drawImage != null) {
				drawImage(graphics, _controlHeight * 0.5, _controlWidth * 0.5, _controlHeight*0.6, border);
				if (_textField.parent != null) _textField.parent.removeChild(_textField);
			}
		}
		
		public function get hover():Boolean { return _hover; }
		
		public function set hover(value:Boolean):void 
		{
			if (_hover != value) {
				_hover = value;
				draw();
			}
		}
		
		public function get pressed():Boolean { return _pressed; }
		
		public function set pressed(value:Boolean):void 
		{
			if (_pressed != value) {
				_pressed = value;
				if (_pressed) {
					x += PhantomGUISettings.press;
					y += PhantomGUISettings.press;
					_edge -= PhantomGUISettings.press;
				} else {
					x -= PhantomGUISettings.press;
					y -= PhantomGUISettings.press;
					_edge += PhantomGUISettings.press;
				}
				draw();
			}
		}
		
		public function get glyph():int { return _glyph; }
		
		public function set glyph(value:int):void 
		{
			_glyph = value;
			draw();
		}
		
		
		
		
		
	}

}