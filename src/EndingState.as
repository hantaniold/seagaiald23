package  
{
    import flash.display.*;
    import org.flixel.FlxSound;
    import org.flixel.FlxSprite;
    import org.flixel.plugin.photonstorm.FlxBitmapFont;
    import org.flixel.FlxG;
    import org.flixel.FlxU;
    import org.flixel.FlxState;
    import com.newgrounds.*;
    import com.newgrounds.components.*;
	/**
     * ...
     * @author seagaia

     */
    public class EndingState extends FlxState
    {
        [Embed (source = "../intronoise/intronoise.mp3")] public var Noise:Class;
       
        API.unlockMedal("A tiny world");
        public var d1:FlxSprite = new FlxSprite(100, 300);
        public var d2:FlxSprite = new FlxSprite(440, 300);
        public var text:FlxBitmapFont = new FlxBitmapFont(Registry.Font, 8, 14, Registry.fontString, 30, 0, 0, 0, 0);
        public var bm:Bitmap;
        public var overlay:FlxSprite = new FlxSprite(0, 0);
            override public function create():void {
                
            text.setText("                                   \n\
            thanks for playing this game. \n(it's over now, phew.)\n \                      made by seagaia (sean hogan) \n\n\n for ludum dare twenty three\n (april two thousand and twelve)\n\
            also thanks to adam saltsman for flixel,\n makers of REAPER,\n and  various soundfonts, etc,\  gimp, and the maker of pickle pixel editor\n\
            \n\n if you liked this game, check out other stuff at my twitter (press T)\n\nthe drawings you made are below. press x to start over\n",true,0,0,"center",true);
             
                overlay.makeGraphic(640, 480, 0xffffffff);
                var bg:FlxSprite = new FlxSprite(0, 290);
                bg.makeGraphic(640, 290, 0xffffffff);
                add(bg);   add(text);
                d1.makeGraphic(100, 100, 0x00000000);
                d2.makeGraphic(100, 100, 0x0001111);
                d2.pixels = new BitmapData(100, 100, true, 0x00000000);
                d1.pixels.copyPixels(Registry.drawing_1, Registry.drawing_1.rect, Registry.drawing_1.rect.topLeft);
                d1.dirty = true;
                
                
                bm = new Bitmap(Registry.drawing_2);
                bm.x = 440; bm.y = 300;
                
                FlxG.stage.addChild(bm);
                FlxG.music = new FlxSound(); FlxG.music.loadEmbedded(Noise, true); FlxG.music.play();
                add(d1);
                d2.pixels.copyPixels(Registry.drawing_2, Registry.drawing_2.rect, Registry.drawing_2.rect.topLeft);
                d2.dirty = true;
               // add(d2);
                add(overlay);
            }
            
            override public function update():void {
                if (overlay.alpha > 0.02) {
                    overlay.alpha -= 0.01;
                    return;
                }
            if (FlxG.keys.justPressed("X")) { FlxG.switchState(new IntroState()); FlxG.stage.removeChild(bm);
                Registry.E_CLIFF_1 = Registry.E_CLIFF_2 = Registry.E_CLIFF_3 = Registry.E_CLIFF_4 = false;
                Registry.DRAWING_1_DONE = Registry.DRAWING_2_DONE = false;
                Registry.E_DAY_1_DONE = false;
                Registry.E_HOUSE_1 = Registry.E_INSPIRATION_2 = Registry.E_INSPIRATION_1 = Registry.E_INSPIRATION_3 = false;
                Registry.E_WOKE_UP_1 = false;
                FlxG.music.stop();
                Registry.colors = new Array(0x00000000, 0x00000000);
            }
            if (FlxG.keys.justPressed("T")) FlxU.openURL("http://www.twitter.com/seagaia2");
            }
            
            
        
    }

}