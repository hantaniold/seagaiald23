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
        
        [Embed (source = "../housesong/ideasound.mp3")] public static var IdeaSound:Class;
        public static var textData:TextData = new TextData();
        public static var keywatch:KeyWatch;
        public static var drawing_1:BitmapData = new BitmapData(100, 100, true, 0x00000000);
        public static var drawing_2:BitmapData = new BitmapData(100, 100, true, 0x01000000);
        public static var colors:Array = new Array(0x01000000,0x01000000);
        
        public static function init():void {
            keywatch = new KeyWatch();
        }
        
        //public static var E_CLIFF_1:Boolean = false;
        public static var E_CLIFF_1:Boolean = false;
        public static var E_INSPIRATION_1:Boolean = false;
        public static var E_CLIFF_2:Boolean = false;
        public static var DRAWING_1_DONE:Boolean = false;
        public static var E_HOUSE_1:Boolean = false;
        public static var E_DAY_1_DONE:Boolean = false;
        public static var E_WOKE_UP_1:Boolean =  false;
        public static var E_CLIFF_3:Boolean = false;
        public static var E_INSPIRATION_2:Boolean = false;
        public static var E_INSPIRATION_3:Boolean = false;
        public static var E_CLIFF_4:Boolean = false;
        public static var DRAWING_2_DONE:Boolean = false;
        
        public static var inspirationSource:String = "";
        public static var dialogue_latency:Number = 0.5;
        
        public static var enter_dir:int = FlxObject.RIGHT;
        public static var just_transitioned:Boolean = false;
        
        
    }
    
}