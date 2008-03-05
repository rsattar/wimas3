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
	
    /**
     *  Static class containing constants for use in the <code>level</code> property of com.aol.api.logging.Log.log.
     */
    public final class LogEventLevel
    {
        /**
         *  Grrrk!  Designates events that are very harmful and will eventually lead to application failure.
         */
        public static const FATAL:int = 1000;
    
        /**
         *  Ack!  Designates error events that might still allow the application to continue running.
         */
        public static const ERROR:int = 8;
        
        /**
         *  Hey!  Designates events that could be harmful to the application operation.
         */
        public static const WARN:int = 6;
        
        /**
         *  Oh!  Designates informational messages that highlight the progress of the application at coarse-grained level.
         */
        public static const INFO:int = 4;
        
        /**
         *  Heh! Designates informational level messages that are fine grained and most helpful when debugging an application.
         */
        public static const DEBUG:int = 2;
        
        /**
         *  Whoa!
         */
        public static const ALL:int = 0;
        
        public static function toName(level:int):String {
            switch (level) {
                case FATAL:
                    return "FATAL";
                case ERROR:
                    return "ERROR";
                 case WARN:
                    return "WARN";
                case INFO:
                    return "INFO";
                case DEBUG:
                    return "DEBUG";
                default:
                    return "UNKNOWN LEVEL";
            }
        }   
    }
}
