package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomTabButton extends PhantomButton
	{
		private var _selected:Boolean;
		public var tab:PhantomPanel;
		
		public function PhantomTabButton(caption:String, action:Function, parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, selected:Boolean = true, showing:Boolean = true, enabled:Boolean = true) 
		{
			_selected = selected;
			super(caption, action, parent, x, y, width, height, showing, enabled);
		}
		
		override protected function mouseUp(e:MouseEvent):void 
		{
			if (pressed) {
				if (!_selected) selected = true;
				pressed = false;
				if (_action != null) _action(this);
			}
		}
		
		override protected function mouseDown(e:MouseEvent):void 
		{
			if (enabled) pressed = true;
		}
		
		override protected function mouseOut(e:MouseEvent):void 
		{
			hover = false;
			if (pressed) pressed = false;
		}
		
		override protected function mouseOver(e:MouseEvent):void 
		{
			if (enabled) hover = true;
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (_selected  == value) return;
			_selected = value;
			_hover = _selected;
			
			if (_selected) {
				if (tab != null) tab.showing = true;
			} else {
				if (tab != null) tab.showing = false;
			}
			
			if (_selected && parent != null) {
				var i:int = 0;
				while (i < parent.numChildren) {
					var other:PhantomTabButton = parent.getChildAt(i) as PhantomTabButton;
					if (other != null && other != this) other.selected = false;
					i++;
				}
			}
			
			draw();
		}
		
		override public function draw():void 
		{
			graphics.clear();
			var border:uint = PhantomGUISettings.colorSchemes[colorScheme].colorBorder;
			var face:uint = _hover?PhantomGUISettings.colorSchemes[colorScheme].colorFaceHover:PhantomGUISettings.colorSchemes[colorScheme].colorFace;
			//var face:uint = PhantomGUISettings.colorSchemes[colorScheme].colorFace;
			if (!enabled) {
				border = PhantomGUISettings.colorSchemes[colorScheme].colorBorderDisabled;
				face = PhantomGUISettings.colorSchemes[colorScheme].colorFaceDisabled;
			}
			if (_textField != null) _textField.textColor = border;
			buttonMode = enabled;
			
			//var cornerOuter:Number = PhantomGUISettings.cornerOuter;
			//var cornerInner:Number = PhantomGUISettings.cornerInner;
			
			
			graphics.beginFill(face);
			if (_selected) graphics.drawRect(PhantomGUISettings.borderWidth*0.5, PhantomGUISettings.borderWidth, _controlWidth - PhantomGUISettings.borderWidth * 1, _controlHeight - PhantomGUISettings.borderWidth * 1);
			else graphics.drawRect(PhantomGUISettings.borderWidth*0.5, PhantomGUISettings.borderWidth+1, _controlWidth - PhantomGUISettings.borderWidth * 1, _controlHeight - PhantomGUISettings.borderWidth * 2-1);
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
		
		override public function get pressed():Boolean { return super.pressed; }
		
		override public function set pressed(value:Boolean):void 
		{
			if (_pressed != value) {
				_pressed = value;
			}
		}
	}

}