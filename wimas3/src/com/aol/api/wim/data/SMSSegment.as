package com.aol.api.wim.data
{
    public class SMSSegment
    {
        // Number of bytes that can be sent in a single segment message            
        public var single:uint;
        
        // Number of bytes in the first segment of a multi-segment IM
        public var initial:uint;
        
        // Number of bytes in second or later segment of a multisegment IM
        public var trailing:uint;
    }
}