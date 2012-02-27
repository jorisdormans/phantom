package nl.jorisdormans.phantom2D.editor 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.core.Screen;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.lightEffects.LightEffectLayer;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingShape;
	import nl.jorisdormans.phantom2D.objects.TiledObjectLayer;
	import nl.jorisdormans.phantom2D.prefabs.curves.Curve;
	import nl.jorisdormans.phantom2D.prefabs.curves.CurveLayer;
	import nl.jorisdormans.phantom2D.util.FileIO;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	import nl.jorisdormans.phantomGUI.PhantomBorder;
	import nl.jorisdormans.phantomGUI.PhantomButton;
	import nl.jorisdormans.phantomGUI.PhantomCheckButton;
	import nl.jorisdormans.phantomGUI.PhantomControl;
	import nl.jorisdormans.phantomGUI.PhantomDialog;
	import nl.jorisdormans.phantomGUI.PhantomEditNumberBox;
	import nl.jorisdormans.phantomGUI.PhantomLabel;
	import nl.jorisdormans.phantomGUI.PhantomPanel;
	import nl.jorisdormans.phantomGUI.PhantomSelectBox;
	import nl.jorisdormans.phantomGUI.PhantomTabButton;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Editor extends Screen
	{
		private var layerBorder:PhantomBorder;
		private var toolBorder:PhantomBorder;
		private var buttonPanel:PhantomPanel;
		private var buttonCloseEditor:PhantomButton;
		private var buttonOpen:PhantomButton;
		private var buttonSave:PhantomButton;
		
		private var toolBox:PhantomSelectBox;
		//private var tabPanels:Vector.<PhantomPanel>;
		private var tabButtons:Vector.<PhantomTabButton>;
		private var layerData:Vector.<LayerData>;
		
		private var currentLayer:Layer;
		private var currentData:LayerData;
		private var drawX:Number = 0;
		private var drawY:Number = 0;
		private var drawW:Number = 0;
		private var drawH:Number = 0;
		private var mousePositionX:Number = 0;
		private var mousePositionY:Number = 0;
		
		private var layerPanelHeight:Number;
		private var layerPanelWidth:Number;
		private var toolPanelWidth:Number;
		private var toolPanelHeight:Number;
		private var scaleFactor:Number;
		private var hoverObject:GameObject;
		private var toolObject:GameObject;
		private var selectedObject:GameObject;
		private var selectedCurve:Curve;
		private var selectedCurvePoint:int;
		private var hoverCurve:Curve;
		private var hoverCurvePoint:int;
		
		private var shiftKey:Boolean;
		private var controlKey:Boolean;
		private var cameraMoveDistance:int;
		
		private var dragStartX:Number;
		private var dragStartY:Number;
		private var doDrag:Boolean;
		
		private var levelFile:FileIO;
		
		public function Editor(width:int, height:int) 
		{
			super(width, height);
			transparent = true;
			propagateUpdate = false;
			
			scaleFactor = (height - 4*28 - 8)/height;
			layerPanelWidth = width;
			layerPanelHeight = (1 - scaleFactor) * height;
			toolPanelWidth = (1 - scaleFactor) * width;
			toolPanelHeight = scaleFactor * height;
			
			toolBorder = new PhantomBorder(this.sprite, width * scaleFactor, 0, toolPanelWidth, toolPanelHeight);
			layerBorder = new PhantomBorder(this.sprite, 0, height * scaleFactor, layerPanelWidth, layerPanelHeight);
			buttonPanel = new PhantomPanel(layerBorder, width * scaleFactor + 2, 2, toolPanelWidth - 4, layerPanelHeight - 4);
			
			buttonCloseEditor = new PhantomButton("New File", newFile, buttonPanel, 10, 4 + 0*28, toolPanelWidth - 24, 24);
			buttonCloseEditor = new PhantomButton("Open File", openFile, buttonPanel, 10, 4 + 1*28, toolPanelWidth - 24, 24);
			buttonCloseEditor = new PhantomButton("Save File", saveFile, buttonPanel, 10, 4 + 2*28, toolPanelWidth - 24, 24);
			buttonCloseEditor = new PhantomButton("Close Editor", closeEditor, buttonPanel, 10, 4 + 3*28, toolPanelWidth - 24, 24);
			
			toolBox = new PhantomSelectBox(toolBorder, 2, 2, toolPanelWidth-4, toolPanelHeight-2);
			toolBox.verticalScrollBarAlwaysVisible = true;
			toolBox.onSelect = changeTool;
			
			//tabPanels = new Vector.<PhantomPanel>();
			tabButtons = new Vector.<PhantomTabButton>();
			layerData = new Vector.<LayerData>();
			
			shiftKey = false;
			
			levelFile = new FileIO();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (e.target is PhantomControl) return;
			//if (!(e.target is Layer) && (e.target!=sprite.stage) && (e.target!=sprite)) return;
			if (e.stageX < layerWidth * scaleFactor && e.stageY < layerHeight * scaleFactor) {
				switch (currentData.editMode) {
					case LayerData.EDIT_CURVES:
						var cl:CurveLayer = currentLayer as CurveLayer;
						if (cl) {
							if (hoverCurve != null) {
								if (selectedCurve != hoverCurve && selectedCurve) {
									selectedCurve.build(currentLayer as CurveLayer, toolBox.selectedIndex);
								}
								selectedCurve = hoverCurve;
								selectedCurvePoint = hoverCurvePoint;
								dragStartX = e.stageX;
								dragStartY = e.stageY;
								doDrag = false;
								toolBox.selectedIndex = selectedCurve.tileClass;
							} else if (selectedCurve) {
								if (selectedCurvePoint < selectedCurve.points.length - 1) {
									selectedCurve.points.splice(selectedCurvePoint+1, 0, new Vector3D(mousePositionX, mousePositionY));
									selectedCurvePoint++;
								} else {
									selectedCurve.points.push(new Vector3D(mousePositionX, mousePositionY));
									selectedCurvePoint = selectedCurve.points.length - 1;
								}
								selectedCurve.build(cl, toolBox.selectedIndex);
							} else {
								selectedCurve = new Curve();
								selectedCurve.points.push(new Vector3D(mousePositionX, mousePositionY));
								cl.curves.push(selectedCurve);
								selectedCurvePoint = 0;
							}
						}
						break;
					case LayerData.EDIT_TILES:
						var tl:TiledObjectLayer = currentLayer as TiledObjectLayer;
						if (e.shiftKey) {
							var s:String;
							if (hoverObject == null) {
								s = "<empty>";
							} else {
								s = hoverObject.toString();
								var i:int = s.indexOf("::");
								s = s.substr(i + 2, s.length - i - 3);
							}
							toolBox.findOption(s);
							return;
						}
						if (toolBox.selectedIndex>=0) {
							if (hoverObject != null) {
								tl.removeGameObject(hoverObject);
								hoverObject = null;
							}
							var c:Class = tl.tileList[toolBox.selectedIndex];
							if (c) {
								var p:Vector3D = new Vector3D();
								hoverObject = new c() as GameObject;
								//put on the center of the tile
								var ts:int = tl.tileSize;
								p.x = (Math.floor(mousePositionX / ts) + 0.5) * ts;
								p.y = (Math.floor(mousePositionY / ts) + 0.5) * ts;
								hoverObject.type = GameObject.TYPE_TILE;
								hoverObject.initialize(tl, p);
							}
						}
						break;
					case LayerData.EDIT_OBJECTS:
						var ol:ObjectLayer = currentLayer as ObjectLayer;
						if (hoverObject) {
							selectedObject = hoverObject;
							if (e.shiftKey) {
								s = hoverObject.toString();
								i = s.indexOf("::");
								s = s.substr(i + 2, s.length - i - 3);
								toolBox.findOption(s);
								if (toolObject && hoverObject) toolObject.copySettings(hoverObject);
								return;
							}							
						} else if (toolBox.selectedIndex>=0) {
							c = ol.objectList[toolBox.selectedIndex];
							if (c) {
								p = new Vector3D(mousePositionX, mousePositionY);
								hoverObject = new c() as GameObject;
								hoverObject.initialize(ol, p);
								hoverObject.id = ol.getNextId();
								if (toolObject) hoverObject.copySettings(toolObject);
								selectedObject = hoverObject;
								toolObject.copySettings(selectedObject);
							}
						}
						dragStartX = e.stageX;
						dragStartY = e.stageY;
						doDrag = false;
						break;
				}
				
			}
		}
		
		private function findHoverCurvePoint(curveLayer:CurveLayer, x:Number, y:Number):void 
		{
			for (var i:int = curveLayer.curves.length - 1; i >= 0; i--) {
				for (var j:int = curveLayer.curves[i].points.length - 1; j >= 0; j--) {
					var dx:Number = x - curveLayer.curves[i].points[j].x;
					var dy:Number = y - curveLayer.curves[i].points[j].y;
					if (Math.abs(dx) < Curve.POINT_SIZE && Math.abs(dy) < Curve.POINT_SIZE) {
						hoverCurve = curveLayer.curves[i];
						hoverCurvePoint = j;
						return;
					}
				}
			}
			hoverCurve = null;
			hoverCurvePoint = -1;
			
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (e.target is PhantomControl) return;
			//if (!(e.target is Layer) && (e.target!=sprite.stage) && (e.target!=sprite)) return;
			if (e.stageX < screenWidth * scaleFactor && e.stageY < screenHeight * scaleFactor) {
				switch (currentData.editMode) {
					case LayerData.EDIT_CURVES:
						var cl:CurveLayer = currentLayer as CurveLayer;
						if (cl) {
							if (doDrag && selectedCurve) {
								selectedCurve.build(cl, toolBox.selectedIndex);
							}
						}
						break;
				}
			}
			
		}
		
		
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if (e.target is PhantomControl) return;
			//if (!(e.target is Layer) && (e.target!=sprite.stage) && (e.target!=sprite)) return;
			hoverObject = null;
			switch (currentData.editMode) {
				case LayerData.EDIT_CURVES:
					var cl:CurveLayer = currentLayer as CurveLayer;
					if (cl) {
						mousePositionX = e.stageX / scaleFactor;
						mousePositionY = e.stageY / scaleFactor;
						mousePositionX += currentLayer.gameScreen.camera.left;
						mousePositionY += currentLayer.gameScreen.camera.top;
						if (controlKey || true) {
							var dx:Number = mousePositionX - cl.tileSize * Math.round(mousePositionX / cl.tileSize);
							var dy:Number = mousePositionY - cl.tileSize * Math.round(mousePositionY / cl.tileSize);
							if (Math.abs(dx) > Math.abs(dy) || Math.abs(dy)<5) {
								mousePositionY -= dy;
							}
							if (Math.abs(dx) < Math.abs(dy) || Math.abs(dx)<5) {
								mousePositionX -= dx;
							}
						}						
						if (e.buttonDown && selectedCurve && selectedCurvePoint>=0) {
							if (!doDrag && Math.abs(dragStartX - e.stageX) > 5 || Math.abs(dragStartY - e.stageY) > 5) doDrag = true;
							if (doDrag) {
								selectedCurve.points[selectedCurvePoint].x = mousePositionX;
								selectedCurve.points[selectedCurvePoint].y = mousePositionY;
							}
							//hoverCurve = selectedObject;
						} else {
							findHoverCurvePoint(cl, mousePositionX, mousePositionY);
						}
						
						
						
					}
					break;
				case LayerData.EDIT_TILES:
					var tl:TiledObjectLayer = currentLayer as TiledObjectLayer;
					if (tl) {
						mousePositionX = e.stageX / scaleFactor;
						mousePositionY = e.stageY / scaleFactor;
						mousePositionX += currentLayer.gameScreen.camera.left;
						mousePositionY += currentLayer.gameScreen.camera.top;
						
						dx = (Math.floor(mousePositionX / tl.tileSize) + 0.5) * tl.tileSize * scaleFactor;
						dy = (Math.floor(mousePositionY / tl.tileSize) + 0.5) * tl.tileSize * scaleFactor;
						drawW = tl.tileSize * scaleFactor;
						drawH = tl.tileSize * scaleFactor;
						hoverObject = tl.getTileObjectAt(mousePositionX, mousePositionY);
						if (dx != drawX || dy != drawY) {
							if (e.buttonDown) {
								onMouseDown(e);
							}
						}
						drawX = dx;
						drawY = dy;
						
						if (mousePositionX < 0) mousePositionX += (currentLayer as ObjectLayer).layerWidth;
						if (mousePositionX >= (currentLayer as ObjectLayer).layerWidth) mousePositionX -= (currentLayer as ObjectLayer).layerWidth;
						drawX -= currentLayer.gameScreen.camera.left * scaleFactor;
						drawY -= currentLayer.gameScreen.camera.top * scaleFactor;
					}					
					
					break;
				case LayerData.EDIT_OBJECTS:
					var ol:ObjectLayer = currentLayer as ObjectLayer;
					if (ol) {
						mousePositionX = e.stageX / scaleFactor;
						mousePositionY = e.stageY / scaleFactor;
						mousePositionX += currentLayer.gameScreen.camera.left;
						mousePositionY += currentLayer.gameScreen.camera.top;
						
						if (controlKey) {
							var ts:int = cameraMoveDistance;
							if (ol is TiledObjectLayer) ts = (ol as TiledObjectLayer).tileSize;
							mousePositionX = ts * (Math.floor(mousePositionX / ts) +0.5);
							mousePositionY = ts * (Math.floor(mousePositionY / ts) +0.5);
						}
						
						if (e.buttonDown && selectedObject) {
							if (!doDrag && Math.abs(dragStartX - e.stageX) > 5 || Math.abs(dragStartY - e.stageY) > 5) doDrag = true;
							if (doDrag) {
								selectedObject.position.x = mousePositionX;
								selectedObject.position.y = mousePositionY;
							}
							hoverObject = selectedObject;
						} else {
							hoverObject = ol.getObjectAt(new Vector3D(mousePositionX, mousePositionY), null, GameObject.TYPE_NORMAL);
						}
						
						if (controlKey) {
							drawX = (mousePositionX - currentLayer.gameScreen.camera.left) * scaleFactor;
							drawY = (mousePositionY - currentLayer.gameScreen.camera.top) * scaleFactor;
						} else {
							drawX = e.stageX;
							drawY = e.stageY;
						}
						
					}
					break;
			}

		}
		
		override public function render(camera:Camera):void 
		{
			super.render(camera);
			sprite.graphics.clear();
			switch (currentData.editMode) {
				case LayerData.EDIT_CURVES:
					(currentLayer as CurveLayer).renderCurveData(sprite.graphics, scaleFactor, selectedCurve, selectedCurvePoint, hoverCurve, hoverCurvePoint);
					var dx:Number = mousePositionX - currentLayer.gameScreen.camera.left;
					var dy:Number = mousePositionY - currentLayer.gameScreen.camera.top;
					dx *= scaleFactor;
					dy *= scaleFactor;
					sprite.graphics.lineStyle(3, 0x000000);
					sprite.graphics.drawCircle(dx, dy, 5 * scaleFactor);
					sprite.graphics.lineStyle(1, 0xffffff);
					sprite.graphics.drawCircle(dx, dy, 5 * scaleFactor);
					sprite.graphics.lineStyle();
					break;
				case LayerData.EDIT_TILES:
					var color:uint = 0xffffff;
					var noShape:Boolean = false;
					if (shiftKey) {
						color = 0x00ff88;
						if (!hoverObject) noShape = true;
					} else {
						if (!toolObject) {
							noShape = true;
							if (hoverObject) color = 0xff0000;
						}
					}
					var s:int = (currentLayer as TiledObjectLayer).tileSize  * scaleFactor * 0.5;
					if (noShape) {
						sprite.graphics.lineStyle(3, 0x000000, 0.5);
						sprite.graphics.moveTo(drawX - s, drawY - s);
						sprite.graphics.lineTo(drawX + s, drawY + s);
						sprite.graphics.moveTo(drawX + s, drawY - s);
						sprite.graphics.lineTo(drawX - s, drawY + s);
						sprite.graphics.lineStyle(1, color);
						sprite.graphics.moveTo(drawX - s, drawY - s);
						sprite.graphics.lineTo(drawX + s, drawY + s);
						sprite.graphics.moveTo(drawX + s, drawY - s);
						sprite.graphics.lineTo(drawX - s, drawY + s);
						sprite.graphics.lineStyle();
					} else {
						sprite.graphics.lineStyle(3, 0x000000, 0.5);
						sprite.graphics.drawRect(drawX - s, drawY - s, s * 2, s * 2);
						sprite.graphics.lineStyle(1, color);
						sprite.graphics.drawRect(drawX - s, drawY - s, s * 2, s * 2);
						sprite.graphics.lineStyle();
						
					}
					
					break;
				case LayerData.EDIT_OBJECTS:
					if (hoverObject && hoverObject.shape) {
						dx = hoverObject.position.x - currentLayer.gameScreen.camera.left;
						dy = hoverObject.position.y - currentLayer.gameScreen.camera.top;
						dx *= scaleFactor;
						dy *= scaleFactor;
						sprite.graphics.lineStyle(3, 0x000000, 0.5);
						hoverObject.shape.drawShape(sprite.graphics, dx, dy, hoverObject.shape.orientation, scaleFactor);
						sprite.graphics.lineStyle(1, 0x0088ff);
						hoverObject.shape.drawShape(sprite.graphics, dx, dy, hoverObject.shape.orientation, scaleFactor);
						sprite.graphics.lineStyle();
					} else if (toolObject && toolObject.shape) {
						sprite.graphics.lineStyle(3, 0x000000, 0.5);
						dx = drawX + toolObject.position.x * scaleFactor;
						dy = drawY + toolObject.position.y * scaleFactor;
						toolObject.shape.drawShape(sprite.graphics, dx, dy, toolObject.shape.orientation, scaleFactor);
						sprite.graphics.lineStyle(1, 0xffffff);
						toolObject.shape.drawShape(sprite.graphics, dx, dy, toolObject.shape.orientation, scaleFactor);
						sprite.graphics.lineStyle();
					}
					if (selectedObject && selectedObject.shape) {
						dx = selectedObject.position.x - currentLayer.gameScreen.camera.left;
						dy = selectedObject.position.y - currentLayer.gameScreen.camera.top;
						dx *= scaleFactor;
						dy *= scaleFactor;
						sprite.graphics.lineStyle(3, 0x000000, 0.5);
						selectedObject.shape.drawShape(sprite.graphics, dx, dy, selectedObject.shape.orientation, scaleFactor);
						sprite.graphics.lineStyle(1, 0xffff00);
						selectedObject.shape.drawShape(sprite.graphics, dx, dy, selectedObject.shape.orientation, scaleFactor);
						sprite.graphics.lineStyle();
					}
			}
			
			if (currentLayer is TiledObjectLayer) {
				sprite.graphics.lineStyle(1, 0xffffff, 0.5);
				var ts:Number = (currentLayer as TiledObjectLayer).tileSize;
				dx = -(currentLayer.gameScreen.camera.left % ts); 
				while (dx < currentLayer.gameScreen.screenWidth) {
					sprite.graphics.moveTo(dx * scaleFactor, 0)
					sprite.graphics.lineTo(dx * scaleFactor, currentLayer.gameScreen.screenHeight * scaleFactor);
					dx += ts;
				}
				
				dy = -(currentLayer.gameScreen.camera.top % ts); 
				while (dy < currentLayer.gameScreen.screenHeight) {
					sprite.graphics.moveTo(0, dy * scaleFactor)
					sprite.graphics.lineTo(currentLayer.gameScreen.screenWidth* scaleFactor, dy * scaleFactor);
					dy += ts;
				}
				sprite.graphics.lineStyle();
				
			}
			
		}
		
		
		
		override public function activate():void 
		{
			super.activate();
			trace("PHANTOM: activating editor");
			cameraMoveDistance = 16;
			
			if (screenBelow) {
				screenBelow.reset();
				screenBelow.sprite.scaleX = scaleFactor;
				screenBelow.sprite.scaleY = scaleFactor;
				screenBelow.editing = true;

				//create interface based on the screen below
				var x:int = 2;
				var panel:PhantomPanel;
				var tabButton:PhantomTabButton;
				for (var i:int = 0; i < screenBelow.components.length; i++) {
					if (screenBelow.components[i] is TiledObjectLayer && (screenBelow.components[i] as TiledObjectLayer).tileList.length>0) {
						cameraMoveDistance = (screenBelow.components[i] as TiledObjectLayer).tileSize;
						layerData.push(new LayerData(screenBelow.components[i] as Layer, LayerData.EDIT_TILES));
						tabButton = new PhantomTabButton("Tiles", changeTab, layerBorder, x, 2, 60, 20);
						panel = new PhantomPanel(layerBorder, 2, 22, layerWidth * scaleFactor - 2, layerPanelHeight - 24, false);
						tabButton.tab = panel;
						tabButtons.push(tabButton);
						x += 60;
					} 
					if (screenBelow.components[i] is CurveLayer && (screenBelow.components[i] as CurveLayer).curveList.length>0) {
						layerData.push(new LayerData(screenBelow.components[i] as Layer, LayerData.EDIT_CURVES));
						tabButton = new PhantomTabButton("Curves", changeTab, layerBorder, x, 2, 60, 20);
						panel = new PhantomPanel(layerBorder, 2, 22, layerWidth * scaleFactor - 2, layerPanelHeight - 24, false);
						tabButton.tab = panel;
						tabButtons.push(tabButton);
						x += 60;
						//add additional controls
						new PhantomButton("New Curve", newCurve, panel, 4, 4, 104);
					} 
					if (screenBelow.components[i] is ObjectLayer && (screenBelow.components[i] as ObjectLayer).objectList.length>0) {
						layerData.push(new LayerData(screenBelow.components[i] as Layer, LayerData.EDIT_OBJECTS));
						tabButton = new PhantomTabButton("Objects", changeTab, layerBorder, x, 2, 60, 20);
						panel = new PhantomPanel(layerBorder, 2, 22, screenWidth * scaleFactor - 2, layerPanelHeight - 24, false);
						tabButton.tab = panel;
						tabButtons.push(tabButton);
						x += 60;
						
						//add additional controls
						new PhantomButton("Object Properties", editProperties, panel, 4, 4, 104);
					} 
					
					if (screenBelow.components[i] is LightEffectLayer) {
						layerData.push(new LayerData(screenBelow.components[i] as Layer, LayerData.EDIT_NOTHING));
						tabButton = new PhantomTabButton("Light", changeTab, layerBorder, x, 2, 60, 20);
						panel = new PhantomPanel(layerBorder, 2, 22, screenWidth * scaleFactor - 2, layerPanelHeight - 24, false);
						tabButton.tab = panel;
						tabButtons.push(tabButton);
						x += 60;
						
						//add controls
						new PhantomLabel("Light Level", panel, 4, 6);
						var light:PhantomEditNumberBox = new PhantomEditNumberBox(0, 2, 0.25, panel, 68, 4, 40, 24);
						light.onChange = changeLight;
						light.value = (screenBelow.components[i] as LightEffectLayer).light;
						light.min = 0;
						light.max = 1;
					}
				}
				
				if (tabButtons.length > 0) {
					changeTab(tabButtons[0]);
					tabButtons[0].tab.showing = true;
				}
			}
			
			sprite.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			sprite.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			sprite.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			sprite.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			sprite.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SHIFT) shiftKey = false;
			if (e.keyCode == Keyboard.CONTROL) controlKey = false;
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.SHIFT) shiftKey = true;
			if (e.keyCode == Keyboard.CONTROL) controlKey = true;
			if (e.keyCode == Keyboard.LEFT && currentLayer) currentLayer.gameScreen.camera.moveCamera( -cameraMoveDistance, 0);
			if (e.keyCode == Keyboard.RIGHT && currentLayer) currentLayer.gameScreen.camera.moveCamera(cameraMoveDistance, 0);
			if (e.keyCode == Keyboard.UP && currentLayer) currentLayer.gameScreen.camera.moveCamera(0, -cameraMoveDistance);
			if (e.keyCode == Keyboard.DOWN && currentLayer) currentLayer.gameScreen.camera.moveCamera(0, cameraMoveDistance);
			if (e.keyCode == Keyboard.DELETE || e.keyCode == Keyboard.BACKSPACE) {
				if (currentData.editMode == LayerData.EDIT_OBJECTS && selectedObject) {
					(currentLayer as ObjectLayer).removeGameObject(selectedObject);
					selectedObject = null;
				}
				if (currentData.editMode == LayerData.EDIT_CURVES && selectedCurve && selectedCurvePoint>=0) {
					(currentLayer as CurveLayer).removeCurvePoint(selectedCurve, selectedCurvePoint);
					selectedCurvePoint--;
					if (selectedCurve.points.length == 0) {
						selectedCurve = null;
					} else {
						selectedCurve.build((currentLayer as CurveLayer), toolBox.selectedIndex);
					}
				}

			}
			if (e.keyCode == 219 || e.keyCode == Keyboard.BACKSPACE) {
				if (toolObject) {
					toolObject.shape.rotateBy( -5 * MathUtil.TO_RADIANS);
				}
				if (selectedObject) {
					selectedObject.shape.rotateBy( -5 * MathUtil.TO_RADIANS);
				}
			}
			if (e.keyCode == 221 || e.keyCode == Keyboard.BACKSPACE) {
				if (toolObject) {
					toolObject.shape.rotateBy(5 * MathUtil.TO_RADIANS);
				}
				if (selectedObject) {
					selectedObject.shape.rotateBy(5 * MathUtil.TO_RADIANS);
				}
			}
		}
		
		override public function deactivate():void 
		{
			sprite.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			sprite.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			sprite.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			sprite.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			sprite.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyDown);
			
			super.deactivate();
			trace("PHANTOM: deactivating editor");
			if (screenBelow) {
				screenBelow.sprite.scaleX = 1;
				screenBelow.sprite.scaleY = 1;
				screenBelow.levelData = screenBelow.generateXML();
				screenBelow.editing = false;
			}
			
			
		}
		
		private function closeEditor(sender:PhantomControl):void {
			sprite.stage.focus = game;
			game.removeScreen(this);
		}
		
		private function newFile(sender:PhantomControl):void {
			var dialog:PhantomDialog = new PhantomDialog(sprite.stage, "*New File", "OK", "Cancel", 600, 400);
			dialog.text = screenBelow.generateNewXML().toXMLString();
			dialog.onOK = createNewFile;
		} 
		
		private function createNewFile(dialog:PhantomDialog):void {
			screenBelow.readXML(new XML(dialog.text));
		}
		
		private function openFile(sender:PhantomControl):void {
			levelFile.onLoadComplete = loadComplete;
			levelFile.openFileDialog("Open Level Data");
		}
		
		private function loadComplete():void {
			screenBelow.readXML(levelFile.data);
		}
		
		private function saveFile(sender:PhantomControl):void {
			levelFile.data = screenBelow.generateXML();
			levelFile.saveFile("level.xml");
		}
		
		private function changeTab(sender:PhantomControl):void {
			for (var i:int = 0; i < tabButtons.length; i++) {
				if (tabButtons[i] == sender) {
					tabButtons[i].selected = true;
					setCurrentLayer(layerData[i]);
				} else {
					tabButtons[i].selected = false;
				}
			}
		}
		
		private function formatClassName(s:String):String {
			return s.substr(7, s.length - 8);
		}
		
		private function setCurrentLayer(layerDataItem:LayerData):void {
			if (currentData == layerDataItem) return;
			currentData = layerDataItem;
			currentLayer = layerDataItem.layer;
			//set the current editMode
			
			//clear toolBox
			toolBox.clearOptions();
			//add options
			if (currentData.editMode == LayerData.EDIT_OBJECTS && currentLayer is ObjectLayer) {
				for (var i:int = 0; i < (currentLayer as ObjectLayer).objectList.length; i++) {
					if ((currentLayer as ObjectLayer).objectList[i]!=null) {
						toolBox.addOption(formatClassName((currentLayer as ObjectLayer).objectList[i]));
					} else {
						toolBox.addOption("<empty>");
					}
				}
			}
			
			if (currentData.editMode == LayerData.EDIT_TILES && currentLayer is TiledObjectLayer) {
				for (i = 0; i < (currentLayer as TiledObjectLayer).tileList.length; i++) {
					if ((currentLayer as TiledObjectLayer).tileList[i]!=null) {
						toolBox.addOption(formatClassName((currentLayer as TiledObjectLayer).tileList[i]));
					} else {
						toolBox.addOption("<empty>");
					}
				}
			}
			
			if (currentData.editMode == LayerData.EDIT_CURVES && currentLayer is CurveLayer) {
				for (i = 0; i < (currentLayer as CurveLayer).curveList.length; i++) {
					if ((currentLayer as CurveLayer).curveList[i]!=null) {
						toolBox.addOption(formatClassName((currentLayer as CurveLayer).curveList[i]));
					} else {
						toolBox.addOption("<empty>");
					}
				}
			}
			
			toolBox.selectedIndex = layerDataItem.tool;
			if (toolBox.onSelect != null) toolBox.onSelect(toolBox);
			selectedObject = null;
			
		}
		private function changeTool(sender:PhantomSelectBox):void {
			if (toolObject != null) {
				toolObject.dispose();
				toolObject = null;
			}
			currentData.tool = toolBox.selectedIndex;
			if (currentData.editMode == LayerData.EDIT_OBJECTS && currentLayer is ObjectLayer) {
				var c:Class = (currentLayer as ObjectLayer).objectList[toolBox.selectedIndex];
				if (c) {
					toolObject = new c() as GameObject;
					toolObject.initialize(null, new Vector3D());
				}
			}
			if (currentData.editMode == LayerData.EDIT_TILES && currentLayer is TiledObjectLayer) {
				c = (currentLayer as TiledObjectLayer).tileList[toolBox.selectedIndex];
				if (c) {
					toolObject = new c() as GameObject;
					toolObject.initialize(null, new Vector3D());
				}
			}
			if (currentData.editMode == LayerData.EDIT_CURVES && currentLayer is CurveLayer) {
				//c = (currentLayer as CurveLayer).curveList[toolBox.selectedIndex];
				if (selectedCurve) {
					selectedCurve.build((currentLayer as CurveLayer), toolBox.selectedIndex);
				}
				//if (c) {
				//	toolObject = new c() as GameObject;
				//	toolObject.initialize(null, new Vector3D());
				//}
				toolObject == null;
			}
			selectedObject = null;
		}
		
		private function changeLight(sender:PhantomEditNumberBox):void {
			if (currentLayer is LightEffectLayer) {
				(currentLayer as LightEffectLayer).setLight(sender.value);
				
			}
			
		}
		
		private function newCurve(sender:PhantomButton):void {
			//if (selectedCurve) {
			//	selectedCurve.build(currentLayer as CurveLayer, toolBox.selectedIndex);
			//}
			selectedCurve = null;
			selectedCurvePoint = -1;
		}
		
		
		private function editProperties(sender:PhantomButton):void {
			if (selectedObject) {
				var dialog:PhantomDialog = new PhantomDialog(sprite.stage, "*Edit Object Properties", "OK", "Cancel", 600, 400);
				dialog.text = selectedObject.generateXML().toXMLString();
				dialog.onOK = changeProperties;
			}
		}
		
		private function changeProperties(dialog:PhantomDialog):void {
			if (selectedObject) {
				var xml:XML = new XML(dialog.text);
				selectedObject.readXML(xml);
				toolObject.copySettingsXML(xml);
			}
		}
		
		
		
	}

}