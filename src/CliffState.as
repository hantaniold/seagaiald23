package
{
	import entity.Canvas;
	import entity.Player;
	import entity.SittingGirl;
	import flash.display.*;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
    import Playtomic.Log;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	
	/**
	 * ...
	 * @author seagaia
	 */
	public class CliffState extends FlxState
	{
		[Embed(source="../img/cliff_bg.png")]
		public var BG:Class;
		[Embed(source="../img/cliff_fg.png")]
		public var FG:Class;
		[Embed(source="../img/canvas_stand.png")]
		public var CanvasStand:Class;
		[Embed(source="../cliffsong/cliffsong.mp3")]
		public var CliffSong:Class;
		public var canvas:Canvas = new Canvas(new Rectangle(413, 184, 100, 100));
		public var canvas_stand:FlxSprite;
		
		// stuff for GFX
		public var bg:FlxSprite = new FlxSprite(0, 0);
		public var bg_overlay:FlxSprite = new FlxSprite(0, 0);
		public var bg_overlay_color_transform:ColorTransform = new ColorTransform(1, 1, 1, 1, 4, 4, 4);
		public var fg:FlxSprite = new FlxSprite(0, 0);
		public var fgBuf:BitmapData;
		public var fgCopy:BitmapData;
		public var offsetPoint:Point = new Point(0, 0);
		public var doGraphicalEffect:Boolean = false;
		public var doGraphicalEffect_counter:int = 0;
		
		public var player:Player = new Player(40, 220);
		public var sittingGirl:SittingGirl = new SittingGirl(527, 243);
		public var exitBlur:BlurFilter = new BlurFilter(5, 2, 1);
		public var bgBlur:BlurFilter = new BlurFilter(1.5, 1.5, 1);
		public var fgBlur:BlurFilter = new BlurFilter(1, 1, 1);
		
		public var MOUSE_DEBUG:FlxText = new FlxText(0, 0, 400, "");
		
		public var event_pos:int = 0;
		public var dialogue_timer:Number = 0;
		public var dialogue_pos:int = 0;
		public var d:Array = new Array();
		public var exitTimer:Number = 0;
		
		public var doDrawing_1:Boolean = false;
		public var doDrawing_2:Boolean = false;
		
		override public function create():void
		{
        
							trace(canvas.colorIndex);
							trace(Registry.colors[canvas.colorIndex])
							trace(Registry.colors);
			FlxG.music = new FlxSound();
			FlxG.music.loadEmbedded(CliffSong, true);
			FlxG.music.play();
			Registry.init();
			add(Registry.keywatch);
			bg.loadGraphic(BG, false, false, 640, 480);
			add(bg);
			bg_overlay.makeGraphic(640, 480, 0x88111195);
			add(bg_overlay);
			bg.pixels.applyFilter(bg.pixels, bg.pixels.rect, bg.pixels.rect.topLeft, bgBlur);
			bg.dirty = true;
			
			fg.loadGraphic(FG, false, false, 640, 480);
			add(fg);
			fg.pixels.applyFilter(fg.pixels, fg.pixels.rect, fg.pixels.rect.topLeft, bgBlur);
			fg.dirty = true;
			fgBuf = new BitmapData(640, 480, true, 0x00000000);
			fgCopy = new BitmapData(640, 480, true, 0x00000000);
			fgCopy.copyPixels(fg.pixels, fg.pixels.rect, fg.pixels.rect.topLeft);
			
			canvas_stand = new FlxSprite(canvas.x - 10, canvas.y - 14);
			canvas_stand.loadGraphic(CanvasStand, false, false, 120, 150);
			add(canvas_stand);
			
			add(canvas);
			
			add(canvas.base);
			add(canvas.horizontal_marker);
			add(canvas.vertical_marker);
			add(player);
			add(player.text);
			add(player.press_x);
			add(sittingGirl);
			add(sittingGirl.text);
			
			//add(MOUSE_DEBUG);
			//FlxG.mouse.show();
		}
		
		override public function update():void
		{
			
			events();
			
			//some funky blur fx and offset stuff
			if (doGraphicalEffect)
			{
				fgBuf.copyPixels(fgCopy, fgCopy.rect, fgCopy.rect.topLeft);
				fgBuf.applyFilter(fgBuf, fgBuf.rect, fgBuf.rect.topLeft, fgBlur);
				fgBlur.blurX = Math.random() * 7 + 1;
				fg.pixels.copyPixels(fgBuf, fgBuf.rect, fgBuf.rect.topLeft);
				fgBuf.copyChannel(fg.pixels, fg.pixels.rect, offsetPoint, BitmapDataChannel.RED, BitmapDataChannel.RED);
				fg.pixels.copyPixels(fgBuf, fgBuf.rect, fgBuf.rect.topLeft);
				offsetPoint.x = -15 + Math.random() * 30;
				offsetPoint.y = -5 + Math.random() * 10;
				fg.dirty = true;
				doGraphicalEffect = false;
			}
			else
			{
				doGraphicalEffect_counter++;
				if (doGraphicalEffect_counter > 4)
				{
					doGraphicalEffect_counter = 0;
					doGraphicalEffect = true;
				}
			}
			
			//do we modulate the bg dolor
			bg_overlay.pixels.colorTransform(bg_overlay.pixels.rect, bg_overlay_color_transform);
			bg_overlay_color_transform.blueMultiplier = 0.1;
			bg_overlay_color_transform.greenMultiplier = Math.random();
			if (bg_overlay_color_transform.blueOffset > 50)
			{
				bg_overlay_color_transform.blueOffset = 0;
				bg_overlay_color_transform.redOffset = -100;
				bg_overlay_color_transform.greenOffset = -100;
			}
			else
			{
				bg_overlay_color_transform.blueOffset++;
			}
			bg_overlay.dirty = true;
			
			//some state of the canvas
			
			MOUSE_DEBUG.text = "(" + FlxG.mouse.x.toString() + "," + FlxG.mouse.y.toString() + ")";
			super.update();
			
			//leave the room blur
			if (player.x < 0)
			{
				canvas.base.pixels.applyFilter(canvas.base.pixels, canvas.base.pixels.rect, canvas.base.pixels.rect.topLeft, exitBlur);
				canvas.base.dirty = true;
				canvas.alpha -= 0.02;
				canvas.base.alpha -= 0.02;
				for each (var o:FlxSprite in members)
				{
					if (o != null && o.pixels != null)
					{
						o.pixels.applyFilter(o.pixels, o.pixels.rect, o.pixels.rect.topLeft, exitBlur);
					}
					o.dirty = true;
					canvas.horizontal_marker.visible = canvas.vertical_marker.visible = false;
					doGraphicalEffect = false;
				}
				exitTimer += FlxG.elapsed;
				FlxG.music.volume -= 0.02;
				if (exitTimer > 1.5)
				{
					FlxG.switchState(new ForestState());
					Registry.enter_dir = FlxObject.RIGHT;
					Registry.just_transitioned = true;
				}
			}
			if (player.x > 497)
			{
				player.x = 497;
				player.velocity.x = 0;
			}
		}
		
		public function events():void
		{
			//entering cliff cutscene
			//   event_pos = 14;
			if (!Registry.E_CLIFF_1)
			{
				d = Registry.textData.cliff_dialogue;
				switch (event_pos)
				{
					case 0: 
						player.frozen = true;
						player.scale.x = 1;
                        player.text.x = 120;
						player.text.text = d[0];
						player.play("walk");
						player.velocity.x = player.WALK_SPEED / 2;
						if (player.x > 225)
						{
                            player.text.x += 100;
							player.velocity.x = 0;
							player.play("stop");
							event_pos = 1;
						}
						break;
					case 1: 
						player.text.text = d[1];
						player.press_x.visible = true;
						break;
					case 2: 
						player.text.text = d[2];
						break;
					case 3: 
						sittingGirl.text.text = d[3];
						break;
						player.text.text = " ";
						break;
					case 4: 
						player.text.text = d[4];
						sittingGirl.text.text = " ";
						break;
					case 5: 
						sittingGirl.text.text = d[5];
						player.text.text = " ";
						break;
					case 6: 
						sittingGirl.text.text = " ";
						player.text.text = d[6];
						break;
					case 7: 
						sittingGirl.text.text = d[7];
						player.text.text = " ";
						break;
					case 8: 
						sittingGirl.text.text = " ";
						player.text.text = d[8];
						break;
					case 9: 
						sittingGirl.text.text = d[9];
						player.text.text = " ";
						break;
					case 10: 
						sittingGirl.text.text = " ";
						player.text.text = d[10];
						break;
					case 11: 
						sittingGirl.text.text = d[11];
						player.text.text = " ";
						break;
					case 12: 
						sittingGirl.text.text = d[12];
						break;
					case 13: 
						player.text.text = d[13];
						sittingGirl.text.text = " ";
						break;
					case 14: 
						Registry.E_CLIFF_1 = true;
						player.frozen = false;
						player.text.text = " ";
						player.press_x.visible = false;
						break;
				}
				dialogue_timer += FlxG.elapsed;
				if (dialogue_timer > Registry.dialogue_latency && event_pos > 0)
				{
					if (Registry.keywatch.JP_ACTION_1)
					{
						event_pos++;
						dialogue_timer = 0;
					}
				}
				
					//Registry.E_CLIFF_1 = true;
					//player.frozen = false;
			}
			else
			{
				
			}
			if (Registry.E_INSPIRATION_1 && !Registry.E_CLIFF_2)
			{
				sittingGirl.visible = false;
				player.text.visible = true;
				player.frozen = true;
				switch (event_pos)
				{
					case 0: 
						player.velocity.x = 50;
						player.play("walk");
						if (player.x > 200)
						{
							player.velocity.x = 0;
							player.play("stop");
							event_pos++;
						}
						break;
					case 1: 
						player.text.text = "Weird, she's gone!\n";
						player.text.x = player.x - 80;
						player.text.y = player.y - 48;
						
						break;
					case 2: 
						player.text.text = "That art canvas is still blank, though.\nI should press X in front of it.";
						break;
					case 3: 
						player.text.text = "...and there's nothing else to do...\nmaybe i should press X\nin front of the canvas.";
						break;
					case 4: 
						player.frozen = false;
						player.text.visible = false;
						Registry.E_CLIFF_2 = true;
						break;
				}
				if (event_pos > 0)
				{
					if (Registry.keywatch.JP_ACTION_1)
					{
						event_pos++;
					}
				}
			}
			if (Registry.E_CLIFF_2 && !Registry.DRAWING_1_DONE)
				sittingGirl.visible = false;
			if (Registry.E_CLIFF_2 && Registry.keywatch.JP_ACTION_1 && player.overlaps(canvas.base) && !doDrawing_1)
			{
				doDrawing_1 = true;
				event_pos = 0;
			}
			
			if (doDrawing_1 && !Registry.DRAWING_1_DONE)
			{
				switch (event_pos)
				{
					case 0: 
						player.frozen = true;
						player.velocity.x = -50;
						if (player.x < canvas.x - 50)
						{
							player.scale.x = 1;
							player.velocity.x = 0;
							event_pos++;
						}
						break;
					
					case 1: 
						player.text.text = "Okay, guess I'll paint something.";
						player.text.visible = true;
						break;
					case 2: 
						player.text.text = "But what?";
						break;
					case 3: 
						player.text.x = player.x - 200;
						player.text.y = player.y - 65;
						player.text.text = "I should press space when I'm ready.\nAnd then press and hold X to draw.\nAnd press space to change strokes.\nAnd press Z when I'm done.";
						break;
					case 4: 
						if (Registry.keywatch.JP_ACTION_3)
						{
							canvas.state = canvas.S_NORMAL;
							canvas.horizontal_marker.visible = false;
							event_pos++;
						}
						else if (Registry.keywatch.JP_ACTION_2)
						{
							canvas.colorIndex = (canvas.colorIndex + 1) % Registry.colors.length;
							
							trace(canvas.colorIndex);
							trace(Registry.colors[canvas.colorIndex])
							trace(Registry.colors);
							if (canvas.state == canvas.S_DRAW_HOR)
							{
								canvas.state = canvas.S_DRAW_VERT;
								canvas.horizontal_marker.visible = false;
								canvas.vertical_marker.visible = true;
							}
							else
							{
								canvas.horizontal_marker.visible = true;
								canvas.vertical_marker.visible = false;
								canvas.state = canvas.S_DRAW_HOR;
							}
						}
						
						break;
					case 5: 
						player.text.text = "Hmm...frankly, \n that looks terrible.";
						Registry.drawing_1.copyPixels(canvas.base.pixels, canvas.base.pixels.rect, canvas.base.pixels.rect.topLeft);
						break;
					case 6: 
						player.text.text = "(but it does look kinda neat...)";
						break;
					case 7: 
						player.text.text = "guess I'll just go to sleep for now. back to bed.";
						break;
					case 8: 
						player.text.text = " ";
                                
                        Log.LevelCounterMetric("did first painting.", 1, true);
						player.frozen = false;
						Registry.DRAWING_1_DONE = true;
						break;
				
				}
				if (event_pos != 0 && event_pos != 4)
				{
					if (Registry.keywatch.JP_ACTION_1 || Registry.keywatch.JP_ACTION_2)
						event_pos++;
				}
			}
			if (!Registry.E_CLIFF_3 && Registry.E_WOKE_UP_1)
			{
				switch (event_pos)
				{
					case 0: 
						player.frozen = true;
						player.velocity.x = 100;
						player.play("walk");
						if (player.x > 200)
						{
							
							player.text.x = player.x - 80;
							player.text.y = player.y - 48;
							player.velocity.x = 0;
							player.play("stop");
							event_pos++;
						}
						break;
					case 1: 
						player.text.visible = sittingGirl.text.visible = true;
						player.text.text = "The canvas is blank again!";
						break;
					case 2: 
						player.text.text = "And YOU'RE here! Who are you?";
						sittingGirl.text.text = " ";
						break;
					case 3: 
						player.text.text = " ";
						sittingGirl.text.text = "saw your painting.\n nice painting.";
						break;
					case 4: 
						player.text.text = " ";
						sittingGirl.text.text = "you can do better\n though ";
						break;
					case 5: 
						player.text.text = " ";
						sittingGirl.text.text = "come back here when\n you're ready";
						break;
					case 6: 
						player.text.text = " ";
						sittingGirl.text.text = "...okay?";
						break;
					case 7: 
						player.text.text = "uh, sure";
						sittingGirl.text.text = " ";
						break;
					case 8: 
						player.text.text = "(glad this is my last day...)";
						sittingGirl.text.text = " ";
						break;
					case 9: 
						player.text.text = " ";
						player.frozen = false;
						Registry.E_CLIFF_3 = true;
						break;
				
				}
				if (Registry.keywatch.JP_ACTION_1 && event_pos > 0)
				{
					event_pos++;
				}
			}
			if (!Registry.E_CLIFF_4 && (Registry.E_INSPIRATION_2 || Registry.E_INSPIRATION_3))
			{
				switch (event_pos)
				{
					case 0: 
						player.frozen = true;
						player.velocity.x = 100;
						player.play("walk");
						if (player.x > 200)
						{
							
							player.text.x = player.x - 80;
							player.text.y = player.y - 48;
							player.velocity.x = 0;
							player.play("stop");
							event_pos++;
						}
						break;
					case 1: 
						player.text.visible = sittingGirl.text.visible = true;
						player.text.text = " ";
						sittingGirl.text.text = "hello again";
						break;
					case 2: 
						player.text.text = " ";
						sittingGirl.text.text = "well, when you're ready.";
						break;
					case 3: 
						player.text.text = " ";
						sittingGirl.text.text = "if you're not,\n you can just wander\n those other two screens";
						break;
					case 4: 
						sittingGirl.text.text = " ";
						player.text.text = "(i press x in front of the canvas, I think)";
						break;
					case 5: 
						player.text.text = " ";
						player.frozen = false;
						Registry.E_CLIFF_4 = true;
						
						break;
				}
				
				if (Registry.keywatch.JP_ACTION_1 && event_pos > 0)
				{
					event_pos++;
				}
			}
			
			if (Registry.E_CLIFF_4 && !Registry.DRAWING_2_DONE && player.overlaps(canvas.base) && !doDrawing_2 && Registry.keywatch.JP_ACTION_1)
			{
				doDrawing_2 = true;
				event_pos = 0;
			}
			
			if (doDrawing_2 && !Registry.DRAWING_2_DONE)
			{
				sittingGirl.alpha -= 0.02;
				switch (event_pos)
				{
					case 0: 
						player.frozen = true;
						player.velocity.x = -50;
						if (player.x < canvas.x - 50)
						{
							player.scale.x = 1;
							player.velocity.x = 0;
							event_pos++;
                            player.play("stop");
						}
						break;
					case 1: 
						player.text.visible = true;
						player.text.text = "Well, one last time.\n";
						break;
					case 2: 
						player.text.visible = true;
						player.text.x = player.x - 200;
						player.text.y = player.y - 65;
						player.text.text = "Oh yeah. Press space when I'm ready.\nPress and hold X to draw.\nPress space to change strokes...\nAnd Z when I'm done.\n";
						break;
					case 3: 
						if (Registry.keywatch.JP_ACTION_3)
						{
							canvas.state = canvas.S_NORMAL;
							canvas.horizontal_marker.visible = false;
							event_pos++;
						}
						else if (Registry.keywatch.JP_ACTION_2)
						{
							canvas.colorIndex = (canvas.colorIndex + 1) % Registry.colors.length;
							if (canvas.state == canvas.S_DRAW_HOR)
							{
								canvas.state = canvas.S_DRAW_VERT;
								canvas.horizontal_marker.visible = false;
								canvas.vertical_marker.visible = true;
							}
							else
							{
								canvas.horizontal_marker.visible = true;
								canvas.vertical_marker.visible = false;
								canvas.state = canvas.S_DRAW_HOR;
							}
						}
						break;
					case 4: 
						if (Registry.colors.length == 4)
						{
							player.text.text = "It's certainly more colorful.\n";
						}
						else
						{
							player.text.text = "Hm, it's okay.\nBut missing something...\n"
						}
						break;
					case 5: 
						player.text.text = "I'm glad I could do this.";
						break;
					case 6: 
						player.text.text = "Who is that girl, though...";
						break;
					case 7: 
						player.text.text = "In any case,\nThis has been sort of interesting.";
						break;
					case 8: 
						player.text.text = "Making something myself\nwasn't so bad.\nI wonder what else I could be good at\n that I've never tried.";
						break;
					case 9: 
						player.text.text = "Anyways, I should go back now.\n";
						break;
					case 10: 
						player.frozen = false;
                        Log.LevelCounterMetric("did second painting.", 1, true);
						Registry.DRAWING_2_DONE = true;
						player.text.text = " ";
						Registry.drawing_2.copyPixels(canvas.base.pixels, canvas.base.pixels.rect, canvas.base.pixels.rect.topLeft);
						break;
				
				}
				if ((Registry.keywatch.JP_ACTION_1 || Registry.keywatch.JP_ACTION_2)  && event_pos != 0 && event_pos != 3)
				{
					event_pos++;
				}
			}
		}
	}
}