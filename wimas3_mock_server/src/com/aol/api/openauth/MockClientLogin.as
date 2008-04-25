package com.aol.api.openauth
{
    import com.aol.api.MockURLLoader;
    import com.aol.api.logging.ILog;
    
    public class MockClientLogin extends ClientLogin
    {
        public function MockClientLogin(dev:String, clientName:String, clientVersion:String, logger:ILog=null, authBaseURL:String=null, language:String="en-us")
        {
            super(dev, clientName, clientVersion, logger, authBaseURL, language);
            _loaderClass = MockURLLoader;
        }
        
    }
}