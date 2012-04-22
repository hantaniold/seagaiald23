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
            a.push("It's March. I found myself out of a job last week.");
            a.push("Instead of looking for a new one,\n I took the time to go stay at\nmy parents' summer cabin in Oregon.");
            a.push("It wasn't the most exciting place...\nit'sin the middle of a small village,\nwith not much to do.");
            a.push("No internet, TV, and so forth.\n");
            a.push("But, it was a free place to stay.\n");
            
            a = cliff_dialogue;
            a.push("(quiet out here.)");
            a.push("(not much to do, though)");
            a.push("(but there's a canvas just sitting there?)");
            
            a.push("hey, bored kid");
            
            a.push("What?");
            //5
            a.push("if you're so bored,\nyou should draw something.");
            
            a.push("but i can't draw anything!");
            
            a.push("then maybe you should\nfind some inspiration");
            
            a.push("where? like, uh, the night sky?");
            
            a.push("well, sure..\nbut that's a boring thing\nto find inspiring..");
            
            a.push("what else am I supposed to find?\nthis town is so small.");
            
            a.push("maybe you should\n look harder.\n");
            a.push("come back here when\nyou've got an idea or two...\nPress X in front of things.");
            
            a.push("(weird, but there's\nnot much else to do..)\nI should press X in front of things.");
            
        }
        
    }

}