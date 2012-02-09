package nl.jorisdormans.phantom2D.prefabs.items
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.prefabs.adventure.AdventureMover;
	import nl.jorisdormans.phantom2D.prefabs.players.IHudComponent;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	import nl.jorisdormans.phantom2D.util.TextDraw;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Inventory extends Component implements IHudComponent
	{
		private var size:int;
		private var items:Vector.<Item>;
		private var selectedItem:int;
		private var hoverItem:int;
		private var draggingItem:int;
		private var drawX:Number;
		private var drawY:Number;
		private var drawWidth:Number;
		private var drawHeight:Number;
		private var drawDistance:Number;
		private var drawVertical:Boolean;
		public var visible:Boolean;
		private var mouseDownX:Number;
		private var mouseDownY:Number;
		
		public function Inventory(size:int)
		{
			super();
			this.size = size;
			items = new Vector.<Item>();
			for (var i:int = 0; i < size; i++)
			{
				items.push(null);
			}
			selectedItem = -1;
			hoverItem = -1;
			draggingItem = -1;
			visible = true;
			
			drawX = 600;
			drawY = 8;
			drawWidth = 32;
			drawHeight = 32;
			drawDistance = 40;
			drawVertical = true;
			
			mouseDownX = 0;
			mouseDownY = 0;
		}
		
		override public function handleMessage(message:String, data:Object = null):int
		{
			switch (message)
			{
				case "has item": 
					if (hasItem(data.item))
					{
						return Phantom.MESSAGE_CONSUMED;
					}
					break;
				case "add item": 
					if (addItem(data.item))
					{
						return Phantom.MESSAGE_CONSUMED;
					}
					break;
				case "consume item": 
					if (consumeItem(data.item, data.quantity))
					{
						return Phantom.MESSAGE_CONSUMED;
					}
					break;
				case "drop item": 
					if (dropSelectedItem())
					{
						return Phantom.MESSAGE_CONSUMED;
					}
					break;
				case "select next item": 
					selectNextItem(1);
					return Phantom.MESSAGE_CONSUMED;
				case "select previous item": 
					selectNextItem(-1);
					return Phantom.MESSAGE_CONSUMED;
			}
			return super.handleMessage(message, data);
		}
		
		override public function update(elapsedTime:Number):void
		{
			super.update(elapsedTime);
			//check and remove consumed items
			for (var i:int = 0; i < size; i++)
			{
				if (items[i] && items[i].quantity == 0)
				{
					if (items[i].equipedBy)
						items[i].unequip();
					items[i].dispose();
					items[i] = null;
				}
			}
		}
		
		public function addItem(item:Item):Boolean
		{
			if (!item.canPickUp(gameObject))
				return false;
			trace("picking up", item.itemName);
			var added:int = 0;
			//check unique items (you can carry only one of each
			if (item.unique)
			{
				for (var i:int = 0; i < size; i++)
				{
					if (items[i] && items[i].itemName == item.itemName)
					{
						if (items[i].quantity < items[i].maxQuantity)
						{
							break;
						}
						else
						{
							return false;
						}
					}
				}
			}
			//try to add to existing items in the inventory
			if (item.maxQuantity > 1)
			{
				for (i = 0; i < size; i++)
				{
					if (items[i] && items[i].itemName == item.itemName)
					{
						trace(item.itemName, items[i].itemName);
						var n:int = items[i].maxQuantity - items[i].quantity;
						n = Math.min(item.quantity, n);
						added += n;
						items[i].quantity += n;
						item.quantity -= n;
						//if (selectedItem < 0) selectedItem = i;
						if (item.quantity == 0)
							break;
					}
				}
			}
			
			//try to add to an empty space
			if (item.quantity > 0)
			{
				for (i = 0; i < size; i++)
				{
					if (items[i] == null)
					{
						items[i] = item;
						added += item.quantity;
						//if (selectedItem < 0) selectedItem = i;
						break;
					}
				}
			}
			
			if (added > 0)
			{
				if (item.quantity == 0)
				{
					item.destroyed = true;
				}
				else
				{
					item.removed = true;
					item.onPickUp(gameObject);
				}
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function hasItem(itemName:String):Boolean
		{
			for (var i:int = 0; i < size; i++)
			{
				if (items[i].itemName == itemName && items[i].quantity > 0)
				{
					return true;
				}
			}
			return false;
		}
		
		public function consumeItem(itemName:String, quantity:int, asManyAsPossible:Boolean = true):Boolean
		{
			if (!asManyAsPossible)
			{
				var canConsume:int = 0;
				for (var i:int = 0; i < size; i++)
				{
					if (items[i].itemName == itemName)
					{
						canConsume += items[i].quantity;
					}
				}
				if (canConsume < quantity)
					return false;
			}
			
			var consumed:int = 0;
			for (i = 0; i < size; i++)
			{
				if (items[i] && items[i].itemName == itemName)
				{
					var n:int = Math.min(quantity, items[i].quantity);
					items[i].quantity -= n;
					quantity -= n;
					consumed += n;
					if (quantity == 0)
					{
						break;
					}
				}
			}
			return (consumed > 0);
		}
		
		public function dropSelectedItem(position:Vector3D = null):void
		{
			if (selectedItem < 0 || selectedItem >= size)
				return;
			if (items[selectedItem] == null)
				return;
			if (items[selectedItem].equipedBy)
			{
				//unequip the item first
				items[selectedItem].unequip();
				items[selectedItem].removed = false;
			}
			if (!position)
			{
				position = gameObject.shape.position.clone();
				position.x += Math.cos(gameObject.shape.orientation) * gameObject.shape.getRoughSize();
				position.y += Math.sin(gameObject.shape.orientation) * gameObject.shape.getRoughSize();
			}
			items[selectedItem].drop(position, gameObject);
			items[selectedItem] = null;
			if (gameObject.mover)
				gameObject.mover.sendMessage("drop");
			//selectNextItem(1);
		}
		
		public function selectNextItem(delta:int):void
		{
			var i:int = (selectedItem + delta + size) % selectedItem;
			if (items[i])
			{
				selectedItem = i;
			}
			else
			{
				if (delta < 0 && delta > -size)
				{
					selectNextItem(delta - 1);
				}
				else if (delta > 0 && delta < size)
				{
					selectNextItem(delta + 1);
				}
				else
				{
					selectedItem = -1;
				}
			}
		
		}
		
		private function getIndexOfPosition(mx:Number, my:Number):int
		{
			var x:Number = drawX;
			var y:Number = drawY;
			for (var i:int = 0; i < size; i++)
			{
				if (mx >= x && mx <= x + drawWidth && my >= y && my <= y + drawHeight)
				{
					return i;
				}
				if (drawVertical)
				{
					y += drawDistance;
				}
				else
				{
					x += drawDistance;
				}
			}
			return -1;
		}
		
		public function handleInputMouse(elapsedTime:Number, current:InputState, previous:InputState):Boolean
		{
			var handled:Boolean = false;
			hoverItem = getIndexOfPosition(current.mouseX, current.mouseY);
			if (current.mouseButton && !previous.mouseButton)
			{
				mouseDownX = current.mouseX;
				mouseDownY = current.mouseY;
				if (hoverItem > -1)
				{
					selectedItem = hoverItem;
					handled = true;
				}
			}
			
			var dx:Number = current.mouseX - mouseDownX;
			var dy:Number = current.mouseY - mouseDownY;
			
			if (current.mouseButton && Math.abs(dx) + Math.abs(dy) > 5)
			{
				if (selectedItem >= 0 && draggingItem < 0 && items[selectedItem])
				{
					draggingItem = selectedItem;
				}
			}
			
			if (!current.mouseButton && previous.mouseButton)
			{
				if (draggingItem >= 0)
				{
					if (hoverItem != draggingItem)
					{
						if (hoverItem < 0)
						{
							//var position:Vector3D = new Vector3D();
							//position.x = gameObject.layer.gameScreen.camera.left + gameObject.layer.gameScreen.game.currentInputState.mouseX;
							//position.y = gameObject.layer.gameScreen.camera.top + gameObject.layer.gameScreen.game.currentInputState.mouseY;
							//dropSelectedItem(position);
							dropSelectedItem();
						}
						else if (items[hoverItem] && items[hoverItem].maxQuantity > items[hoverItem].quantity && items[hoverItem].itemName == items[draggingItem].itemName)
						{
							mergeItems(draggingItem, hoverItem);
						}
						else
						{
							swapItems(hoverItem, draggingItem);
						}
					}
					handled = true;
				}
				else
				{
					if (selectedItem >= 0 && items[selectedItem])
					{
						if (items[selectedItem].equipedBy)
						{
							items[selectedItem].unequip();
						}
						else
						{
							items[selectedItem].equip(gameObject);
						}
						handled = true;
					}
				}
				
				selectedItem = -1;
				draggingItem = -1;
			}
			return handled;
		}
		
		private function swapItems(item1:int, item2:int):void
		{
			var item:Item = items[item1];
			items[item1] = items[item2];
			items[item2] = item;
		}
		
		private function mergeItems(source:int, destination:int):void
		{
			var n:int = items[destination].maxQuantity - items[destination].quantity;
			n = Math.min(n, items[source].quantity);
			
			items[destination].quantity += n;
			items[source].quantity -= n;
			if (items[source].quantity == 0)
			{
				items[source].dispose();
				items[source] = null;
			}
		}
		
		override public function onRemove():void
		{
			if (gameObject.destroyed)
			{
				while (items.length > 0)
				{
					if (items[0])
					{
						var p:Vector3D;
						if (items[0].layer)
						{
							p = items[0].shape.position;
						}
						else
						{
							p = gameObject.shape.position.clone();
							p.x += (Math.random() - Math.random()) * 0.5 * gameObject.shape.getRoughSize();
							p.y += (Math.random() - Math.random()) * 0.5 * gameObject.shape.getRoughSize();
							items[0].shape.setOrientation(Math.random() * MathUtil.TWO_PI);
						}
						items[0].drop(p, gameObject);
					}
					items.splice(0, 1);
				}
			}
			super.onRemove();
		}
		
		/* INTERFACE phantom2D.prefabs.players.IHudComponent */
		
		public function drawToHud(graphics:Graphics):void
		{
			if (!visible)
				return;
			var x:Number = drawX;
			var y:Number = drawY;
			//trace(hoverItem, selectedItem, draggingItem);
			for (var i:int = 0; i < size; i++)
			{
				var colorFill:uint = 0xbbbbbb;
				var colorBorder:uint = 0xbbbbbb;
				var alpha:Number = 0.2;
				
				if (items[i])
				{
					alpha = 0.5;
					if (items[i].equipedBy == gameObject)
					{
						colorFill = 0x00bb00;
						colorBorder = 0x00bb00;
					}
				}
				
				if (i == selectedItem || i == draggingItem)
				{
					alpha = 0.5;
					colorBorder = 0xffff00;
					colorFill = 0xffff00;
				}
				
				if (i == hoverItem)
				{
					colorBorder = 0xffffff;
				}
				
				drawItemContainer(graphics, x, y, drawWidth, drawHeight, colorBorder, colorFill, alpha);
				
				if (items[i] && i != draggingItem)
				{
					items[i].drawInInventory(graphics, x + drawWidth * 0.5, y + drawHeight * 0.5);
					if (items[i].quantity > 1)
					{
						TextDraw.drawTextRight(graphics, x + drawWidth - 2, y + drawHeight - 8, 20, 20, items[i].quantity.toString(), 0xffffff, 12);
					}
				}
				
				if (drawVertical)
				{
					y += drawDistance;
				}
				else
				{
					x += drawDistance;
				}
			}
			
			if (draggingItem >= 0)
			{
				items[draggingItem].drawInInventory(graphics, gameObject.layer.gameScreen.game.currentInputState.mouseX, gameObject.layer.gameScreen.game.currentInputState.mouseY);
				if (items[draggingItem].quantity > 1)
				{
					TextDraw.drawTextRight(graphics, gameObject.layer.gameScreen.game.currentInputState.mouseX + drawWidth * 0.5 - 2, gameObject.layer.gameScreen.game.currentInputState.mouseY + drawHeight * 0.5 - 8, 20, 20, items[draggingItem].quantity.toString(), 0xffffff, 12);
				}
			}
		
		}
		
		private function drawItemContainer(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, colorBorder:uint, colorFill:uint, alpha:Number):void
		{
			graphics.beginFill(colorFill, alpha);
			graphics.lineStyle(2, colorBorder, alpha * 2);
			graphics.drawRect(x, y, width, height);
			graphics.lineStyle();
			graphics.endFill();
		}
	}

}