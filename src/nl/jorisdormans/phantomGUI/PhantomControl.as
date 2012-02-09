package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomControl extends Sprite
	{
		protected var _parent:DisplayObjectContainer;
		private var _showing:Boolean = false;
		private var _enabled:Boolean = true;
		protected var _textField:TextField;
		protected var _caption:String = "";
		protected var _controlX:Number;
		protected var _controlY:Number;
		protected var _controlWidth:Number;
		protected var _controlHeight:Number;
		protected var _captionAlign:String;
		protected const ALIGN_CENTER:String = "center";
		protected const ALIGN_LEFT:String = "left";
		protected const ALIGN_RIGHT:String = "right";
		private var _colorScheme:int = -1;
		
		public function PhantomControl(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, showing:Boolean = true, enabled:Boolean = true) 
		{
			if (parent == null) throw new Error("Parent of a phantomControl cannot be null.");
			_parent = parent;
			_controlX = this.x = x;
			_controlY = this.y = y;
			_controlWidth = width;
			_controlHeight = height;
			this.showing = showing;
			this.enabled = enabled;
			draw();
		}
		
		public function draw():void {
			
		}
		
		public function get showing():Boolean { return _showing; }
		
		public function set showing(value:Boolean):void 
		{
			_showing = value;
			if (!_showing && parent != null) parent.removeChild(this);
			if (_showing && parent == null) _parent.addChild(this);
			if (_showing) redraw();
		}
		
		public function get enabled():Boolean { return _enabled; }
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			draw();
			for (var i:int = 0; i < numChildren; i++) {
				var c:PhantomControl = getChildAt(i) as PhantomControl;
				if (c != null) c.enabled = value;
			}
		}
		
		public function redraw():void 
		{
			draw();
			for (var i:int = 0; i < numChildren; i++) {
				var c:PhantomControl = getChildAt(i) as PhantomControl;
				if (c != null) c.redraw();
			}
		}		
		
		public function get caption():String { return _caption; }
		
		public function set caption(value:String):void 
		{
			_caption = value;
			if (_caption.length > 0) {
				if (_textField == null) createTextField(value);
				else _textField.text = value;
			} else {
				if (_textField != null) {
					_textField.text = "";
				}
			}
			if (_textField!=null) {
				switch (_captionAlign) {
					case this.ALIGN_LEFT:
						_textField.x = PhantomGUISettings.borderWidth * 2;
						break;
					case this.ALIGN_RIGHT:
						_textField.width = _textField.textWidth;
						_textField.x = PhantomGUISettings.borderWidth * 2 + Math.max(0, _controlWidth - PhantomGUISettings.borderWidth * 6 -_textField.textWidth);
						break;
					case this.ALIGN_CENTER:
						_textField.x = PhantomGUISettings.borderWidth * 2 + Math.max(0, _controlWidth - PhantomGUISettings.borderWidth * 6 - _textField.textWidth)*0.5;
						break;
				}
			}
		}
		
		public function get controlWidth():Number { return _controlWidth; }
		
		public function get controlHeight():Number { return _controlHeight; }
		
		public function get colorScheme():int { 
			if (_colorScheme < 0) {
				if (_parent is PhantomControl) return (_parent as PhantomControl).colorScheme;
				else return 0;
			}
			return _colorScheme; 
		}
		
		public function set colorScheme(value:int):void 
		{
			_colorScheme = value;
			redraw();
		}
		
		protected function createTextField(text:String):void
		{
			var color:uint = PhantomGUISettings.colorSchemes[colorScheme].colorFont;
			if (!_enabled) color = PhantomGUISettings.colorSchemes[colorScheme].colorBorderDisabled;
			_textField = new TextField();
			_textField.width = _controlWidth - PhantomGUISettings.borderWidth * 4;
			_textField.x = PhantomGUISettings.borderWidth * 2;
			_textField.height = PhantomGUISettings.fontSize * 1.6;
			_textField.y = (_controlHeight - _textField.height) / 2 - PhantomGUISettings.fontSize * 0.0;
			_textField.selectable = false;
			_textField.mouseEnabled = false;
			if (text.charAt(0) == "*") {
				_textField.defaultTextFormat = new TextFormat(PhantomGUISettings.fontName, PhantomGUISettings.fontSize, color, true);
				text = text.substr(1);
			} else if (text.charAt(0) == "/") {
				_textField.defaultTextFormat = new TextFormat(PhantomGUISettings.fontName, PhantomGUISettings.fontSize, color, false, true);;
				text = text.substr(1);
			} else {
				_textField.defaultTextFormat = new TextFormat(PhantomGUISettings.fontName, PhantomGUISettings.fontSize, color);
			}
			_textField.text = text;
			addChild(_textField);
		}
		
		public function setPosition(x:Number, y:Number):void {
			this.x = _controlX = x;
			this.y = _controlY = y;
		}
		
		public function setSize(width:Number, height:Number):void {
			_controlWidth = width;
			_controlHeight = height;
			draw();
		}
		
		public function getStageX():Number {
			var p:DisplayObjectContainer = parent;
			var r:Number = x;
			while (p != null) {
				r += p.x;
				p = p.parent;
			}
			return r;
		}
		
		public function getStageY():Number {
			var p:DisplayObjectContainer = parent;
			var r:Number = y;
			while (p != null) {
				r += p.y;
				p = p.parent;
			}
			return r;
		}
		
		public function dispose():void {
			if (parent != null) parent.removeChild(this);
		}
		
	}

}