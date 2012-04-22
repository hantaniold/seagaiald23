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
        public static var drawing_1:BitmapData;
        
        public static function init():void {
            keywatch = new KeyWatch();
        }
        
        public static var E_CLIFF_1:Boolean = false;
        public static var dialogue_latency:Number = 0.5;
        
        public static var enter_dir:int = FlxObject.RIGHT;
        public static var just_transitioned:Boolean = false;
        
        
    }
    
}