package com.aol.api {
    
    import com.aol.api.wim.transactions.ResultLoader;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.utils.ByteArray;
    import flash.utils.Timer;

    public class MockURLLoader extends ResultLoader {
        protected var _networkTimer:Timer           =   null;
        protected var _variables:URLVariables       =   null;
        /**
         * You can parameterize the default network 'latency' amount between a request and response
         */        
        public static var networkDelayMs:uint     =   100;//0.5;
        /**
         * You can customize the delay amount for an empty fetch events request.
         */     
        public static var emptyFetchEventsNetworkDelayMs:uint = 5000;
          
        public function MockURLLoader(request:URLRequest=null, maxTimeoutMs:int=0, context:Object=null) {
            super(request, maxTimeoutMs, context);
            _networkTimer = new Timer(500, 1);
            _networkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onNetworkTimerComplete);
        }
        
        /**
         * Investigate the url request and determine what kind of response we have to fake. 
         * @param request
         * 
         */        
        public override function load(request:URLRequest):void {
            currentRequest = request;
            // Make the request to the singleton server instance
            var response:* = MockServer.getInstance().handleRequest(request);
            // If the response is null, we should pretend to have lost connection with the server
            if(response == null) {
                onTimeoutExceeded(null);
                return;
            }
            
            if(response is XML) {
                this.data = response;
            } else if (response is Object) {
                this.data = toAMF(response);
            }
            
            
            // Fake a longer timeout for fetchevents for now, just because it's spiking CPU
            
            // If this is a fetchEvents and there are no events, then wait 5 seconds, otherwise return immediately
            if(request.url.indexOf("aim/fetchEvents") >= 0 && response.data && response.data.events && response.data.events.length == 0) {
                _networkTimer.delay = emptyFetchEventsNetworkDelayMs;
            } else {
                _networkTimer.delay = networkDelayMs;
            }
            //_networkTimer.delay = (request.url.indexOf("aim/fetchEvents") >= 0 && response.data.events.length == 0) ? emptyFetchEventsNetworkDelayMs : ;
            _networkTimer.start();    
        }
        
        /**
         * Cancels the <code>_networkTimer</code> from running and completing. 
         * 
         */        
        public override function close():void {
            if(_networkTimer && _networkTimer.running) {
                _networkTimer.stop();
            }            
        }
        
        // Timer Event Handlers
         
        /**
         * Override to disable calling 'close' on a stream that was never opened
         * @param evt
         * 
         */        
        protected override function onTimeoutExceeded(evt:TimerEvent):void {
            trace("Timeout exceeded ("+(maxTimeoutMs/1000)+"s) requesting URL: "+(currentRequest ? currentRequest.url : "(unavailable)"));
            
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Timeout exceeded"));
        }
        
        /**
         * Our timer to simulate network latency is complete. Normally we will
         * dispatch a <code>COMPLETE</code> event.
         * @param evt
         * 
         */        
        protected function onNetworkTimerComplete(evt:TimerEvent):void {
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        // Utility functions /////////////////////////////////////////////////////
        protected function toAMF(data:Object):Object {
            var responseWrapper:Object = new Object();
            responseWrapper.response = data;
            
            var responseByteArray:ByteArray = new ByteArray();
            responseByteArray.writeObject(responseWrapper);
            responseByteArray.position = 0;
            return Object(responseByteArray);
//            
//            var obj:Object = ByteArray(data).readObject();
//            if(obj) {
//                return obj.response;
//            } else {
//                return null;
//            }
        }
    }
}