/* 
Copyright (c) 2008 AOL LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the AOL LCC nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
*/

package com.aol.api.wim.transactions {
    import com.aol.api.logging.ILog;
    import com.aol.api.net.ResultLoader;
    import com.aol.api.openauth.AuthToken;
    import com.aol.api.openauth.HMAC;
    import com.aol.api.wim.Session;
    import com.aol.api.wim.events.EventController;
    import com.aol.api.wim.interfaces.IResponseParser;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    
    /**
     * The <code>Transaction</code> class is the base class for all classes which make
     * request on the WIM network. Subclasses of this class should dispatch the proper events, 
     * dispatch the network requests, listen for the response and then dispatch the appropriate
     * response events. <p />
     * 
     * When creating a subclass, create a run() function and override the requestComplete()
     * function. The run() function should take in all necessary parameters and make the call to sendRequest.
     * When the request completes, the Event.COMPLETE event will fire on requestComplete(); <p />
     * 
     * The transaction classes should be designed such that only one instance is running at a time,
     * and that an instance will be re-used for subsequent requests. Some functions are included to support
     * that functionality. There is a <code>storeRequest()</code> function which will take an object and return a
     * requestId. This requestId can be passed to WIM. When WIM returns, it will include the requestId. 
     * The transaction class can then use <code>getRequest()</code> call to obtain the previously stored
     * object. <code>GetRequest</code> is a destructive call so it cannot be called more than once on the 
     * same requestId. <p />
     */

    public class Transaction {
        protected var _session:Session;
        protected var _evtDispatch:EventController;
        protected var _logger:ILog;
        protected var _parser:IResponseParser;
        
        protected var _requestCounter:uint;
        protected var _requestArray:Array;
        
        protected var _response:Object;

        public function Transaction(session:Session) {
            super();
            _requestCounter = 0;
            _requestArray = new Array();
            _session = session;
            _logger = session.logger;
            _parser = session.parser;
        }
        
        /*
        // TODO: Build out createSigBase to make signed requests easier
        public static function createSigBase(apiBaseURL:String, method:String, vars:URLVariables, requestMethod:String = "GET"):String
        {
            var sigBase:String = "";
            for(var i:String in vars)
            {
                trace(i+" : "+vars[i]);
                sigBase += "&"+i+"="+vars[i];
            }
            sigBase = vars.toString();
            return sigBase;
        }
        */
        
        /**
         * Used as the value of the "&ts=" parameter in signed queries 
         * @param authToken
         * @return 
         * 
         */        
        protected function getSigningTimestampValue(authToken:AuthToken):String
        {
            var now:Number = new Date().getTime() / 1000;           
            _logger.debug("Host Time: {0}, Now: {1}", authToken.hostTime, now);
            //queryString += "&ts="+ int(authToken.hostTime + Math.floor(now - authToken.clientTime));
            return "" + int(authToken.hostTime + Math.floor(now - authToken.clientTime));
        }
        
        protected function createSignatureFromQueryString(method:String, queryString:String):String
        {
            var encodedQuery:String = escape(queryString);
            
            
            _logger.debug("AIMBaseURL     : "+_session.apiBaseURL + method);
            _logger.debug("QueryParams    : "+queryString);
            _logger.debug("Session Key    : "+_session.sessionKey);
        
        
            // Generate OAuth Signature Base
            var sigBase:String = "GET&"+ResultLoader.encodeStrPart(_session.apiBaseURL + method)+"&"+encodedQuery;
            _logger.debug("Signature Base : "+sigBase);
            // Generate hash signature
            var sig_sha256:String = generateSignature(sigBase, _session.sessionKey);//(new HMAC()).SHA256_S_Base64(_sessionKey, sigBase);
            //_logger.debug("Signature Hash : "+encodeURIComponent(sig_sha256));
            var encodedSigParam:String = encodeURIComponent(sig_sha256);
            return encodedSigParam;
        }

        protected function generateSignature(query:String, sessionKey:String):String {
            // Generate hash signature
            var sig_sha256:String = (new HMAC()).SHA256_S(sessionKey, query);
            // Append the sig_sha256 data
            //return "&sig_sha256="+sig_sha256;
            return sig_sha256;
        }

        /**
         * Sends the request. When the request completes, <code>requestComplete</code> will
         * be called.
         *  
         * @param query The URL to load
         * @param requestMethod GET or POST
         * @param context Optional. Provide an object which can be queried on a response/error.
         * @param maxtimeoutMs Optional. If non-zero, a timer is started. An IO_ERROR is dispatched if the timer is exceeded.
         * @context See ResultLoader.  Only honored if ResultLoader is the loader type in use.
         * 
         */
        protected function sendRequest(query:String, requestMethod:String = "GET", context:Object=null, maxTimeoutMs:uint=0):void {
            var theRequest:URLRequest = new URLRequest(query);
            var loader:URLLoader = _session.createURLLoader();
            
            if (loader is ResultLoader) {
                ResultLoader(loader).context = context;
                if(maxTimeoutMs > 0)
                {
                    ResultLoader(loader).maxTimeoutMs = maxTimeoutMs;
                }
            }
            
            theRequest.method = requestMethod;
            
            loader.addEventListener(Event.COMPLETE, requestComplete, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);
            if(query.indexOf("f=amf3") >= 0) {
                loader.dataFormat = URLLoaderDataFormat.BINARY;
            }
            loader.load(theRequest);
        }

        /**
         * Stores an object and returns a requestId. This requestId can be passed 
         * as a parameter to WIM, and WIM will return it in the response.
         *  
         * @param requestToStore The object to store
         * @return               The requestId. Use it to retrieve the object.
         * 
         */
        protected function storeRequest(requestToStore:*):uint {
            _requestArray[++_requestCounter] = requestToStore;
            return _requestCounter;
        }
        
        /**
         * Will return an object that was stored using <code>storeRequest</code> for the
         * passed in requestId. This is a destructive call and cannot be used more than once
         * for any given requestId.
         *  
         * @param requestId The requestId of the object to retreive.
         * @return          The object at the specified requestId.
         * 
         */
        protected function getRequest(requestId:uint):* {
            var obj:* = _requestArray[requestId];
            _requestArray[requestId] = null;
            return obj;
        }
        
        /**
         * This function is called when a network request is successful.
         *  
         * @param evt
         * 
         */
        protected function requestComplete(evt:Event):void {
            var loader:URLLoader = URLLoader(evt.target);
            _response = _session.getResponseObject(loader.data);
        }
        
        // Generic IO Error Event Listener
        protected function handleIOError(evt:IOErrorEvent):void {
            _logger.error("IOError");
            //FIXME: what to do here?
        }
        
        protected function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
            // really on the parent
            _session.addEventListener(type,listener,useCapture,priority,useWeakReference);
        }
        
        protected function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
            // really on the parent
            _session.removeEventListener(type,listener,useCapture);
        }
        
        protected function dispatchEvent(event:Event):Boolean {
            return _session.dispatchEvent(event);
        }
        
        // Utility functions /////////////////////////////////////////////////////
        protected function getResponseObject(data:Object):Object {
            
            var obj:Object = ByteArray(data).readObject();
            if(obj) {
                return obj.response;
            } else {
                return null;
            }
        }
    }
}