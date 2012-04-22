package 
{
    import flash.filters.BlurFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import org.flixel.*;
    import flash.display.*;
    import org.flixel.plugin.photonstorm.FlxBitmapFont;
    
    /**
     * ...
     * @author seagaia

     */
    public class IntroState extends FlxState 
    {
        [Embed (source = "../img/housebg.png")] public var HouseBG:Class;
        [Embed (source = "../img/title_logo.png")] public var Logo:Class;
        
        public var stateTransition:Boolean = false;
        public var doText:Boolean = false;
        public var filler:String = "                          \n";
        public var bg:FlxSprite;
        public var logo:FlxSprite;
        public var pt:Point = new Point(0, 0);
        public var blur:BlurFilter = new BlurFilter(4, 4, 1);
        public var darken:ColorTransform = new ColorTransform(0.95, 0.96, 1, 1, 0, 0, -4);
        
        public var text:FlxBitmapFont;
        public var dialogueIndex:int = 0;
        public var exit:Boolean = false;
        
        override public function create():void {
            Registry.init();
            text = new FlxBitmapFont(Registry.Font, 8, 14, Registry.fontString, 30, 0, 0, 0, 0);
            text.setText(" ", true, 0, 0, "center", true);
            text.x = 140;
            text.y = 200;
            add(Registry.keywatch);
            bg = new FlxSprite(0, 0); bg.loadGraphic(HouseBG, false, false, 640, 480);
            add(bg);
            logo = new FlxSprite(0, 0); logo.loadGraphic(Logo, false, false, 640, 480);
            add(logo);
            add(text);
        }
        
        override public function update():void {
            if (exit) {
                text.alpha -= 0.02;
                if (text.alpha < 0.03) {
                    FlxG.switchState(new CliffState());
                }
                return;
            }
            if (doText) {
                
                switch (dialogueIndex) {
                    case 0:
                        text.text = filler + "I found myself out of a job last week.\n\n\n(hey, press x)";
                        break;
                    case 1:
                        text.text = filler + "My co-worker (well, ex-coworker)\ntold me I should take a break.\n\n\n(...psst, press x)";
                        break;
                    case 2:
                        text.text = filler + "So, here I am...taking a break.\nAt this small, isolated town...\nwhere my parents have this cottage.\n\n(Press x!)";
                        break;
                    case 3:
                        text.text = filler + "I don't particularly expect\nto get anything out of this...it's quiet around here.\nNot much to do, you know?";
                        break;
                    case 4:
                        text.text = filler + "No internet...";
                        break;
                    case 5:
                        text.text = filler + "No cable...";
                        break;
                    case 6:
                        text.text = filler + "What's a person supposed to do out here?";
                        break;
                    case 7:
                        text.text = filler + "Well, I'm just going to stay here\nfor a few days - then back out\n to the big, real world.\n";
                        break;
                    case 8:
                       exit = true;
                        break;
                    
                        
                }
                if (Registry.keywatch.JP_ACTION_1) dialogueIndex++;
                super.update();
                return;
            }
            pt.x = -9 + 18 * Math.random();
            pt.y = -9 + 18 * Math.random();
            
            logo.pixels.copyChannel(logo.pixels, logo.pixels.rect, pt, BitmapDataChannel.BLUE, BitmapDataChannel.GREEN);
            pt.x = -9 + 18 * Math.random();
            pt.y = -9 + 18 * Math.random();
            
            logo.pixels.copyChannel(logo.pixels, logo.pixels.rect, pt, BitmapDataChannel.GREEN, BitmapDataChannel.RED);
            logo.dirty = true;
            
            if (Registry.keywatch.ACTION_1) {
                stateTransition = true;
            }
            if (stateTransition) {
                bg.pixels.colorTransform(bg.pixels.rect, darken);
                bg.dirty = true;
                logo.alpha -= 0.01;
                logo.pixels.applyFilter(logo.pixels, logo.pixels.rect, logo.pixels.rect.topLeft,blur);
            //    FlxG.switchState(new CliffState());
                if (logo.alpha < 0.03) {  logo.kill(); doText = true; text.visible = true; }
            }
            super.update();
        }
    }
    
}