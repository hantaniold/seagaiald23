package 
{
    import entity.Canvas;
    import org.flixel.FlxState;
    import org.flixel.FlxText;
    
    /**
     * ...
     * @author seagaia
     */
    public class CliffState extends FlxState  
    {
    
        public var canvas:Canvas = new Canvas(0, 0);
        override public function create():void {
            add(canvas);
            add(Registry.keywatch);
        }
        
        override public function update():void {
            super.update();
        }
    }
    
}