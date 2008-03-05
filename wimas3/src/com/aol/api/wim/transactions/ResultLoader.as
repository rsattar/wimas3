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
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.Timer;

    /**
     * This class performs the same functions
     * as an URLLoader, except it can handle storing
     * a context object. Also, it contains some code
     * to unify the connectivity errors between different
     * browser instances.
     */
    public class ResultLoader extends URLLoader {
        
        /**
         * This context object can be set before the load() request is made.
         * It can then be retrieved by the calling application to retrieve its
         * context.
         */
        public var context:Object;
        
        /**
         * If <code>maxTimeoutMs</code> is non-zero, a timeout timer is fired,
         * which waits maxTimeoutMs milliseconds before firing an IOError. 
         * 
         * To prevent a timer from running, set this back to 0.
         */        
        public var maxTimeoutMs:int     =   0;
        
        protected var maxTimeoutTimer:Timer;
        
        public function ResultLoader(request:URLRequest=null, maxTimeoutMs:int=0, context:Object=null) {
            
            super(request);
            this.maxTimeoutMs = maxTimeoutMs;
            this.context = context;
        }
        
        /**
         * This override adds the check for the existence of a non-zero
         * maxTimeoutMs. If it is non-zero, a timer is created to handle
         * the case when a network request exceeds the time allotted for it. 
         * @param request
         * 
         */        
        public override function load(request:URLRequest):void {
            // Start the timeout timer if we have a non-zero timeout.
            if(maxTimeoutMs > 0) {
                startTimeoutTimer();
            }
            super.load(request);
        }
        
        /**
         * This function is called when <code>maxTimeoutMs</code> is non-zero, and
         * we don't receive a response from the server within our specified maximum 
         * timeout range. This usually indicates that we lost connection with the server.
         *  
         * If this is called, the <code>ResultLoader</code> will fire an 
         * <code>IOErrorEvent</code> 
         * @param evt
         * 
         */        
        protected function onTimeoutExceeded(evt:TimerEvent):void {
            //trace("Timeout exceeded!");
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Timeout exceeded"));
        }
        
        /**
         * The 'dispatchEvent' gets overridden so taht we can correctly cancel
         * the maxTimeoutTimer, if needed. 
         * @param event
         * @return 
         * 
         */        
        public override function dispatchEvent(event:Event):Boolean {
            if((event is Event && event.type == Event.COMPLETE) || 
                event is IOErrorEvent || event is SecurityErrorEvent) {
                // Clear the timer
                //trace("clearing the timer on a "+event.type+" event");
                stopTimeoutTimer();
                
            }
            return super.dispatchEvent(event);
        }
        
        // Timer Events //////////////////////////////////////
        /**
         * Starts the timeout timer. If the timer is completed, the maximum 
         * timeout of the request has been exceeded. 
         * 
         */        
        protected function startTimeoutTimer():void {
            if(!maxTimeoutTimer) {
                maxTimeoutTimer = new Timer(maxTimeoutMs, 1);
                maxTimeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeoutExceeded, false, 0, true);
            }
            maxTimeoutTimer.delay = maxTimeoutMs;
            maxTimeoutTimer.start();
        }
        
        /**
         * Stops the timeout timer if it is running. This will prevent a
         * "timer exceeded" timer event from firing. 
         * 
         */        
        protected function stopTimeoutTimer():void {
            if(maxTimeoutTimer && maxTimeoutTimer.running) {
                maxTimeoutTimer.stop();
            }
        }
    }
}