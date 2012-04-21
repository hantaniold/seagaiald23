package  
{
	/**
     * ...
     * @author Seagaia (Sean Hogan)
     */
    public class TextData 
    {
       
        public var intro_dialogue:Array = new Array();
        public var cliff_dialogue:Array = new Array();
        
        public function TextData() 
        {
            
        }
        
        public function init():void {
        
            var a:Array;
            a = intro_dialogue;
            a.push("I found myself out of a job last week.");
            a.push("");
            
            a = cliff_dialogue;
            a.push("Horseradish");
            
        }
        
    }

}