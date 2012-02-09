package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomDialog extends Sprite
	{
		public var onOK:Function;
		public var onCancel:Function;
		public var afterClose:Function;
		private var _veil:Sprite;
		private var _width:int;
		private var _height:int;
		private var _buttonOK:PhantomButton;
		private var _buttonCancel:PhantomButton;
		private var _textField:TextField;
		private var _caption:TextField;
		private var _colorScheme:int = 0;
		
		public function PhantomDialog(parent:DisplayObjectContainer, caption:String, ok:String, cancel:String, width:Number, height:Number, x:Number=-1, y:Number=-1) 
		{
			_width = width;
			_height = height;
			//if (x < 0) x = 0.5 * (Math.min(parent.width, 800) - width);
			//if (y < 0) y = 0.5 * (Math.min(parent.height, 600) - height);
			if (x < 0) x = 0.5 * (parent.stage.stageWidth - width);
			if (y < 0) y = 0.5 * (parent.stage.stageHeight - height);
			this.x = x;
			this.y = y;
			colorScheme = 0;
			draw();
			
			_veil = new Sprite();
			_veil.graphics.clear();
			_veil.graphics.beginFill(PhantomGUISettings.colorVeil, PhantomGUISettings.veilAlpha);
			_veil.graphics.drawRect(0, 0, parent.width, parent.height);
			_veil.graphics.endFill();
			
			parent.addChild(_veil);
			parent.addChild(this);
			
			createCaption(caption);
			createTextField("textField");
			
			
			if (cancel != "") {
				_buttonCancel = new PhantomButton(cancel, _doCancel, this, width - 92, height - 28);	
				if (ok!="") _buttonOK = new PhantomButton(ok, _doOK, this, width - 96 - 92, height - 28);	
			} else {
				if (ok!="") _buttonOK = new PhantomButton(ok, _doOK, this, width - 92, height - 28);	
			}
			afterClose = null;
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		
		public function get colorScheme():int { 
			if (_colorScheme < 0) {
				return 0;
				//if (_parent is PhantomControl) return (_parent as PhantomControl).colorScheme;
				//else return 0;
			}
			return _colorScheme; 
		}
		
		public function set colorScheme(value:int):void 
		{
			_colorScheme = value;
			draw();
		}		
		
		
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			e.stopImmediatePropagation();
		}
		
		public function draw():void 
		{
			graphics.clear();
			graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorFace);
			graphics.drawRect( 0, 24, _width, _height-24);
			graphics.endFill();
			
			graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorBorder);
			graphics.drawRect( 0, 0, _width, 24);
			graphics.endFill();
			
			graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorFaceHover);
			graphics.drawRect( -1, -1, _width + 1, 1);
			graphics.drawRect( -1, 0, 1, _height);
			graphics.drawRect( 0, 24, _width -1, 1);
			graphics.drawRect( width-2, 0, 1, 24);
			graphics.endFill();
			
			graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorBorder);
			graphics.drawRect( _width, -1, 1, height+1);
			graphics.drawRect( -1, _height, _width+1, 1);
			graphics.endFill();
		}
		
		private function _doOK(sender:Object):void {
			if (onOK != null) onOK(this);
			close();
		}
		
		private function _doCancel(sender:Object):void {
			if (onCancel != null) onCancel(this);
			close();
		}
		
		public function close():void {
			dispose();
		}
		
		public function dispose():void 
		{
			removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.focus = parent;
			var c:int = 0;
			while (c < numChildren) {
				var child:PhantomControl = getChildAt(c) as PhantomControl;
				if (child != null) child.dispose();
				else c++;
			}
			parent.removeChild(_veil);
			parent.removeChild(this);
			if (afterClose != null) afterClose();
		}
		
		private function createTextField(text:String):void
		{
			var color:uint = PhantomGUISettings.colorSchemes[colorScheme].colorFont;
			_textField = new TextField();
			_textField.border = true;
			_textField.borderColor = PhantomGUISettings.colorSchemes[colorScheme].colorBorder;
			_textField.background = true;
			_textField.backgroundColor = 0xffffff;
			_textField.width = _width - PhantomGUISettings.borderWidth * 4;
			_textField.x = PhantomGUISettings.borderWidth * 2;
			_textField.height = _height - 60;
			_textField.y = 28;
			_textField.selectable = true;
			_textField.mouseEnabled = true;
			_textField.multiline = true;
			_textField.wordWrap = true;
			if (text.charAt(0) == "*") {
				_textField.defaultTextFormat = new TextFormat(PhantomGUISettings.fontNameFixed, PhantomGUISettings.fontSizeFixed, color, true);
				text = text.substr(1);
			} else if (text.charAt(0) == "/") {
				_textField.defaultTextFormat = new TextFormat(PhantomGUISettings.fontNameFixed, PhantomGUISettings.fontSizeFixed, color, false, true);;
				text = text.substr(1);
			} else {
				_textField.defaultTextFormat = new TextFormat(PhantomGUISettings.fontNameFixed, PhantomGUISettings.fontSizeFixed, color);
			}
			_textField.text = text;
			addChild(_textField);
			
			_textField.type = TextFieldType.INPUT;
		}

		private function createCaption(text:String):void
		{
			var color:uint = PhantomGUISettings.colorSchemes[colorScheme].colorFaceHover;
			_caption = new TextField();
			_caption.width = _width - PhantomGUISettings.borderWidth * 4;
			_caption.x = PhantomGUISettings.borderWidth * 2;
			_caption.height = PhantomGUISettings.fontSize * 1.6;
			_caption.y = PhantomGUISettings.borderWidth * 2;
			_caption.selectable = false;
			_caption.mouseEnabled = false;
			if (text.charAt(0) == "*") {
				_caption.defaultTextFormat = new TextFormat(PhantomGUISettings.fontName, PhantomGUISettings.fontSize, color, true);
				text = text.substr(1);
			} else if (text.charAt(0) == "/") {
				_caption.defaultTextFormat = new TextFormat(PhantomGUISettings.fontName, PhantomGUISettings.fontSize, color, false, true);;
				text = text.substr(1);
			} else {
				_caption.defaultTextFormat = new TextFormat(PhantomGUISettings.fontName, PhantomGUISettings.fontSize, color);
			}
			_caption.text = text;
			addChild(_caption);
		}
		
		public function get text():String {
			return _textField.text;
		}
		
		public function set text(value:String):void {
			_textField.text = value;
		}
		
		
	}
	
}