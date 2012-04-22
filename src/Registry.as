package 
{
    import flash.display.BitmapData;
    import org.flixel.FlxSprite;
    
    /**
     * @author seagaia
     */
    import org.flixel.FlxObject;
    public class Registry 
    {
        //  public static var drawing:FlxSprite = new FlxSprite();
        
        [Embed (source = "../img/seanfont.png")] public static var Font:Class;
        public static var fontString:String = "abcdefghijklmnopqrstuvwxyz,.!?ABCDEFGHIJKLMNOPQRSTUVWXYZ':()";
        
        public static var textData:TextData = new TextData();
        public static var keywatch:KeyWatch;
        public static var drawing_1:BitmapData = new BitmapData(100, 100, true, 0x00000000);
        public static var DRAWING_1_DONE:Boolean = false;
        
        public static function init():void {
            keywatch = new KeyWatch();
        }
        
        public static var E_CLIFF_1:Boolean = false;
        public static var E_CLIFF_2:Boolean = false;
        public static var E_INSPIRATION_1:Boolean = false;
        public static var inspirationSource:String = "";
        public static var dialogue_latency:Number = 0.5;
        
        public static var enter_dir:int = FlxObject.RIGHT;
        public static var just_transitioned:Boolean = false;
        
        
    }
    
}