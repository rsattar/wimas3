package com.aol.api.wim.data
{
    public class IMServMemberResultCode
    {
        public var memberId:String;
        public var resultCode:Number; // 0 = success, 6 = denied
        
        public function IMServMemberResultCode(aMemberId:String, aResultCode:Number):void
        {
            memberId = aMemberId;
            resultCode = aResultCode;
        }
    }
}