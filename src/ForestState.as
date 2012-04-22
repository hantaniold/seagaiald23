package  
{
	/**
     * ...
     * @author seagaia

     */
import entity.Player;
import flash.display.*;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import org.flixel.*;
    public class ForestState extends FlxState
    {
        
        [Embed (source = "../img/forestbg.png")] public var ForestBG:Class;
        [Embed (source = "../img/forestfg.png")] public var ForestFG:Class;
        [Embed (source = "../img/plant.png")] public var Plant:Class;
        [Embed (source = "../forestvibes/forestvibes.mp3")] public var ForestVibes:Class;
        public var player:Player;
        
        public var buf:BitmapData;
        public var fgCopy:BitmapData;
        public var fg:FlxSprite;
        public var bgCopy:BitmapData;
        public var bg:FlxSprite;
        
        public var varBlur:BlurFilter = new BlurFilter(2, 2, 5);
        public var blurTimer:Number = 0;
        public var blurLatency:Number = 0.2;
        public var base:FlxSprite;
        public var colorTransform:ColorTransform;
        
        public var offsetPoint:Point = new Point(0, 0);
        public var offsetPointDir:int = -1;
        
        public var plant:FlxSprite;
        
        public var eventPos:int = 0;
        public var doEvent:Boolean = false;
        public var beginExit:Boolean = false;
        
        override public function create():void {
            FlxG.music = new FlxSound();
            FlxG.music.loadEmbedded(ForestVibes,true);
            FlxG.music.volume = 0.0;
            FlxG.music.play();
            
            player = new Player(0, 300);
            if (Registry.enter_dir == FlxObject.RIGHT) {
                player.scale.x = -1;
                player.x = 620;
            } else {
                player.scale.x = 1;
                player.x = 30;
            }
            buf = new BitmapData(640, 480, true, 0x00000000);
            fg = new FlxSprite(0, 0); fg.loadGraphic(ForestFG, false, false, 640, 480);
            
            fgCopy = new BitmapData(640, 480, true, 0x00000000);  fgCopy.copyPixels(fg.pixels, fg.pixels.rect, fg.pixels.rect.topLeft);
            bg = new FlxSprite(0, 0); bg.loadGraphic(ForestBG, false, false, 640, 480);
            bgCopy = new BitmapData(640, 480, true, 0x00000000); bgCopy.copyPixels(bg.pixels, bg.pixels.rect, bg.pixels.rect.topLeft);
            
            fg.pixels.colorTransform(fg.pixels.rect, new ColorTransform(1, 1 - .4 * Math.random(), 1 - .2 * Math.random(), 1, 0, -50 + 100 * Math.random(), -50 + 100 * Math.random()));
            bg.pixels.colorTransform(fg.pixels.rect, new ColorTransform(1, 1 - .4 * Math.random(), 1 - .2 * Math.random(), 1, 0, -50 + 100 * Math.random(), -50 + 100 * Math.random()));
            fg.dirty = bg.dirty = true;
            
            base = new FlxSprite(0, 0);
            base.makeGraphic(640, 480, 0x00000000);
            add(base);
            colorTransform = new ColorTransform();
            
            Registry.init();
            add(bg);
            add(fg);
            bg.visible = fg.visible = false;
            add(Registry.keywatch);
            add(player);
            add(player.text);
            add(player.press_x);
            
            plant = new FlxSprite(300, 300);
            plant.loadGraphic(Plant, true, false, 40, 80);
            plant.addAnimation("a", [0, 1, 2, 3], 7, true);
            plant.play("a");
            plant.pixels.applyFilter(plant.pixels, plant.pixels.rect, plant.pixels.rect.topLeft, varBlur);
            plant.dirty = true;
            add(plant);
        }
        
        override public function update():void {
            if (offsetPointDir == 1) {
                offsetPoint.x++;
                if (offsetPoint.x > 15) offsetPointDir = -1;
            } else {
                offsetPoint.x--;
                if (offsetPoint.x < -15) offsetPointDir = 1;
            }
            offsetPoint.y = -10 + 20 * Math.random();
            
            if (doEvent) {
                player.frozen = true;
                player.velocity.x = 0;
                player.text.visible = true;
                switch (eventPos) {
                case 0:
                    player.text.text = "Maybe this is what she meant by inspiration.\n"; break;
                case 1:
                    if (Registry.inspirationSource == "plant") player.text.text = "...in the form of this sort of\nodd plant. It's nice I guess.\n";
                    break;
                case 2:
                    player.text.text = "Well, better go back over there then.";
                     break;
                case 3:
                    doEvent = false;
                    player.frozen = false;
                    player.text.visible = false;
                    break;
                }
                if (Registry.keywatch.JP_ACTION_1) {
                    eventPos++;
                }
            }
            if (player.overlaps(plant) && Registry.E_CLIFF_1) {
                if (Registry.keywatch.JP_ACTION_1) {
                    Registry.E_INSPIRATION_1 = true;
                    Registry.inspirationSource = "plant";
                    doEvent = true;
                }
            }
           
            fg.pixels.copyChannel(fg.pixels, fg.pixels.rect, offsetPoint, BitmapDataChannel.GREEN, BitmapDataChannel.BLUE);
            fg.dirty = true;
        
        
                if (blurTimer > blurLatency) {
                    if (varBlur.quality == 0) {
                        Registry.just_transitioned = false;
                        varBlur.quality = 1 + 3 * Math.random();
                    } else if (Registry.just_transitioned){
                        varBlur.quality --; 
                    } else {
                        varBlur.blurX = 1 + 5 * Math.random();
                        varBlur.blurY = 1 + 3 * Math.random();
                    }
                    
                    if (Registry.just_transitioned || (Math.random() < 0.4)) {
                        FlxG.music.volume += 0.05;
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
            
           
            
            //if we just entered then unblur everything
            //blur/offset the bg/fg a little bit
            //check for item pickup and play event
            //check for transitions
            
            if (beginExit) {
                FlxG.music.volume -= 0.05;
                if (FlxG.music.volume < 0.1) {
                
                FlxG.switchState(new CliffState());
                Registry.enter_dir = FlxObject.LEFT;
                Registry.just_transitioned = true;
                }
            }
            if (player.x > 630) {
                player.frozen = true;
                beginExit = true;
            } 
            if (player.x < 0) {
                FlxG.switchState(new HouseState());
                Registry.enter_dir = FlxObject.LEFT;
                Registry.just_transitioned = true;
            }
            super.update();
        }
    }

}