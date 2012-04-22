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
    import flash.geom.Rectangle;
    import org.flixel.*;
    import org.flixel.plugin.photonstorm.FlxBitmapFont;
    
    /**
     * ...
     * @author seagaia
     */
    public class CliffState extends FlxState  
    {
        [Embed (source = "../img/cliff_bg.png")] public var BG:Class;
        [Embed (source = "../img/cliff_fg.png")] public var FG:Class;
        [Embed (source = "../img/canvas_stand.png")] public var CanvasStand:Class;
        [Embed (source = "../cliffsong/cliffsong.mp3")] public var CliffSong:Class;
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
        
        public var event_pos :int = 0;
        public var dialogue_timer:Number = 0;
        public var dialogue_pos:int = 0;
        public var d:Array = new Array();
        public var exitTimer:Number = 0;
        
        override public function create():void {
            FlxG.music = new FlxSound();
            FlxG.music.loadEmbedded(CliffSong, true);
            FlxG.music.play();
            Registry.init();
            add(Registry.keywatch);
            bg.loadGraphic(BG, false, false, 640, 480);  add(bg);
            bg_overlay.makeGraphic(640, 480, 0x88111195); add(bg_overlay);
            bg.pixels.applyFilter(bg.pixels, bg.pixels.rect, bg.pixels.rect.topLeft, bgBlur);
            bg.dirty = true;
            
            
            fg.loadGraphic(FG, false, false, 640, 480);  add(fg);
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
            
            add(MOUSE_DEBUG);
            FlxG.mouse.show();
        }
        
        override public function update():void {
           
           events();
           
           //some funky blur fx and offset stuff
           if (doGraphicalEffect) {
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
            } else {
                doGraphicalEffect_counter++;
                if (doGraphicalEffect_counter > 4) {
                    doGraphicalEffect_counter = 0;
                    doGraphicalEffect = true;
                }
            }
           
           
           //do we modulate the bg dolor
           bg_overlay.pixels.colorTransform(bg_overlay.pixels.rect, bg_overlay_color_transform);
           bg_overlay_color_transform.blueMultiplier = 0.1;
           bg_overlay_color_transform.greenMultiplier = Math.random();
           trace(bg_overlay_color_transform.blueOffset);
           if (bg_overlay_color_transform.blueOffset > 50) {
            bg_overlay_color_transform.blueOffset = 0;
            bg_overlay_color_transform.redOffset = -100;
            bg_overlay_color_transform.greenOffset = -100;
            } else {
            bg_overlay_color_transform.blueOffset ++;
            }
           bg_overlay.dirty = true;
           
           
           //some state of the canvas
            if (Registry.keywatch.JP_ACTION_2) {
                if (canvas.state == canvas.S_DRAW_HOR) {
                    canvas.state = canvas.S_DRAW_VERT;
                    canvas.horizontal_marker.visible = false;
                    canvas.vertical_marker.visible = true;
                } else {
                    canvas.horizontal_marker.visible = true;
                    canvas.vertical_marker.visible = false;
                    canvas.state = canvas.S_DRAW_HOR;
                }
            }
            
            MOUSE_DEBUG.text = "("+FlxG.mouse.x.toString() + "," + FlxG.mouse.y.toString() +")";
            super.update();
            
            //leave the room blur
            if (player.x < 0) {
                canvas.base.pixels.applyFilter(canvas.base.pixels, canvas.base.pixels.rect, canvas.base.pixels.rect.topLeft, exitBlur);
                canvas.base.dirty = true;
                canvas.alpha -= 0.02;
                canvas.base.alpha -= 0.02;
                for each (var o:FlxSprite in members) {
                    if (o != null && o.pixels != null) {
                        o.pixels.applyFilter(o.pixels, o.pixels.rect, o.pixels.rect.topLeft, exitBlur);
                    }
                    o.dirty = true;
                    canvas.horizontal_marker.visible = canvas.vertical_marker.visible = false;
                    doGraphicalEffect = false;
                }
                exitTimer += FlxG.elapsed;
                FlxG.music.volume -= 0.02;
                if (exitTimer > 1.5) {
                    FlxG.switchState(new ForestState());
                    Registry.enter_dir = FlxObject.RIGHT;
                    Registry.just_transitioned = true;
                }
            }
        }
        
        public function events():void {
            //entering cliff cutscene
            event_pos = 14;
            if (!Registry.E_CLIFF_1) {
                d = Registry.textData.cliff_dialogue;
                switch (event_pos) {
                case 0:
                    player.frozen = true;
                    player.scale.x = 1;
                    player.text.text = d[0];
                    player.play("walk");
                    player.velocity.x = player.WALK_SPEED / 2;
                    if (player.x > 225) {
                        player.velocity.x = 0;
                        player.play("stop");
                        event_pos = 1;
                    }
                    break;
                case 1: player.text.text = d[1]; player.press_x.visible = true;  break;
                case 2: player.text.text = d[2]; break;
                case 3: sittingGirl.text.text = d[3]; break;
                    player.text.text = " "; break;
                case 4: player.text.text = d[4]; 
                    sittingGirl.text.text = " "; break;
                case 5:sittingGirl.text.text = d[5]; 
                    player.text.text = " "; break;
                case 6: sittingGirl.text.text = " ";
                    player.text.text = d[6]; break;
                case 7:  sittingGirl.text.text = d[7]; 
                    player.text.text = " "; break;
                case 8: sittingGirl.text.text = " ";
                    player.text.text = d[8]; break;
                case 9: sittingGirl.text.text = d[9]; 
                    player.text.text = " "; break;
                case 10: sittingGirl.text.text = " ";
                    player.text.text = d[10]; break;
                case 11: sittingGirl.text.text = d[11]; 
                    player.text.text = " "; break;
                case 12:
                    sittingGirl.text.text = d[12]; break; 
                case 13: player.text.text = d[13];
                    sittingGirl.text.text = " ";  break;
                case 14:
                    Registry.E_CLIFF_1 = true;
                    player.frozen = false; 
                    player.text.text = " ";
                    player.press_x.visible = false;break;
                }
                dialogue_timer += FlxG.elapsed;
                if (dialogue_timer > Registry.dialogue_latency && event_pos > 0) {
                    if (Registry.keywatch.JP_ACTION_1) { 
                        event_pos ++;
                        dialogue_timer = 0;
                    }
                }
                    
                    //Registry.E_CLIFF_1 = true;
                    //player.frozen = false;
            } else {
            
            }
        }
    }
    
}