package com.aol.api.wim.testing.mockobjects
{
    import com.aol.api.logging.Log;

    public class MockLog extends Log
    {
        public var assertions:Function = null;
        
        override protected function write(date:String, levelName:String, message:String):void {
            super.write(date, levelName, message);
            if (assertions != null) {
                assertions.call(null, date, levelName, message);
            }
        }
        
    }
}