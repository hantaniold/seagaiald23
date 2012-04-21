package 
{
    import entity.Canvas;
    import entity.Player;
    import entity.SittingGirl;
    import flash.filters.BlurFilter;
    import flash.filters.GlowFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Rectangle;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxText;
    import org.flixel.FlxG;
    import org.flixel.plugin.photonstorm.FlxBitmapFont;
    
    /**
     * ...
     * @author seagaia
     */
    public class CliffState extends FlxState  
    {
        [Embed (source = "../img/cliff_bg.png")] public var BG:Class;
        [Embed (source = "../img/cliff_fg.png")] public var FG:Class;
    
        public var canvas:Canvas = new Canvas(new Rectangle(100,100,400,50));
        public var bg:FlxSprite = new FlxSprite(0, 0);
        public var bg_overlay:FlxSprite = new FlxSprite(0, 0);
        public var bg_overlay_color_transform = new ColorTransform(1, 1, 1, 1, 4, 4, 4);
        public var fg:FlxSprite = new FlxSprite(0, 0);
        public var player:Player = new Player(40, 380);
        public var sittingGirl:SittingGirl = new SittingGirl(527, 243);
        
        public var MOUSE_DEBUG:FlxText = new FlxText(0, 0, 400, "");
        public var dialogue:FlxBitmapFont = new FlxBitmapFont(Registry.Font, 8, 14, Registry.fontString, 30, 0, 0, 0, 0);
        public var dialogue2:FlxBitmapFont = new FlxBitmapFont(Registry.Font, 8, 14, Registry.fontString, 30, 0, 0, 0, 0);
        
        override public function create():void {
        
            add(Registry.keywatch);
            bg.loadGraphic(BG, false, false, 640, 480);  add(bg);
            bg_overlay.makeGraphic(640, 480, 0x88111195); add(bg_overlay);
            
            fg.loadGraphic(FG, false, false, 640, 480);  add(fg);
            
            add(canvas.base);
            add(canvas);
            add(canvas.horizontal_marker);
            add(player);
            add(sittingGirl);
            dialogue.x = 420; dialogue.y = 182;
            dialogue.setText("you're boring and should\n draw something..\nALSO COCKS!?!:'''\nWAFFLES FOX BROWN", true, 0, 0, "left", true);
            add(dialogue);
            dialogue2.x = 300; dialogue2.y = 400;
            dialogue2.setText("why am i down here it is lonely", true, 0, 0, "left", true);
            add(dialogue2);
            
            add(MOUSE_DEBUG);
            FlxG.mouse.show();
        }
        
        override public function update():void {
           
           bg_overlay.pixels.colorTransform(bg_overlay.pixels.rect, bg_overlay_color_transform);
           bg_overlay_color_transform.blueMultiplier = Math.random() * 1;
           trace(bg_overlay_color_transform.blueOffset);
           if (bg_overlay_color_transform.blueOffset > 253) {
            bg_overlay_color_transform.blueOffset = 0;
            } else {
            bg_overlay_color_transform.blueOffset ++;
            }
           bg_overlay.dirty = true;
           
           dialogue.dirty = true;
           
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
        }
    }
    
}