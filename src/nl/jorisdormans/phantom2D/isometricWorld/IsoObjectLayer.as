package nl.jorisdormans.phantom2D.isometricWorld 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.ShaderFilter;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.objects.CollisionData;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.Tile;
	import nl.jorisdormans.phantom2D.objects.TiledObjectLayer;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	import nl.jorisdormans.phantom2D.thirdparty.profiler.Profiler;
	import nl.jorisdormans.phantom2D.thirdparty.profiler.ProfilerConfig;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class IsoObjectLayer extends TiledObjectLayer
	{
		private var p:Vector3D = new Vector3D();
		
		private var isoX:Number = 1;
		private var isoY:Number = 0.707;
		private var isoZ:Number = -0.707;
		private var isoSortX:int = 1;
		private var isoSortY:int = 1;
		private var isoYaw:Number = 0.5;	
		private var isoPitch:Number = 0.5;
		
		
		/**
		 * 
		 * @param	tileSize				The size of the tiles
		 * @param	tilesX					The width of the grid of tiles
		 * @param	tilesY					The height of the grid of tiles
		 * @param	physicsExecutionCount	The number times the physics of the GameObjects are updated every frame. Minimum value is 1, higher values reduce performance, but increase accuracy
		 */
		public function IsoObjectLayer(tileSize:int, tilesX:int, tilesY:int, physicsExecutionCount:int = 1) {
			super(tileSize, tilesX, tilesY, physicsExecutionCount);
			setIsoCameraYaw(0.5);
			setIsoCameraPitch(0.5);
		}
		
		
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			doSort();
			//sortObjects();
		}
		
	
		
		public function doSort():void 
		{
			//one iteration of a bubble sort:
			var l:int = objects.length;
			for (var i:int = 0; i < l; i++) {
				var j:int = i;
				while (j > 0) {
					if (compareObjects(objects[i], objects[j - 1]) < 0) {
						var o:GameObject = objects[i];
						objects.splice(i, 1);
						objects.splice(j-1, 0, o);
						break;
					}
					j--;
				}
				
				j = i;
				while (j > l - 1) {
					if (compareObjects(objects[i], objects[j + 1]) > 0) {
						o = objects[i];
						objects.splice(i, 1);
						objects.splice(j, 0, o);
						break;
					}
					j++;
				}
			}
		}	
		
		override public function addGameObjectSorted(gameObject:GameObject):void 
		{
			gameObject.removed = false;
			if (gameObject.layer != null) {
				gameObject.layer.removeGameObject(gameObject);
			}
			gameObject.layer = this;
			var l:int = objects.length;
			for (var i:int = l-1; i >= 0; i--) {
				if (compareObjects(objects[i], gameObject)<=0) {
					objects.splice(i, 0, gameObject);
					gameObject.placeOnTile();
					return;
				}
			}
			objects.push(gameObject);
			gameObject.placeOnTile();		}
		
		override protected function compareObjects(a:GameObject, b:GameObject):int {
			/*
			//attempt 3 doesn't work
			p.x = a.shape.position.x - b.shape.position.x;
			p.y = a.shape.position.y - b.shape.position.y;
			p.z = a.shape.position.z - b.shape.position.z;
			
			p.x *= isoSortX;
			p.y *= isoSortY;
			
			if (p.z < 0) return -1;
			else if (p.z > 0) return 1;
			else if (p.y < 0) return -1;
			else if (p.y > 0) return 1;
			else if (p.x < 0) return -1;
			else if (p.x > 0) return 1
			else return 0;
			//*/
			
			//*
			//attempt 2b: as attempt 2, but with slightly smaller extremes which looks better with bounidn circles
			var f:Number = 0.86; // magic number
			if (isoSortX>0 && a.shape.position.x + a.shape.left * f >= b.shape.position.x + b.shape.right  * f) {
				return isoSortX;
			} else if (isoSortX<0 && a.shape.position.x + a.shape.right * f <= b.shape.position.x + b.shape.left * f) {
				return -isoSortX;
			} else if (isoSortY>0 && a.shape.position.y + a.shape.top * f >= b.shape.position.y + b.shape.bottom * f) {
				return isoSortY;
			} else if (isoSortY<0 && a.shape.position.y + a.shape.bottom * f <= b.shape.position.y + b.shape.top * f) {
				return -isoSortY;
			} else if (a.shape.position.z > b.shape.position.z + b.shape.isoHeight - 1) {
				return 1;
			} else if (isoSortX<0 && a.shape.position.x + a.shape.left * f >= b.shape.position.x + b.shape.right * f) {
				return isoSortX;
			} else if (isoSortX>0 && a.shape.position.x + a.shape.right * f <= b.shape.position.x + b.shape.left * f) {
				return -isoSortX;
			} else if (isoSortY<0 && a.shape.position.y + a.shape.top * f >= b.shape.position.y + b.shape.bottom * f) {
				return isoSortY;
			} else if (isoSortY>0 && a.shape.position.y + a.shape.bottom * f <= b.shape.position.y + b.shape.top * f) {
				return -isoSortY;
			} else if (a.shape.position.z + a.shape.isoHeight < b.shape.position.z + 1) {
				return -1;
			
			} else {
				return 0;			
			}
			//*/
			
			
			/*
			//attempt 2: trumps attempt1 and works well with rotating camera but has problems with irregular shaped objects
			//Interesting fact: works less well with the complete sort, so must use the half-bubble sort
			//that migth be solved by checking in the direction of all the normals of a shapes size
			if (isoSortX>0 && a.shape.position.x + a.shape.left >= b.shape.position.x + b.shape.right) {
				return isoSortX;
			} else if (isoSortX<0 && a.shape.position.x + a.shape.right <= b.shape.position.x + b.shape.left) {
				return -isoSortX;
			} else if (isoSortY>0 && a.shape.position.y + a.shape.top >= b.shape.position.y + b.shape.bottom) {
				return isoSortY;
			} else if (isoSortY<0 && a.shape.position.y + a.shape.bottom <= b.shape.position.y + b.shape.top) {
				return -isoSortY;
			} else if (a.shape.position.z > b.shape.position.z + b.shape.isoHeight - 1) {
				return 1;
			} else if (isoSortX<0 && a.shape.position.x + a.shape.left >= b.shape.position.x + b.shape.right) {
				return isoSortX;
			} else if (isoSortX>0 && a.shape.position.x + a.shape.right <= b.shape.position.x + b.shape.left) {
				return -isoSortX;
			} else if (isoSortY<0 && a.shape.position.y + a.shape.top >= b.shape.position.y + b.shape.bottom) {
				return isoSortY;
			} else if (isoSortY>0 && a.shape.position.y + a.shape.bottom <= b.shape.position.y + b.shape.top) {
				return -isoSortY;
			} else if (a.shape.position.z + a.shape.isoHeight < b.shape.position.z + 1) {
				return -1;
			
			} else {
				return 0;			
			}
			//*/
			
			/*
			//attempt 1: works well with a fixed camera
			if (a.shape.position.x + a.shape.left >= b.shape.position.x + b.shape.right) {
				return isoSortX;
			} else if (a.shape.position.x + a.shape.right <= b.shape.position.x + b.shape.left) {
				return -isoSortX;
			} else if (a.shape.position.y + a.shape.top >= b.shape.position.y + b.shape.bottom) {
				return isoSortY;
			} else if (a.shape.position.y + a.shape.bottom <= b.shape.position.y + b.shape.top) {
				return -isoSortY;
			} else if (a.shape.position.z > b.shape.position.z + b.shape.isoHeight - 2) {
				return 1;
			} else if (a.shape.position.z + a.shape.isoHeight < b.shape.position.z + 2) {
				return -1;
			
			} else {
				return 0;			
			}
			//*/
		}		
		
			

		override public function render(camera:Camera):void 
		{
			sprite.graphics.clear();
			
			//*
			var l:int = objects.length;
			for (var i:int = 0; i < l; i++) {
				renderIsoObject(objects[i], camera);
			}
			//*/
			
			/*
			//code to draw an extra layer on top to show exact collision data
			var tx:int = (camera.left / tileSize) - 1;
			var ty:int = (camera.top / tileSize) - 1;
			var drawWidth:int = Math.ceil(gameScreen.screenWidth * camera.zoom / tileSize) + 2;
			var drawHeight:int = Math.ceil(gameScreen.screenHeight * camera.zoom / tileSize) + 2;
			
			for (i = 0; i < l; i++) {
				var ox:int = _objects[i].tile.tileX;
				var oy:int = _objects[i].tile.tileY;
				var offsetX:Number = 0;
				var offsetY:Number = 0;
				if (renderWrappedHorizontal) {
					if (ox < tx) {
						ox += tilesX;
						offsetX = layerWidth;
					} else if (ox > tx + drawWidth) {
						ox -= tilesX;
						offsetX = -layerWidth;
					}
				}
				if (renderWrappedVertical) {
					if (oy < ty) {
						oy += tilesY;
						offsetY = layerHeight;
					} else if (oy > ty + drawWidth + 2) {
						oy -= tilesY;
						offsetY = -layerHeight;
					}
				}
				if (ox >= tx && ox < tx + drawWidth && oy >= ty && oy < ty + drawHeight) {
					_objects[i].render(graphics, camera.left-offsetX, camera.top-offsetY, camera.angle, camera.zoom);
					
				}
			}
			//*/
			
			/*
			//render a compass indicating camera angle
			var dx:Number = 50;
			var dy:Number = 50;
			var r:Number = 40;
			graphics.lineStyle(2, 0xffffff);
			graphics.drawCircle(dx, dy, r);
			graphics.moveTo(dx - r, dy);
			graphics.lineTo(dx + r, dy);
			graphics.moveTo(dx - r * 0.707, dy - r * 0.707);
			graphics.lineTo(dx + r * 0.707, dy + r * 0.707);
			graphics.moveTo(dx, dy - r);
			graphics.lineTo(dx, dy + r);
			graphics.moveTo(dx + r * 0.707, dy - r * 0.707);
			graphics.lineTo(dx - r * 0.707, dy + r * 0.707);
			
			graphics.lineStyle(2, 0xff0000);
			graphics.moveTo(dx, dy);
			graphics.lineTo(dx + r * Math.cos(isoYaw), dy + r * Math.sin(isoYaw));
			
			graphics.lineStyle();
			//*/
		}
		
		private function renderIsoObject(object:GameObject, camera:Camera):void {
			p.x = object.shape.position.x - camera.position.x;
			p.y = object.shape.position.y - camera.position.y;
			p.z = object.shape.position.z
			MathUtil.rotateVector3D(p, p, isoYaw);
			p.x *= isoX;
			p.y *= isoY;
			p.z *= isoZ;
			p.y += p.z;
			p.x += gameScreen.screenWidth * 0.5;
			p.y += gameScreen.screenHeight * 0.5;
			for (var i:int = 0; i < object.components.length; i++) {
				if (object.components[i] is IIsoRenerable) {
					(object.components[i] as IIsoRenerable).renderIso(sprite.graphics, p.x, p.y, isoYaw + object.shape.orientation, isoX, isoY, isoZ);
				}
			}
		}
		
		override public function getTile(position:Vector3D, objectSizeOffset:Number = 0):Tile {
			var offsetX:Number = Math.sin(isoYaw) * objectSizeOffset;
			var offsetY:Number = Math.cos(isoYaw) * objectSizeOffset;
			var x:int = Math.max(0, Math.min(tilesX - 1, Math.floor((position.x + offsetX) / tileSize)));
			var y:int = Math.max(0, Math.min(tilesY - 1, Math.floor((position.y + offsetY)/ tileSize)));
			return tiles[x + y * tilesX];
		}
		
		
		public function setIsoCameraYaw(a:Number):void {
			a = MathUtil.normalizeAngle(a);
			isoYaw = a;
			var needFullSort:Boolean = false;
			
			if (Math.cos(isoYaw) < 0) {
				if (isoSortY > 0) {
					isoSortY = -1;
					needFullSort = true;
				}
			} else {
				if (isoSortY < 0) {
					isoSortY = 1;
					needFullSort = true;
				}
			}
			if (Math.sin(isoYaw) < 0) {
				if (isoSortX > 0) {
					isoSortX = -1;
					needFullSort = true;
				}
			} else {
				if (isoSortX < 0) {
					isoSortX = 1;
					needFullSort = true;
				}
			}
			if (needFullSort) {
				sortObjects();
			}
		}
		
		public function changeCameraYaw(d:Number):void {
			setIsoCameraYaw(isoYaw + d);
		}
		
		public function getCameraYaw():Number
		{
			return isoYaw;
		}
		
		public function setIsoCameraPitch(a:Number):void {
			a = Math.min(Math.PI * 0.5, Math.max(0, a));
			isoPitch = a;
			isoY = Math.cos(a);
			isoZ = -Math.sin(a);
		}
		
		public function changeCameraPitch(d:Number):void {
			setIsoCameraPitch(isoPitch + d);
		}
		
		public function getCameraPitch():Number
		{
			return isoPitch;
		}
		
		
		
		
		
	}

}