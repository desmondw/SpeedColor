package  
{
	import adobe.utils.CustomActions;
	import flash.events.KeyboardEvent;
	import flash.utils.*;
	import org.flixel.*;
	
	public class GameState extends FlxState
	{
		private var startTime:Number; //seconds
		private var time:Number; //seconds
		
		private var colors:Array;
		private var keys:Array;
		private var boxes:Array;
		private var bgColorIndex:int;
		
		private var txt_time:FlxText;
		private var nextColorTime:int;
		
		private var grp_boxes:FlxGroup;
		
		override public function create():void
		{
			//TODO: turn off flixel pause onLoseFocus
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			//start a new game
			newGame();
		}
		
		public function newGame():void
		{
			//initialization
			FlxG.bgColor = FlxU.makeColor(0, 0, 0, 1);
			startTime = getTimer();
			time = 0;
			txt_time = new FlxText(FlxG.width / 2, FlxG.height / 2, FlxG.width, "0.0");
			nextColorTime = 10 * 1000;
			colors = new Array();
			keys = new Array();
			boxes = new Array();
			grp_boxes = new FlxGroup();
			
			//generate colors
			for (var i:int = 0; i < Resource.NUM_START_COLORS; i++) 
				addColor();
			changeColor();
			
			add(grp_boxes);
			add(txt_time);
		}
		
		override public function update():void
		{
			time = getTimer() - startTime;
			txt_time.text = Util.getFormatedTime(time, 2);
			
			if (time >= nextColorTime)
			{
				addColor();
				nextColorTime += 1000;// nextColorTime * 1.3;
			}
		}
		
		private function addColor():void 
		{
			//TODO: add check to test generated color against current colors and make sure is not to similar
			//TODO: add more specific color pallete (eg, only 0-50 and 205-55)
			colors.push(FlxU.makeColor(Util.randInt(0, 255), Util.randInt(0, 255), Util.randInt(0, 255), 1));
			keys.push(null);
			var boxRow:int = boxes.length * Resource.BOX_SIZE / FlxG.width;
			var box:FlxSprite = new FlxSprite((boxes.length * Resource.BOX_SIZE) - (boxRow * FlxG.width), boxRow * Resource.BOX_SIZE);
			box.makeGraphic(Resource.BOX_SIZE, Resource.BOX_SIZE, colors[colors.length - 1]);
			boxes.push(box);
			grp_boxes.add(boxes[boxes.length - 1]);
		}
		
		private function changeColor():void
		{
			var newColorIndex:int;
			
			do
				newColorIndex = Util.randInt(0, colors.length - 1);
			while (colors[newColorIndex] == FlxG.bgColor)
			
			FlxG.bgColor = colors[newColorIndex];
			bgColorIndex = newColorIndex;
		}
		
		private function handleKeyDown(e:KeyboardEvent):void
		{
			if (keys[bgColorIndex] == null)
				input_register(e.charCode); //not keyed yet
			else if (keys[bgColorIndex] == e.charCode)
				input_correct(); //good press
			else
				input_incorrect(); //bad press
		}
		
		private function input_register(keyCode:int):void
		{
			//checks to see if key already registered
			for (var i:int = 0; i < keys.length; i++) 
			{
				if (keys[i] == keyCode)
				{
					input_incorrect();
					return;
				}
			}
			
			keys[bgColorIndex] = keyCode;
			changeColor();
		}
		
		private function input_correct():void
		{
			//FlxG.play(Resource.yes);
			changeColor();
		}
		
		private function input_incorrect():void
		{
			FlxG.play(Resource.no);
		}
	}
}