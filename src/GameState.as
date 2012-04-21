package 
{
    import org.flixel.FlxGame;
    
    
    public class GameState extends FlxGame
    {
        public function GameState() {
            Registry.textData.init();
            super(640, 480, CliffState);
        }
    }
    
}