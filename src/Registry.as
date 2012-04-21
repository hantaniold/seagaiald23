package 
{
    import org.flixel.FlxSprite;
    
    /**
     * ...
     * @author seagaia

     */
    public class Registry 
    {
        //  public static var drawing:FlxSprite = new FlxSprite();
        
        [Embed (source = "../img/seanfont.png")] public static var Font:Class;
        public static var fontString:String = "abcdefghijklmnopqrstuvwxyz,.!?ABCDEFGHIJKLMNOPQRSTUVWXYZ':";
        
        public static var textData:TextData = new TextData();
        public static var keywatch:KeyWatch = new KeyWatch();
        
    }
    
}