package  
{
    import entity.Canvas;
    import entity.Player;
    import flash.display.*;
    import flash.display.BitmapData;
    import flash.filters.BlurFilter;
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
    
    public var canvas_1:Canvas = new Canvas(new Rectangle(120, 200, 100, 100));
    public var canvas_2:Canvas = new Canvas(new Rectangle(250, 250, 100, 100));
    public var canvas_3:Canvas = new Canvas(new Rectangle(380, 200, 100, 100));
    
        override public function create():void {
        
           
            bg.loadGraphic(HouseBG, false, false, 640, 480);
            fg.loadGraphic(HouseFG, false, false, 640, 480);
            
            fgCopy = new BitmapData(640, 480, true, 0x00000000);  fgCopy.copyPixels(fg.pixels, fg.pixels.rect, fg.pixels.rect.topLeft);
            bgCopy = new BitmapData(640, 480, true, 0x00000000); bgCopy.copyPixels(bg.pixels, bg.pixels.rect, bg.pixels.rect.topLeft);
            
            add(bg);
            add(fg);
            player = new Player(575, 376);
            Registry.init();
            add(Registry.keywatch);
            add(player);
            add(canvas_1);
            add(canvas_2);
            add(canvas_3);
            if (Registry.DRAWING_1_DONE) {
                canvas_1.pixels.copyPixels(Registry.drawing_1, Registry.drawing_1.rect, Registry.drawing_1.rect.topLeft);
                canvas_1.dirty = true;
            }
           
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
                        varBlur.quality = 1 + 5 * Math.random();
                    } else if (Registry.just_transitioned){
                        varBlur.quality --; 
                    } else {
                        varBlur.blurX = 1 + 6 * Math.random();
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
                
                if (player.x < 70) {
                    player.velocity.x = 0;
                    player.x = 70;
                }
                
                if (player.x >  630) {
                    FlxG.switchState(new ForestState());
                    Registry.just_transitioned = true;
                    Registry.enter_dir = FlxObject.LEFT;
                }
            super.update();
        }   
    }

}