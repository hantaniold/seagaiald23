package  
{
    import com.newgrounds.*;
    import com.newgrounds.components.*;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;

    public class Preloader extends MovieClip
    {
        public function Preloader() 
        {
            var apiConnector:APIConnector = new APIConnector();
            apiConnector.className = "Main";
        apiConnector.encryptionKey = "ZYqyy02IliIG6dnJLb0MxAyC3a6TOqYW";
        apiConnector.apiId = "24566:ki50Wf51";
        apiConnector.redirectOnHostBlocked = true;
            addChild(apiConnector);
            

            // center connector on screen
            if(stage)
            {   
                
                apiConnector.x = (stage.stageWidth - apiConnector.width) / 2;
                apiConnector.y = (stage.stageHeight - apiConnector.height) / 2;
            }
        }    
    }
}