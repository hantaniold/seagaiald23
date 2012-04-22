package  
{
    import flash.printing.PrintJobOptions;
    import org.flixel.FlxBasic;
	/**
     * ...
     * @author seagaia

     */
    import org.flixel.FlxG;
    import com.newgrounds.components.*;
    import com.newgrounds.*;
    import org.flixel.FlxSprite;
    public class KeyWatch extends FlxSprite
    {
        
        public  var ACTION_1:Boolean = false;
        public  var JP_ACTION_1:Boolean = false;
        public  var ACTION_2:Boolean = false;
        public  var JP_ACTION_2:Boolean = false;
        public var JP_ACTION_3:Boolean = false;
        public  var LEFT:Boolean = false;
        public var JR_LEFT:Boolean = false;
        public  var RIGHT:Boolean = false;
        public var JR_RIGHT:Boolean = false;
        public function KeyWatch() 
        {
            super(0, 0);
            visible = false;
            
        }
        
        override public function update():void {
            if (Registry.colors.length >= 4) 
                    API.unlockMedal("Inspired");
            ACTION_1 = FlxG.keys.X;
            JP_ACTION_1 = FlxG.keys.justPressed("X");
            ACTION_2 = FlxG.keys.SPACE;
            JP_ACTION_2 = FlxG.keys.justPressed("SPACE");
            JP_ACTION_3 = FlxG.keys.justPressed("Z");
            LEFT = FlxG.keys.LEFT;
            JR_LEFT = FlxG.keys.justReleased("LEFT");
            RIGHT = FlxG.keys.RIGHT;
            JR_RIGHT = FlxG.keys.justReleased("RIGHT");
            
        //    if (FlxG.keys.justPressed("E")) FlxG.switchState(new EndingState());
            super.update();
        }
    }

}