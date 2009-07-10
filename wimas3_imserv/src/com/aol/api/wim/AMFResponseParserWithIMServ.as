package com.aol.api.wim
{
    import com.aol.api.wim.data.Group;
    import com.aol.api.wim.data.IM;
    import com.aol.api.wim.data.IMServGroup;
    import com.aol.api.wim.data.IMServIM;
    import com.aol.api.wim.data.User;
    
    public class AMFResponseParserWithIMServ extends AMFResponseParser
    {
        public function AMFResponseParserWithIMServ()
        {
            super();
        }
        
        override public function parseGroup(data:*):Group
        {
            if(!data) {return null;}
            
            var basicGroup:Group = super.parseGroup(data);
            if(data.hasOwnProperty("imserv"))
            {
                // "upgrade" the group to an IMServGroup
                var g:IMServGroup = new IMServGroup(basicGroup.label, data.imserv, basicGroup.users);
                g.recent = basicGroup.recent;
                g.smart = basicGroup.smart;
                return g;
            }
            else
            {
                return basicGroup;
            }
        }
        
        override public function parseIM(data:*, recipient:User=null, isOffline:Boolean=false, incoming:Boolean=true):IM
        {
            if(!data) { return null; }
            
            var basicIM:IM = super.parseIM(data, recipient, isOffline, incoming);
            /* AS OF 04/20/2009
            data    Object (@16664ee9)  
                autoresponse    0   
                imserv  "anotherchat-05ndaopag@blast.aim.com"   
                message "(<B>rizwansattar04</B>) o hai" 
                rawMsg  Object (@16664719)  
                    base64Msg   "KDxCPnJpendhbnNhdHRhcjA0PC9CPikgPEhUTUw+byBoYWk8L0hUTUw+"  
                source  Object (@166642b9)  
                    aimId   "[anotherchat]" 
                    displayId   "[Another chat]"    
                    imserv  "anotherchat-05ndaopag@blast.aim.com"   
                    onlineTime  0   
                    presenceIcon    "http://o.aolcdn.com/aim/img/online.gif"    
                    state   "online"    
                    userType    "imserv"    
                specialData Object (@16664f89)  
                    rid1011 Object (@166646f1)  
                        param1  "rizwansattar04"    
                        param2  "<HTML>o hai</HTML>"    
                specialIM   "imservMsg" 
                timestamp   1240271646 [0x49ed0b1e] 
                        
            */
            if(data.hasOwnProperty("imserv"))
            {
                var imservIMInfo:IMServIM = new IMServIM(basicIM.message, basicIM.timestamp, null, data.imserv);
                if(data.specialData && data.specialData.rid1011)
                {
                    imservIMInfo.senderId = data.specialData.rid1011.param1;
                }
                
                basicIM.specialIMType = data.specialIM;
                basicIM.specialIMInfo = imservIMInfo;
                
                return basicIM;
            }
            else
            {
                return basicIM;
            }
        }
    }
}