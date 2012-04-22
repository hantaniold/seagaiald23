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
        
        public var player:Player;
        
        public var buf:BitmapData;
        public var fgCopy:BitmapData;
        public var fg:FlxSprite;
        public var bgCopy:BitmapData;
        public var bg:FlxSprite;
        
        public var varBlur:BlurFilter = new BlurFilter(8, 3, 10);
        public var blurTimer:Number = 0;
        public var blurLatency:Number = 0.2;
        public var base:FlxSprite;
        public var colorTransform:ColorTransform;
        
        public var offsetPoint:Point = new Point(0, 0);
        public var offsetPointDir:int = -1;
        
    
        override public function create():void {
        
            player = new Player(0, 300);
            if (Registry.enter_dir == FlxObject.RIGHT) {
                player.scale.x = -1;
                player.x = 620;
            }
            buf = new BitmapData(640, 480, true, 0x00000000);
            fg = new FlxSprite(0, 0); fg.loadGraphic(ForestFG, false, false, 640, 480);
            
            fgCopy = new BitmapData(640, 480, true, 0x00000000);  fgCopy.copyPixels(fg.pixels, fg.pixels.rect, fg.pixels.rect.topLeft);
            bg = new FlxSprite(0, 0); bg.loadGraphic(ForestBG, false, false, 640, 480);
            bgCopy = new BitmapData(640, 480, true, 0x00000000); bgCopy.copyPixels(bg.pixels, bg.pixels.rect, bg.pixels.rect.topLeft);
            
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
            if (player.x > 630) {
                FlxG.switchState(new CliffState());
                Registry.enter_dir = FlxObject.LEFT;
                Registry.just_transitioned = true;
            }
            super.update();
        }
    }

}