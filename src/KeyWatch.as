package  
{
    import org.flixel.FlxBasic;
	/**
     * ...
     * @author seagaia

     */
    import org.flixel.FlxG;
    public class KeyWatch extends FlxBasic
    {
        
        public  var ACTION_1:Boolean = false;
        public  var JP_ACTION_1:Boolean = false;
        public  var ACTION_2:Boolean = false;
        public  var LEFT:Boolean = false;
        public  var RIGHT:Boolean = false;
        public function KeyWatch() 
        {
            
        }
        
        override public function update():void {
            ACTION_1 = FlxG.keys.X;
            JP_ACTION_1 = FlxG.keys.justPressed("X");
            ACTION_2 = FlxG.keys.SPACE;
            LEFT = FlxG.keys.LEFT;
            RIGHT = FlxG.keys.RIGHT;
            super.update();
        }
    }

}