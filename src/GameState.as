package 
{
    import org.flixel.FlxGame;
    
    
    public class GameState extends FlxGame
    {
        public function GameState() {
            Registry.textData.init();
            trace(Registry.textData.cliff_dialogue[0]);
            trace(Registry.textData.intro_dialogue[0]);
            super(640, 480, ForestState);
        }
    }
    
}