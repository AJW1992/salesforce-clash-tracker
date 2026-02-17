Id runningUserId = UserInfo.getUserId();
PermissionSet clashTrackerAdmin = [SELECT Id FROM PermissionSet WHERE Name = 'Clash_Tracker_Admin' LIMIT 1];
insert new PermissionSetAssignment(
    PermissionSetId = clashTrackerAdmin.Id,
    AssigneeId = runningUserId
);