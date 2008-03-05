package com.aol.api.wim
{
    import com.aol.api.MockURLLoader;
    import com.aol.api.logging.ILog;
    import com.aol.api.openauth.MockClientLogin;
    
    import flash.display.DisplayObjectContainer;

    /**
     * <p>This slightly modifies the <code>Session</code> object to support a mock server.</p>
     * 
     * @author rizwan
     * 
     */
    public class MockSession extends Session
    {
        public function MockSession(stageOrContainer:DisplayObjectContainer, developerKey:String, clientName:String=null, clientVersion:String=null, logger:ILog=null, wimBaseURL:String=null, authBaseURL:String=null)
        {
            super(stageOrContainer, developerKey, clientName, clientVersion, logger, wimBaseURL, authBaseURL);

            _authClass = MockClientLogin;
            _loaderClass = MockURLLoader;
        }
        
        public function runFetchEventsNow():void {
            if(this._fetchTimer && this._fetchTimer.running) {
                this._fetchTimer.stop();
            }
            this.fetchEvents(null);
        }
        
        public function set autoFetchEvents(b:Boolean):void {
            super._autoFetchEvents = b;
        }
        
        public function get autoFetchEvents():Boolean {
            return super._autoFetchEvents;
        }
    }
}