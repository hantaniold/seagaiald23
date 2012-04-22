package  
{
    import org.flixel.plugin.photonstorm.FlxBitmapFont;
    import org.flixel.FlxG;
    import org.flixel.FlxU;
    import org.flixel.FlxState;
	/**
     * ...
     * @author seagaia

     */
    public class EndingState extends FlxState
    {
        public var text:FlxBitmapFont = new FlxBitmapFont(Registry.Font, 8, 14, Registry.fontString, 30, 0, 0, 0, 0);
        
            override public function create():void {
                
            text.setText("                                   \n\
            thanks for playing this game. \n(it's over now, phew.)\n \                      made by seagaia (sean hogan) \n\n\n for ludum dare twenty three\n (april two thousand and twelve)\n\
            also thanks to adam saltsman for flixel,\n makers of REAPER,\n and  various soundfonts, etc,\  gimp, and the maker of pickle pixel editor\n\
            \n\n if you liked this game, check out other stuff at my twitter (press T)\n\nthe drawings you made are below. press x to start over\n",true,0,0,"center",true);
                add(text);
            }
            
            override public function update():void {
            if (FlxG.keys.justPressed("X")) FlxG.switchState(new IntroState());
            if (FlxG.keys.justPressed("T")) FlxU.openURL("http://www.twitter.com/seagaia2");
            }
            
            
        
    }

}