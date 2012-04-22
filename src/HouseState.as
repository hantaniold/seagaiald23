package  
{
    import entity.Canvas;
    import entity.Player;
    import flash.display.*;
    import flash.display.BitmapData;
    import flash.filters.BlurFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import org.flixel.*;
    import org.flixel.FlxState;
	/**
     * ...
     * @author seagaia

     */

    
    public class HouseState extends FlxState
    {
        
        [Embed (source = "../housesong/housesong.mp3")] public var  HouseSong:Class;
    [Embed (source = "../img/housebg.png")] public var HouseBG:Class;
    [Embed (source = "../img/housefg.png")] public var HouseFG:Class;
    
    public var bg:FlxSprite = new FlxSprite(0, 0);
    public var fg:FlxSprite = new FlxSprite(0, 0);
    public var fgCopy:BitmapData = new BitmapData(640, 480, true, 0x00000000);
    public var bgCopy:BitmapData = new BitmapData(640, 480, true, 0x00000000);
    public var buf:BitmapData = new BitmapData(640, 480, true, 0x00000000);
    public var player:Player;
    public var offsetPointDir:int = 0;
    public var offsetPoint:Point = new Point(0, 0);
    public var varBlur:BlurFilter = new BlurFilter(3, 4, 1);
    public var blurTimer:Number = 0;
    public var blurLatency:Number = 0.3;
    public var colorTransform:ColorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
    
    public var c2:Bitmap;
    public var event_pos:int = 0;
    public var canvas_1:Canvas = new Canvas(new Rectangle(120, 200, 100, 100));
    public var canvas_2:Canvas = new Canvas(new Rectangle(380, 200, 100, 100));
    public var canvas_3:Canvas = new Canvas(new Rectangle(380, 200, 100, 100));
    public var exit:Boolean = false;
    public var doWakeup1:Boolean = false;
    public var cantleave:Boolean = false;
        override public function create():void {
        
        FlxG.music = new FlxSound();
        FlxG.music.loadEmbedded(HouseSong);
        FlxG.music.play();
        FlxG.volume = 1;
        FlxG.music.volume = 0;
           
            bg.loadGraphic(HouseBG, false, false, 640, 480);
            fg.loadGraphic(HouseFG, false, false, 640, 480);
            
            fgCopy = new BitmapData(640, 480, true, 0x00000000);  fgCopy.copyPixels(fg.pixels, fg.pixels.rect, fg.pixels.rect.topLeft);
            bgCopy = new BitmapData(640, 480, true, 0x00000000); bgCopy.copyPixels(bg.pixels, bg.pixels.rect, bg.pixels.rect.topLeft);
            
            add(bg);
            add(fg);
            player = new Player(575, 376);
            if (Registry.enter_dir == FlxObject.LEFT) {
                player.x = 140;
                
                player.scale.x = 1;
                if (!Registry.E_WOKE_UP_1) {
                    Registry.E_WOKE_UP_1 = true;
                    doWakeup1 = true;
                }
            }
            Registry.init();
            add(Registry.keywatch);
            add(player);
            add(player.text);
            canvas_2.base = new FlxSprite(canvas_2.x, canvas_2.y);
            canvas_2.makeGraphic(100, 100, 0x01000000);
            
            c2 = new Bitmap(Registry.drawing_2);
            c2.x = canvas_2.x; c2.y = canvas_2.y;
            FlxG.stage.addChild(c2);
            
            if (Registry.DRAWING_1_DONE) {
                canvas_1.base.pixels.copyPixels(Registry.drawing_1, Registry.drawing_1.rect, Registry.drawing_1.rect.topLeft);
                canvas_1.base.dirty = true;
                add(canvas_1.base);
            }
            if (Registry.DRAWING_2_DONE) {
                canvas_2.base.framePixels.copyPixels(Registry.drawing_2, Registry.drawing_2.rect, Registry.drawing_2.rect.topLeft);
                canvas_2.base.dirty = true;
               // add(canvas_2.base);
            }
            trace(1, canvas_1.base.pixels, 2, canvas_2.base.pixels);
           
        }
        
        override public function update():void {
            if (FlxG.music.volume < 0.9) FlxG.music.volume += 0.08;
            events();
            if (offsetPointDir == 1) {
                offsetPoint.x++;
                if (offsetPoint.x > 15) offsetPointDir = -1;
            } else {
                offsetPoint.x--;
                if (offsetPoint.x < -15) offsetPointDir = 1;
            }
            offsetPoint.y = -10 + 20 * Math.random();
            
           
            fg.pixels.copyChannel(fg.pixels, fg.pixels.rect, offsetPoint, BitmapDataChannel.GREEN, BitmapDataChannel.BLUE);
            fg.dirty = true;
        
        
                if (blurTimer > blurLatency) {
                    if (varBlur.quality == 0) {
                        Registry.just_transitioned = false;
                        varBlur.quality = 1 + 5 * Math.random();
                    } else if (Registry.just_transitioned){
                        varBlur.quality --; 
                    } else if (!exit) {
                        varBlur.blurX = 1 + 6 * Math.random();
                        varBlur.blurY = 1 + 3 * Math.random();
                    } else {
                        varBlur.quality ++;
                        FlxG.music.volume -= 0.08;
                        Registry.enter_dir = FlxObject.LEFT;
                        if (varBlur.quality > 14) { 
                            if (Registry.DRAWING_2_DONE) {
                                FlxG.switchState(new EndingState());
                                c2.visible = false
                                FlxG.stage.removeChild(c2);
                            } else {
                                FlxG.switchState(new HouseState());
                                FlxG.stage.removeChild(c2);
                            }
                            
                        }
                        
                        for each (var o:FlxSprite in members) {
                            o.dirty = true;
                            o.pixels.colorTransform(o.pixels.rect, colorTransform);
                            o.pixels.applyFilter(o.pixels, o.pixels.rect, o.pixels.rect.topLeft, varBlur);
                        }
                    }
                    
                    if (Registry.just_transitioned || (Math.random() < 0.4)) {
                        bg.visible = fg.visible = true;
                        buf.copyPixels(bgCopy, bgCopy.rect, bgCopy.rect.topLeft);
                        buf.applyFilter(buf, buf.rect, buf.rect.topLeft, varBlur);
                        bg.pixels.copyPixels(buf, buf.rect, buf.rect.topLeft);
                        bg.dirty = true;
                        
                        buf.copyPixels(fgCopy, fgCopy.rect, fgCopy.rect.topLeft);
                        buf.applyFilter(buf, buf.rect, buf.rect.topLeft, varBlur);
                        fg.pixels.copyPixels(buf, buf.rect, buf.rect.topLeft);
                        fg.dirty = true;
                     }
                        
                    blurTimer = 0;
                }
                blurTimer += FlxG.elapsed;
                
                if (player.x < 70) {
                    player.velocity.x = 0;
                    player.x = 70;
                }
                
                if (player.x >  630 && !cantleave) {
                    FlxG.switchState(new ForestState());
                    FlxG.stage.removeChild(c2);
                    Registry.just_transitioned = true;
                    Registry.enter_dir = FlxObject.LEFT;
                } else if (player.x > 630) {
                    player.x = 630;
                }
            super.update();
        }   
        
        public function events():void {
            if (Registry.DRAWING_1_DONE && !Registry.E_HOUSE_1) {
                switch (event_pos) {
                case 0:
                    player.frozen = true;
                    player.scale.x = -1;
                    player.text.visible = true;
                    player.text.x = player.x - 100;
                    player.text.text = "Huh.\nMy painting is\n up there now.\n";
                    break;
                case 1:
                    player.text.text = "It certainly livens\n up the place...\n";
                    break;
                case 2:
                    player.text.text = "To sleep then. \nI should press\n X over my bed.\n";
                    break;
                case 3:
                    player.text.text = " ";
                    player.frozen = false;
                    cantleave = true;
                    Registry.E_HOUSE_1 =  true;
                    break;
                }
                if (Registry.keywatch.JP_ACTION_1) {
                event_pos++;
                }
            }
            if (player.x > 100 && player.x < 240 && Registry.keywatch.JP_ACTION_1 && !Registry.E_DAY_1_DONE && Registry.E_HOUSE_1) {
                Registry.E_DAY_1_DONE = true;
                exit = true;
            }
            if (doWakeup1) {
                switch (event_pos) {
                case 0:
                    player.frozen = true;
                    player.text.x = player.x - 80;
                    player.visible = true;
                    player.text.text = "Whoa!";
                    break;
                case 1:
                    player.text.text = "My last day here.\n";
                    break;
                case 2:
                    player.text.text = "Better enjoy it while\n I can, I guess\n";
                    break;
                case 3:
                    player.frozen = false;
                    player.text.text = " ";
                    doWakeup1 = false;
                    break;
                 
                }
                if (Registry.keywatch.JP_ACTION_1) event_pos++;
            }
            
            if (player.x > 100 && player.x < 240 && Registry.DRAWING_2_DONE) {
                exit = true;
            }
        }
    }

}