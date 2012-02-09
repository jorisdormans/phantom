package nl.jorisdormans.phantom2D.prefabs.curves 
{
	import flash.display.GraphicsPathCommand;
	import nl.jorisdormans.phantom2D.core.Camera;
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingBoxAA;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingPolygon;
	import nl.jorisdormans.phantom2D.util.PseudoRandom;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Curve
	{
		private var commands:Vector.<int>;
		private var data:Vector.<Number>;
		public var points:Vector.<Vector3D>;
		public var tiles:Vector.<GameObject>;
		public var tileClass:int;
		private var randomSeed:int;
		
		private static const DOWN:int = 1;
		private static const RIGHT:int = 2;
		private static const UP:int = 3;
		private static const LEFT:int = 4;
		public static const POINT_SIZE:int = 5;
		
		
		public function Curve() 
		{
			points = new Vector.<Vector3D>();
			tiles = new Vector.<GameObject>();
			calculateData();
			randomSeed = Math.random() * int.MAX_VALUE;
		}
		
		private function calculateData():void {
			commands = new Vector.<int>();
			data = new Vector.<Number>();
			for (var i:int = 0; i < points.length; i++) {
				var x:Number = points[i].x;
				var y:Number = points[i].y;
				if (i == 0) {
					commands.push(GraphicsPathCommand.MOVE_TO);
					data.push(x, y);
				} else {
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x, y);
				} 
			}
		}
		
		public function renderCurveData(graphics:Graphics, zoom:Number, camera:Camera, selectedCurve:Curve, selectedCurvePoint:int, hoverCurve:Curve, hoverCurvePoint:int):void 
		{
			
			var c:uint = 0xb0b0b0;
			if (selectedCurve == this) c = 0x0066cc;
			
			calculateData();
			for (var i:int = 0; i < data.length; i += 2) {
				data[i] = (data[i] - camera.left)*zoom*camera.zoom;
				data[i+1] = (data[i+1] - camera.top)*zoom*camera.zoom;
			}
			
			graphics.lineStyle(3, 0x00000000);
			graphics.drawPath(commands, data);
			graphics.lineStyle(1, c);
			graphics.drawPath(commands, data);
			
			for (i = 0; i < points.length; i++) {
				var x:Number = (points[i].x - camera.left) * zoom * camera.zoom;
				var y:Number = (points[i].y - camera.top) * zoom * camera.zoom;
				
				graphics.lineStyle(3, 0x0000000);
				renderPoint(graphics, x, y, POINT_SIZE*zoom*camera.zoom);
				
				if (hoverCurve==this && hoverCurvePoint == i) {
					graphics.lineStyle(2, 0xffff00);
				} else if (selectedCurve==this && selectedCurvePoint == i) {
					graphics.lineStyle(2, 0xffffff);
				} else {
					graphics.lineStyle(1, c);
				}
				
				renderPoint(graphics, x, y, POINT_SIZE*zoom*camera.zoom);
			}
			graphics.lineStyle();
		}
		
		public function renderPoint(graphics:Graphics, x:Number, y:Number, size:Number):void {
			graphics.drawRect(x - size, y - size, size * 2, size * 2);
		}
		
		private var previousQuadrant:int;
		private var previousLimit:Number;
		private var previousDX:Number;
		private var previousDY:Number;
		
		public function build(layer:CurveLayer, tileClass:int):void {
			PseudoRandom.seed = randomSeed;
			this.tileClass = tileClass;
			//remove old sections
			for (var i:int = tiles.length - 1; i >= 0; i--) {
				layer.removeGameObject(tiles[i]);
			}
			tiles.splice(0, tiles.length);
			
			calculateData();
			var c:int = 0;
			var d:int = 0;
			var px:Number;
			var py:Number;
			previousQuadrant = -1;
			previousDX = 0;
			previousDY = 0;
			if (data.length > 2) {
				px = data[0];
				py = data[1];
			}
			while (c < commands.length-1) {
				c++;
				d += 2;
				switch (commands[c]) {
					case GraphicsPathCommand.LINE_TO:
						previousQuadrant = buildLine(layer, px, py, data[d], data[d + 1]);
						break;
				}
				px = data[d];
				py = data[d+1];
			}
		}
		
		private function buildLine(layer:CurveLayer, sx:Number, sy:Number, tx:Number, ty:Number):int
		{
			var dx:Number = tx - sx; //unit vector
			var dy:Number = ty - sy;
			var d:Number = Math.sqrt(dx * dx + dy * dy);
			if (d == 0) return -1;
			dx /= d;
			dy /= d;
			var quadrant:int = 0;
			var xdistance:Number;
			var ydistance:Number;
			if (dx > 0 && Math.abs(dy) < dx) {
				quadrant = DOWN;
				if (previousQuadrant == quadrant && sx % layer.tileSize != 0) {
					if (dy < 0) buildCorner(layer, sx, sy, RIGHT);
					else buildCorner(layer, sx, sy, quadrant);
				}
				if (previousQuadrant == LEFT && !((previousDX<=0 && (sx % layer.tileSize) == 0) || (dy<=0 && (sy % layer.tileSize) == 0))) {
					buildCorner(layer, sx, sy, quadrant);
				}
				if (previousQuadrant == UP && sx % layer.tileSize!=0 && dy>0) {
					buildCorner(layer, sx, sy, LEFT);
					buildCorner(layer, sx, sy, quadrant);
				}				
				while (true) {
					if (sx >= tx) break;
					if (Math.floor(sx / layer.tileSize) == Math.floor(tx / layer.tileSize)) {
						previousLimit = createSegment(layer, sx, sy, tx, ty, quadrant);
						break;
					} 
					xdistance = (Math.floor(sx / layer.tileSize) + 1) * layer.tileSize - sx;
					ydistance = (xdistance / dx) * dy;
					previousLimit = createSegment(layer, sx, sy, sx + xdistance, sy + ydistance, quadrant);
					sx += xdistance;
					sy += ydistance;
				}
			} else if (dx < 0 && Math.abs(dy) < -dx) {
				quadrant = UP;
				if (previousQuadrant == quadrant && sx % layer.tileSize != 0) {
					if (dy > 0) buildCorner(layer, sx, sy, LEFT);
					else buildCorner(layer, sx, sy, quadrant);
				}
				if (previousQuadrant == RIGHT && !((previousDX>0 && (sx % layer.tileSize) == 0) || (dy>0 && (sy % layer.tileSize) == 0))) {
					buildCorner(layer, sx, sy, quadrant);
				}
				
				if (previousQuadrant == DOWN && sx % layer.tileSize!=0  && dy<0) {
					buildCorner(layer, sx, sy, RIGHT);
					buildCorner(layer, sx, sy, quadrant);
				}
				
				while (true) {
					if (sx <= tx) break;
					if (Math.ceil(sx / layer.tileSize) == Math.ceil(tx / layer.tileSize)) {
						previousLimit = createSegment(layer, sx, sy, tx, ty, quadrant);
						break;
					} 
					xdistance= (Math.ceil(sx / layer.tileSize)-1) * layer.tileSize - sx;
					ydistance = (xdistance / dx) * dy;
					previousLimit = createSegment(layer, sx, sy, sx + xdistance, sy + ydistance, quadrant);
					sx += xdistance;
					sy += ydistance;
				}
			} else if (dy > 0) {
				quadrant = LEFT;
				if (previousQuadrant == quadrant && sy % layer.tileSize != 0) {
					if (dx>0) buildCorner(layer, sx, sy, DOWN);
					else buildCorner(layer, sx, sy, quadrant);
				}
				if (previousQuadrant == UP && !((dx>0 && (sx % layer.tileSize) == 0) || (previousDY<0 && (sy % layer.tileSize) == 0))) {
					buildCorner(layer, sx, sy, quadrant);
				}
				if (previousQuadrant == RIGHT && sy % layer.tileSize!=0 && dx<0) {
					buildCorner(layer, sx, sy, UP);
					buildCorner(layer, sx, sy, quadrant);
				}
				while (true) {
					if (sy >= ty) break;
					if (Math.floor(sy / layer.tileSize) == Math.floor(ty / layer.tileSize)) {
						previousLimit = createSegment(layer, sx, sy, tx, ty, quadrant);
						break;
					} 
					ydistance = (Math.floor(sy / layer.tileSize)+1) * layer.tileSize - sy;
					xdistance = (ydistance / dy) * dx;
					previousLimit = createSegment(layer, sx, sy, sx + xdistance, sy + ydistance, quadrant);
					sx += xdistance;
					sy += ydistance;
				}
				
			} else {
				quadrant = RIGHT;
				if (previousQuadrant == quadrant && sy % layer.tileSize != 0) {
					if (dx < 0) buildCorner(layer, sx, sy, UP);
					else buildCorner(layer, sx, sy, quadrant);
				}
				if (previousQuadrant == DOWN && !((dx<0 && (sx % layer.tileSize) == 0) || (previousDY>0 && (sy % layer.tileSize) == 0))) {
					buildCorner(layer, sx, sy, quadrant);
				}
				
				if (previousQuadrant == LEFT && sy % layer.tileSize!=0 && dx>0) {
					buildCorner(layer, sx, sy, DOWN);
					buildCorner(layer, sx, sy, quadrant);
				}
				
				while (true) {
					if (sy <= ty) break;
					if (Math.ceil(sy / layer.tileSize) == Math.ceil(ty / layer.tileSize)) {
						previousLimit = createSegment(layer, sx, sy, tx, ty, quadrant);
						break;
					} 
					ydistance = (Math.ceil(sy / layer.tileSize)-1) * layer.tileSize - sy;
					xdistance = (ydistance / dy) * dx;
					if (ydistance == 0) break;
					previousLimit = createSegment(layer, sx, sy, sx + xdistance, sy + ydistance, quadrant);
					sx += xdistance;
					sy += ydistance;
				}
			}
			
			previousDX = dx;
			previousDY = dy;
			
			return quadrant;
			
		}
		
		private function buildCorner(layer:CurveLayer, sx:Number, sy:Number, quadrant:int):void 
		{
			var tx:Number;
			var ty:Number;
			switch (quadrant) {
				default:
				case DOWN:
					tx = layer.tileSize * (Math.ceil(sx / layer.tileSize)-1);
					ty = layer.tileSize * (Math.floor(sy / layer.tileSize)+1);
					break;
				case UP:
					tx = layer.tileSize * (Math.floor(sx / layer.tileSize)+1);
					ty = layer.tileSize * (Math.ceil(sy / layer.tileSize)-1);
					break;
				case RIGHT:
					tx = layer.tileSize * (Math.floor(sx / layer.tileSize)+1);
					ty = layer.tileSize * (Math.floor(sy / layer.tileSize)+1);
					break;
				case LEFT:
					tx = layer.tileSize * (Math.ceil(sx / layer.tileSize)-1);
					ty = layer.tileSize * (Math.ceil(sy / layer.tileSize)-1);
					break;
			}
			if (tx == sx || ty == sy) return;
			
			var o:GameObject = new layer.curveList[tileClass]();
			o.shape = new BoundingBoxAA(new Vector3D((sx + tx) * 0.5, (sy + ty) * 0.5), new Vector3D(Math.abs(sx - tx) * 0.5, Math.abs(sy - ty) * 0.5)); 
			var previous:GameObject;
			if (tiles.length > 0) previous = tiles[tiles.length - 1];
			o.initialize(layer, new Vector3D((sx+tx)*0.5, (sy+ty)*0.5), {previous: previous}); 
			tiles.push(o);
			o.type = GameObject.TYPE_CURVE;
			/*
			switch (quadrant) {
				case DOWN:
					o.handleMessage("changeFillColor", { color:0xffff00 } );
					break;
				case RIGHT:
					o.handleMessage("changeFillColor", { color:0x008800 } );
					break;
				case UP:
					o.handleMessage("changeFillColor", { color:0x880088 } );
					break;
				case LEFT:
					o.handleMessage("changeFillColor", { color:0xff0000 } );
					break;
			}
			//*/
			
			
		}
		
		private function createSegment(layer:CurveLayer, sx:Number, sy:Number,tx:Number, ty:Number, quadrant:int):Number 
		{
			var limit:Number;
			var tileBorder:Number
			var a:Array;
			a = new Array();
			a.push(new Vector3D(0, 0), new Vector3D(tx - sx, ty - sy));
			switch (quadrant) {
				default:
				case DOWN:
					limit = Math.max(sy, ty);
					tileBorder = Math.ceil(limit / layer.tileSize) * layer.tileSize;
					if (ty == sy && ty == tileBorder) tileBorder += layer.tileSize;
					if (tileBorder>ty) a.push(new Vector3D(tx - sx, tileBorder - sy));
					if (tileBorder>sy) a.push(new Vector3D(0, tileBorder - sy));
					break;
				case UP:
					limit = Math.min(sy, ty);
					tileBorder = Math.floor(limit / layer.tileSize) * layer.tileSize;
					if (ty == sy && ty == tileBorder) tileBorder -= layer.tileSize;
					if (tileBorder<ty) a.push(new Vector3D(tx - sx, tileBorder - sy));
					if (tileBorder<sy) a.push(new Vector3D(0, tileBorder - sy));
					break;
				case RIGHT:
					limit = Math.max(sx, tx);
					tileBorder = Math.ceil(limit / layer.tileSize) * layer.tileSize;
					if (tx == sx && tx == tileBorder) tileBorder += layer.tileSize;
					if (tileBorder>tx) a.push(new Vector3D(tileBorder - sx, ty - sy));
					if (tileBorder>sx) a.push(new Vector3D(tileBorder - sx, 0));
					break;
				case LEFT:
					limit = Math.min(sx, tx);
					tileBorder = Math.floor(limit / layer.tileSize) * layer.tileSize;
					if (tx == sx && tx == tileBorder) tileBorder -= layer.tileSize;
					if (tileBorder<tx) a.push(new Vector3D(tileBorder - sx, ty - sy));
					if (tileBorder<sx) a.push(new Vector3D(tileBorder - sx, 0));
					break;
			}
			
			
			//find center
			var cx:Number = 0;
			var cy:Number = 0;
			for (var i:int = 0; i < a.length; i++) {
				cx += a[i].x;
				cy += a[i].y;
			}
			
			cx /= a.length;
			cy /= a.length;
			
			for (i = 0; i < a.length; i++) {
				//a[i] = new Vector3D((a[i] as Vector3D).x - cx, (a[i] as Vector3D).y - cy);
				(a[i] as Vector3D).x -= cx;
				(a[i] as Vector3D).y -= cy;
			}
			
			var o:GameObject = new layer.curveList[tileClass]();
			o.shape = new BoundingPolygon(new Vector3D(sx + cx, sy + cy), a); 
			var previous:GameObject;
			if (tiles.length > 0) previous = tiles[tiles.length - 1];
			o.initialize(layer, new Vector3D(sx + cx, sy + cy), {previous: previous}); 
			tiles.push(o);
			o.type = GameObject.TYPE_CURVE;

			/*
			switch (quadrant) {
				case DOWN:
					o.handleMessage("changeFillColor", { color:0xffff00 } );
					break;
				case RIGHT:
					o.handleMessage("changeFillColor", { color:0x008800 } );
					break;
				case UP:
					o.handleMessage("changeFillColor", { color:0x880088 } );
					break;
				case LEFT:
					o.handleMessage("changeFillColor", { color:0xff0000 } );
					break;
			}
			//*/
			
			return tileBorder;
		}
		
		public function generateXML(layer:CurveLayer):XML {
			var xml:XML = <curve/>;
			xml.@c = StringUtil.getClassName(layer.curveList[tileClass].toString());
			xml.@randomSeed = randomSeed;
			for (var i:int = 0; i < points.length; i++) {
				var point:XML = <point/>;
				point.@x = Math.round(points[i].x);
				point.@y = Math.round(points[i].y);
				xml.appendChild(point);
			}
			return xml;
		}
		
		public function readXML(xml:XML, layer:CurveLayer):void {
			clear();
			//find the class
			randomSeed = xml.@randomSeed;
			for (var i:int = 0; i < layer.curveList.length; i++) {
				if (StringUtil.getClassName(layer.curveList[i].toString()) == xml.@c) {
					tileClass = i;
				}
			}
			
			for (i = 0; i < xml.point.length(); i++) {
				points.push(new Vector3D(xml.point[i].@x, xml.point[i].@y)); 
			}
		}
		
		public function clear():void 
		{
			for (var i:int = tiles.length - 1; i >= 0; i--) {
				tiles[i].layer.removeGameObject(tiles[i]);
			}
			tiles.splice(0, tiles.length);
			points.splice(0, points.length);
		}
		
		
	}

}