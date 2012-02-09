package nl.jorisdormans.phantom2D.ai 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.Tile;
	import nl.jorisdormans.phantom2D.objects.TiledObjectLayer;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AStarPathFinder 
	{
		
		public function AStarPathFinder() 
		{
			
		}
		
		private static var LIST_UNWALKABLE:int = -1;
		private static var LIST_NONE:int = 0;
		private static var LIST_CHECK:int = 1;
		private static var LIST_CLOSED:int = 2;
		
		
		public static function findPath(start:Vector3D, finish:Vector3D, layer:TiledObjectLayer, maxDistance:int, forObject:GameObject = null):Vector.<Vector3D> {
			var m:int = maxDistance;
			var sx:int = MathUtil.clamp(Math.floor(start.x / layer.tileSize), 0, layer.tilesX);
			var sy:int = MathUtil.clamp(Math.floor(start.y / layer.tileSize), 0, layer.tilesY);
			var startTile:Tile = layer.tiles[sx+sy*layer.tilesX];
			var ex:int = MathUtil.clamp(Math.floor(finish.x / layer.tileSize), 0, layer.tilesX);
			var ey:int = MathUtil.clamp(Math.floor(finish.y / layer.tileSize), 0, layer.tilesY);
			var endTile:Tile = layer.tiles[ex + ey * layer.tilesX];
			
			if (endTile == startTile) {
				var path:Vector.<Vector3D> = new Vector.<Vector3D>();
				path.push(finish, start);
				return path;
			}
			
			var visitedTiles:Vector.<int> = new Vector.<int>();
			startTile.aStarDistance = 0;
			startTile.aStarList = LIST_CHECK;
			checkWalkable(startTile, forObject);
			visitedTiles.push(startTile.index);
			
			endTile.aStarList = LIST_NONE;
			
			while (endTile.aStarList == LIST_NONE && maxDistance > 0) {
				maxDistance--;
				//trace("A Star iteration", visitedTiles.length);
				var l:int = visitedTiles.length - 1;
				while (l >= 0) {
					var tile:Tile = layer.tiles[visitedTiles[l]];
					if (tile.aStarList == LIST_CHECK) {
						if (checkTile(tile, layer, visitedTiles, forObject)) {
							break;
						}
					} else if (tile.aStarList == LIST_CLOSED) {
						if (l == visitedTiles.length - 1) {
							clearData(layer, visitedTiles);
							return null; //no path found
						} else {
							break;
						}
					}
					l--;
				}
			}
			if (endTile.aStarList != LIST_NONE) {
				//path found
				//var path:Vector.<Vector3D> = new Vector.<Vector3D>();
				path = new Vector.<Vector3D>();
				path.push(finish);
				tile = endTile;
				while (tile != startTile && m > 0) {
					m--;
					var nextTile:Tile = layer.tiles[tile.aStarPrevious];
					if (!nextTile) break;
					if (nextTile!=startTile) {
						path.push(new Vector3D((nextTile.tileX + 0.5) * layer.tileSize, (nextTile.tileY + 0.5) * layer.tileSize));
					}
					tile = nextTile;
				}
				path.push(start);
				clearData(layer, visitedTiles);
				return path;
			}
			clearData(layer, visitedTiles);
			return null;
			
		}
		
		static private function clearData(layer:TiledObjectLayer, visitedTiles:Vector.<int>):void 
		{
			for (var i:int = 0; i < visitedTiles.length; i++) {
				layer.tiles[visitedTiles[i]].aStarList = LIST_NONE;
				layer.tiles[visitedTiles[i]].aStarDistance = 0;
			}
		}
		
		private static var directions:Array = new Array(1, 0, 1, 1, 0, 1, -1, 1, -1, 0, -1, -1, 0, -1, 1, -1);
		
		static private function checkTile(tile:Tile, layer:TiledObjectLayer, visitedTiles:Vector.<int>, forObject:GameObject = null):Boolean 
		{
			for (var i:int = 0; i < 8; i++) {
				var tx:int = tile.tileX + directions[i * 2] as int;
				var ty:int = tile.tileY + directions[i * 2 + 1] as int;
				
				if (tx >= 0 && tx < layer.tilesX && ty >= 0 && ty < layer.tilesY) {
					var checkTile:Tile = layer.tiles[tx + ty * layer.tilesX];
					if (checkTile.aStarList == LIST_NONE) checkWalkable(checkTile, forObject);
					if (!checkTile.aStarList != LIST_UNWALKABLE) {
						var dist:Number = tile.aStarDistance;
						var doCheck:Boolean = true;
						if (i % 2 == 0) {
							dist += 1;
						} else {
							//prevent curring corners
							tx = tile.tileX + directions[(i * 2 + 2) % 16] as int;
							ty = tile.tileY + directions[(i * 2 + 3) % 16] as int;
							var orthoTile:Tile = layer.tiles[tx + ty * layer.tilesX];
							if (orthoTile.aStarList == LIST_NONE) {
								checkWalkable(orthoTile, forObject);
								if (orthoTile.aStarList == LIST_UNWALKABLE) {
									visitedTiles.splice(0, 0, orthoTile.index);
									doCheck = false;
								}
							} else if (orthoTile.aStarList == LIST_UNWALKABLE) {
								doCheck = false;
							}
							
							tx = tile.tileX + directions[(i * 2 + 14) % 16] as int;
							ty = tile.tileY + directions[(i * 2 + 15) % 16] as int;
							orthoTile = layer.tiles[tx + ty * layer.tilesX];
							if (orthoTile.aStarList == LIST_NONE) {
								checkWalkable(orthoTile, forObject);
								if (orthoTile.aStarList == LIST_UNWALKABLE) {
									visitedTiles.splice(0, 0, orthoTile.index);
									doCheck = false;
								}
							} else if (orthoTile.aStarList == LIST_UNWALKABLE) {
								doCheck = false;
							}
							
							
							
							dist += 1.4;
						}
						
						if (doCheck) {
							switch (checkTile.aStarList) {
								case LIST_NONE:
									checkTile.aStarList = LIST_CHECK;
									checkTile.aStarDistance = dist;
									checkTile.aStarPrevious = tile.index;
									visitedTiles.push(checkTile.index);
									break;
								case LIST_CHECK:
									if (checkTile.aStarDistance>dist) {
										checkTile.aStarDistance = dist;
										checkTile.aStarPrevious = tile.index;
									}
									if (checkTile.aStarDistance == dist && Math.random()<0.5) {
										checkTile.aStarPrevious = tile.index;
									}
									break;
								case LIST_CLOSED:
									if (checkTile.aStarDistance>dist) {
										checkTile.aStarDistance = dist;
										checkTile.aStarList = LIST_CHECK;
										checkTile.aStarPrevious = tile.index;
										visitedTiles.push(checkTile.index);
									}
									break;
							}
						}
					} else {
						visitedTiles.splice(0, 0, orthoTile.index);
					}
				}
				
			}
			tile.aStarList = LIST_CLOSED;
			return false;
		}
		
		private static function checkWalkable(tile:Tile, forObject:GameObject = null):Boolean {
			for (var i:int = 0; i < tile.objects.length; i++) {
				if (tile.objects[i].mover == null && (forObject == null || tile.objects[i].canCollideWith(forObject)) && tile.objects[i].doResponse) {
					tile.aStarList = LIST_UNWALKABLE;
					return false;
				}
			}
			return true;
		}
		
		
	}

}