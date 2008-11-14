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

package com.aol.api.logging
{
	import com.aol.api.Version;
	
	import flash.utils.getQualifiedClassName;

    /**
     * A very light-weight, zero-configuration logger.  The purpose of this logger is to be one step better than trace.  
     * In fact, it uses trace but it prints a header on the first log line and adds a timestamp to each line.  Unlike mx.logging.Log, this 
     * logger doesn't require that you setup targets, etc. but it's also not configurable.  The point was to use the same primary
     * logging API as mx.logging.ILog for ease of use but to keep the footprint extremely small.
     * 
     * <p>
     * Log also support pretty printing of Ojbects, treating them the as associative arrays they are.  Unfortuntely, AS3 can only iterate
     * over "enumerated" properties but this can still be useful when dealing with certain objects such as data returned in AMF3 format.
     * </p>
     * 
     * <p>
     * I am considering making logging conditional so that its compiled out in release builds.
     * </p>
     * 
     */
    public class Log implements ILog
    {
    	public var fieldSeparator:String = " ";
    	
    	public function Log(category:String="") {
    		super();
        	_category = category;
    	}
    	
        /**
          * @inheritDoc
          */    
        public function get category():String {
            return _category;
        }

        /**
          * @inheritDoc
          */            
        public function log(level:int, message:String, ...rest):void {
            if (level < LogEventLevel.DEBUG) {
                throw new ArgumentError("logging level below DEBUG is restricted by mx.logging.LogLogger, this class dutifully replicates that restriction");    
            }
            for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{"+i+"\\}", "g"), prettyPrintObject(rest[i]));
            }
            var d:Date = new Date();
            var date:String = Number(d.getMonth() + 1).toString() + "/" +
                d.getDate().toString() + "/" + 
                d.getFullYear() + fieldSeparator +
                padTime(d.getHours()) + ":" +
                padTime(d.getMinutes()) + ":" +
                padTime(d.getSeconds()) + "." +
                padTime(d.getMilliseconds(), true);
 
            var levelName:String = "[" + LogEventLevel.toName(level) + "]";
                  
            write(date, levelName, message);                                    
        } 
        
        /**
          * @inheritDoc
          */    
        public function debug(message:String, ...rest):void {
        	for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{"+i+"\\}", "g"), prettyPrintObject(rest[i]));
            }
            log(LogEventLevel.DEBUG, message);
        }
        
        /**
          * @inheritDoc
          */    
        public function error(message:String, ...rest):void {
        	for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{"+i+"\\}", "g"), prettyPrintObject(rest[i]));
            }
            log(LogEventLevel.ERROR, message);
        }
        
        /**
          * @inheritDoc
          */    
        public function fatal(message:String, ...rest):void {
        	for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{"+i+"\\}", "g"), prettyPrintObject(rest[i]));
            }
            log(LogEventLevel.FATAL, message);
        }
        
        /**
          * @inheritDoc
          */    
        public function info(message:String, ...rest):void {
        	for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{"+i+"\\}", "g"), prettyPrintObject(rest[i]));
            }
            log(LogEventLevel.INFO, message);
        }
        
        /**
          * @inheritDoc
          */    
        public function warn(message:String, ...rest):void {
        	for (var i:int = 0; i < rest.length; i++) {
                message = message.replace(new RegExp("\\{"+i+"\\}", "g"), prettyPrintObject(rest[i]));
            }
            log(LogEventLevel.WARN, message);
        }
        
        protected function write(date:String, levelName:String, message:String):void {
        	if (_printVersion) {
        		_printVersion = false;
        		trace("\r\nlogging started for wimas3 library version " + Version.NUMBER);
        	}
        	
            trace(date + fieldSeparator + levelName + fieldSeparator + message);
        }
        
        private var _category:String;
        private static var _printVersion:Boolean = true;
        
        private function padTime(number:Number, millis:Boolean = false):String {
            if (millis) {
                if (number < 10)
                    return "00" + number.toString();
                else if (number < 100)
                    return "0" + number.toString();
                else 
                    return number.toString();
            } else {
                return number > 9 ? number.toString() : "0" + number.toString();
            }
        }
        
        private function prettyPrintObject(object:Object, spaces:int=4):String {
			
			if (object == null) {
			    return "null";
			}
			
			if ((object is String) || (object is Number) || (object is Date) || (object is Boolean)) {
				return object.toString();
			}
						
			var tab:String = new String();
			for (var i:int=0; i<spaces; i++) {
				tab+=" ";
			}
		
			var objectAsText:String = new String();
		
		    // Let's not go more than 10 levels down.
		    if (spaces <= 4*10)
		    {
            	for (var prop:Object in object) {
            		objectAsText += " \n" + tab + prop + " (" + getQualifiedClassName(object[prop]) + "): " + 
            		  prettyPrintObject(object[prop], spaces+4);
            	}
            }
            else
            {
                objectAsText = object.toString();
            }   
        	
        	// If the object has no enumerable properties, there's not much we can do.
        	// There is some chance that we could get more information about the object by using describeObject but 
        	// that could be a whole bunch of work and i'm not sure it will actually pan out.
        	if (objectAsText.length == 0) {
				objectAsText = object.toString();
        	}
        	
        	return objectAsText;
        }
        
    }
}