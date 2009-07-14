package com.aol.api.wim
{
    import com.aol.api.logging.ILog;
    import com.aol.api.wim.data.IMServInfo;
    import com.aol.api.wim.data.IMServUserSettings;
    import com.aol.api.wim.transactions.imserv.CreateIMServ;
    import com.aol.api.wim.transactions.imserv.DeleteIMServ;
    import com.aol.api.wim.transactions.imserv.GetIMServMembers;
    import com.aol.api.wim.transactions.imserv.GetIMServRecentIMs;
    import com.aol.api.wim.transactions.imserv.GetIMServSettings;
    import com.aol.api.wim.transactions.imserv.GetIMServUserSettings;
    import com.aol.api.wim.transactions.imserv.GetMyIMServs;
    import com.aol.api.wim.transactions.imserv.GetRecentIMServActivity;
    import com.aol.api.wim.transactions.imserv.InviteMembersToIMServ;
    import com.aol.api.wim.transactions.imserv.JoinIMServ;
    import com.aol.api.wim.transactions.imserv.RejectIMServ;
    import com.aol.api.wim.transactions.imserv.RemoveIMServMembers;
    import com.aol.api.wim.transactions.imserv.SetIMServSettings;
    import com.aol.api.wim.transactions.imserv.SetIMServUserSettings;
    
    import flash.display.DisplayObjectContainer;

    public class SessionWithIMServ extends Session
    {
        public function SessionWithIMServ(stageOrContainer:DisplayObjectContainer, developerKey:String, clientName:String=null, clientVersion:String=null, logger:ILog=null, wimBaseURL:String=null, authBaseURL:String=null, lifestreamBaseURL:String=null, language:String="en-us")
        {
            super(stageOrContainer, developerKey, clientName, clientVersion, logger, wimBaseURL, authBaseURL, lifestreamBaseURL, language);
            // Update our parser
            this._parser = new AMFResponseParserWithIMServ();
        }
        
        // IM Blast related functions
        
        public function createIMServ(name:String, domainName:String, description:String, senderTypesAllowed:Array, 
                                     membershipPolicy:String, imReplyType:String="sender", blDisplayType:String="withMembers",
                                     enabled:Boolean = true, buddyIconId:String = null, smallBuddyIconId:String = null, imSoundId:String = null, optionalContext:Object = null):void
        {
            if(!_transactions.CreateIMServ)
            {
                _transactions.CreateIMServ = new CreateIMServ(this);
            }
            var info:IMServInfo = new IMServInfo();
            info.friendlyName = name;
            info.domainName = domainName;
            info.description = description;
            info.senderTypesAllowed = senderTypesAllowed;
            info.membershipPolicy = membershipPolicy;
            info.imReplyType = imReplyType;
            info.blDisplayType = blDisplayType;
            info.enabled = enabled;
            info.buddyIconId = buddyIconId;
            info.smallBuddyIconId = smallBuddyIconId;
            info.imSoundId = imSoundId;
            
            (_transactions.CreateIMServ as CreateIMServ).run(info, optionalContext);
            
        }
        
        /**
         * Deletes an IMserv, given an id 
         * @param imServId
         * 
         */        
        public function deleteIMServ(imServId:String, optionalContext:Object = null):void
        {
            if(!_transactions.DeleteIMServ)
            {
                _transactions.DeleteIMServ = new DeleteIMServ(this);
            }
            
            (_transactions.DeleteIMServ as DeleteIMServ).run(imServId, optionalContext);
        }
        
        /**
         * Gets IMServ settings, given an imserv id
         * 
         * @param imServId
         * 
         */        
        public function requestIMServSettings(imServId:String, optionalContext:Object = null):void
        {
            if(!_transactions.GetIMServSettings)
            {
                _transactions.GetIMServSettings = new GetIMServSettings(this);
            }
            (_transactions.GetIMServSettings as GetIMServSettings).run(imServId, optionalContext);
        }
        
        
        /**
         * Updates settings on an IMServ you are an owner/editor of. To leave fields as they are,
         * leave them as 'null' or for numerical fields, as NaN. To clear a field, use an empty string ("").
         * 
         * The 'enabled' property is always honored
         *  
         * @param imServUpdatedFields An <code>IMServInfo</code> object with all the fields to edit non-null. The 'id' and 'enabled' property must be set.
         * 
         */        
        public function setIMServSettings(imServUpdatedFields:IMServInfo, optionalContext:Object = null):void
        {
            if(!imServUpdatedFields || !imServUpdatedFields.id) return;
            if(!_transactions.SetIMServSettings)
            {
                _transactions.SetIMServSettings = new SetIMServSettings(this);
            }
            (_transactions.SetIMServSettings as SetIMServSettings).run(imServUpdatedFields, optionalContext);
        }
        
        /**
         * Requests IMServ settings for this session's user. It tells our association with the imserv, as well as some user-controllable
         * options that are set (such as how to display it in our BL, whether to receive IMF updates, etc) 
         * 
         * @param imServId The id of the imserv to investigate
         */        
        public function requestIMServUserSettings(imServId:String, optionalContext:Object = null):void
        {
            if(!_transactions.GetIMServUserSettings)
            {
                _transactions.GetIMServUserSettings = new GetIMServUserSettings(this);
            }
            (_transactions.GetIMServUserSettings as GetIMServUserSettings).run(imServId, optionalContext);
        }
        
        /**
         * Update user settings for an IMServ. We may or may not be an owner of this imserv.
         *  
         * @param imServId The imserv id whose settings to edit
         * @param userAimId The related aimId for whom this should be edited. If editing for yourself, use _session.myInfo.aimId
         * @param settings The settings that will be uploaded
         * 
         */        
        public function setIMServUserSettings(imServId:String, userAimId:String, settings:IMServUserSettings, optionalContext:Object = null):void
        {
            if(!_transactions.SetIMServUserSettings)
            {
                _transactions.SetIMServUserSettings = new SetIMServUserSettings(this);
            }
            (_transactions.SetIMServUserSettings as SetIMServUserSettings).run(imServId, userAimId, settings, optionalContext);
        }
        
        /**
         * Gets the list of IMServs that we are a member of. 
         * 
         * @param numberToGet The number of results to return
         * @param numberToSkip Optional. Default is 0. This is useful for displaying paginated UIs
         * @param filters Filters the type of IMservs to return
         * @param sortOrder Optional. The order of the IMServs to be returned.
         * 
         */        
        public function requestIMServList(numberToGet:Number, numberToSkip:Number=0, filters:Array=null, sortOrder:String = "none", optionalContext:Object = null):void
        {
            if(!_transactions.GetMyIMServs)
            {
                _transactions.GetMyIMServs = new GetMyIMServs(this);
            }

            (_transactions.GetMyIMServs as GetMyIMServs).run(filters, sortOrder, numberToGet, numberToSkip, optionalContext);
        }

        /**
         * Gets the recent activities for the supplied imserv ids. Note that if multiple imserv ids are supplied, then a
         * separate <code>IMServQueryEvent.IMSERV_RECENT_ACTIVITY_GET_RESULT</code> will fire for each imserv in the response.
         * 
         * So it is possible for one request to generate multiple <code>IMServQueryEvent.IMSERV_RECENT_ACTIVITY_GET_RESULT</code>'s.
         * 
         * @param imServIds String or Array. Supply a list of imserv ids or a single id as a string to query
         * @param numberToGet The number of results to return
         * @param numberToSkip Optional. Default is 0. This is useful for displaying paginated UIs
         * @param filters Filters the type of activities to return
         * @param sortOrder Optional. The order of the activities to be returned.
         * 
         */         
        public function requestIMServRecentActivities(imServIdOrIds:*, numberToGet:Number, numberToSkip:Number=0, filters:Array=null, sortOrder:String = "none", optionalContext:Object = null):void
        {
            if(!_transactions.GetRecentIMServActivity)
            {
                _transactions.GetRecentIMServActivity = new GetRecentIMServActivity(this);
            }
            var imServIds:Array = null;
            if(imServIdOrIds is String)
            {
                imServIds = [imServIdOrIds];
            }
            else if(imServIdOrIds is Array)
            {
                imServIds = imServIdOrIds;
            }
            (_transactions.GetRecentIMServActivity as GetRecentIMServActivity).run(imServIds, filters, sortOrder, numberToGet, numberToSkip, optionalContext);
        }

        /**
         * Gets the recent im for the supplied imserv id.
         * 
         * @param imServId String imserv id for whose ims we want
         * @param numberToGet The number of results to return
         * @param numberToSkip Optional. Default is 0. This is useful for displaying paginated UIs
         * @param filters Filters the type of im to return
         * @param sortOrder Optional. The order of the ims to be returned.
         * 
         */         
        public function requestIMServRecentIMs(imServId:String, numberToGet:Number, numberToSkip:Number=0, filters:Array=null, sortOrder:String = "none", optionalContext:Object = null):void
        {
            if(!_transactions.GetIMServRecentIMs)
            {
                _transactions.GetIMServRecentIMs = new GetIMServRecentIMs(this);
            }
            (_transactions.GetIMServRecentIMs as GetIMServRecentIMs).run(imServId, filters, sortOrder, numberToGet, numberToSkip, optionalContext);
        }

        /**
         * Gets the recent im for the supplied imserv id.
         * 
         * @param imServId String imserv id for whose ims we want
         * @param numberToGet The number of results to return
         * @param numberToSkip Optional. Default is 0. This is useful for displaying paginated UIs
         * @param filters Filters the type of im to return
         * @param sortOrder Optional. The order of the ims to be returned.
         * 
         */         
        public function requestIMServMembers(imServId:String, numberToGet:Number, numberToSkip:Number=0, filters:Array=null, sortOrder:String = "none", optionalContext:Object = null):void
        {
            if(!_transactions.GetIMServMembers)
            {
                _transactions.GetIMServMembers = new GetIMServMembers(this);
            }
            (_transactions.GetIMServMembers as GetIMServMembers).run(imServId, filters, sortOrder, numberToGet, numberToSkip, optionalContext);
        }
        
        // IMServ Actions
        
        /**
         * Invite users with their aimIds to the imserv. You can optionally choose to transfer ownership of the imserv to the targets
         *  
         * @param imServId The imserv to which we want to invite some aimIds
         * @param aimIdsToInvite The target aimIds. At least one aimId is required.
         * @param transferOwnershipToThem Default false. If true, will request to transfer ownership of the IMServ to the targets
         * 
         */        
        public function inviteMembersToIMServ(imServId:String, aimIdsToInvite:Array, transferOwnershipToThem:Boolean=false, optionalContext:Object = null):void
        {
            if(!imServId) return;
            if(!aimIdsToInvite || aimIdsToInvite.length == 0) return;
            if(!_transactions.InviteMembersToIMServ)
            {
                _transactions.InviteMembersToIMServ = new InviteMembersToIMServ(this);
            }
            (_transactions.InviteMembersToIMServ as InviteMembersToIMServ).run(imServId, aimIdsToInvite, transferOwnershipToThem, optionalContext);
        }
        
        /**
         * Reject or withdraw invitations to designated users. If the target is ourselves, we are officially rejecting an invitation.
         *  
         * @param imServId The imserv from which we want to reject some aimIds
         * @param aimIdsToReject The target aimIds. At least one aimId is required.
         * 
         */        
        public function rejectIMServ(imServId:String, aimIdsToReject:Array, optionalContext:Object = null):void
        {
            if(!imServId) return;
            if(!aimIdsToReject || aimIdsToReject.length == 0) return;
            if(!_transactions.RejectIMServ)
            {
                _transactions.RejectIMServ = new RejectIMServ(this);
            }
            (_transactions.RejectIMServ as RejectIMServ).run(imServId, aimIdsToReject, optionalContext);
        }
        
        /**
         * Join a public IMServ, request to join an open IMServ, accept an invitation, approve a membership request by an editor
         * 
         * @param imServId The name of the imServId to be joined
         * 
         */        
        public function joinIMServ(imServId:String, optionalContext:Object = null):void
        {
            if(!imServId) return;
            if(!_transactions.JoinIMServ)
            {
                _transactions.JoinIMServ = new JoinIMServ(this);
            }
            (_transactions.JoinIMServ as JoinIMServ).run(imServId, optionalContext);
        }
        
        /**
         * Join a public IMServ, request to join an open IMServ, accept an invitation, approve a membership request by an editor
         * 
         * @param imServId The name of the imServId to be joined
         * 
         */        
        public function removeMembersFromIMServ(imServId:String, aimIdsToRemove:Array, optionalContext:Object = null):void
        {
            if(!imServId) return;
            if(!aimIdsToRemove || aimIdsToRemove.length == 0) return;
            if(!_transactions.RemoveIMServMembers)
            {
                _transactions.RemoveIMServMembers = new RemoveIMServMembers(this);
            }
            (_transactions.RemoveIMServMembers as RemoveIMServMembers).run(imServId, aimIdsToRemove, optionalContext);
        }
    }
}