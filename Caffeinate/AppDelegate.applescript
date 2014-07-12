--
--  AppDelegate.applescript
--  Caffeinate
--
--  Created by Monty on 6/24/14.
--  Copyright (c) 2014 Monty. All rights reserved.
--

script AppDelegate
	property parent : class "NSObject"
	
	-- IBOutlets
	property window : missing value
	
    -- App Properties - Monty
    property theAppName : "Caffeinate"
    property theSetMessage : "You are now caffeinated. Your display will not sleep until you allow it to do so."
    property theClearMessage : "Back to decaf mode. Your display can now go to sleep."
    -- Menu Bar Properties - Monty
    property NSImage : class "NSImage"
    property NSStatusBar : class "NSStatusBar"
    property NSStatusItem : class "NSStatusItem"
    property StatusItem : ""
    property MainMenu : missing value

	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened 
        
        -- Set Menu Bar icon
        #set StatusItem to NSStatusBar's systemStatusBar's statusItemWithLength_(current application's NSSquareStatusItemLength)
        #StatusItem's setImage_(NSImage's imageNamed_("menuIcon"))
        #StatusItem's setMenu_(MainMenu)
        #StatusItem's setHighlightMode_(true)
        
        -- Check for running process
        set isRunning to do shell script "ps ax | grep caffeinate"
        
        if isRunning contains "caffeinate -d" then
            -- send a notification to indicate "caffeinate" has been closed
            #            sendNotificationWithTitle_AndMessage_(theAppName, theClearMessage)
            -- Kill caffeinate
            do shell script "killall -9 caffeinate > /dev/null 2>&1 &"
        else
            -- send a notification to indicate "caffeinate" is running
            #            sendNotificationWithTitle_AndMessage_(theAppName, theSetMessage)
            -- activate caffeinate with preferences and no time
            do shell script "caffeinate -d > /dev/null 2>&1 &"
        end if
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
        -- send a notification to indicate "caffeinate" has been closed
        #        sendNotificationWithTitle_AndMessage_(theAppName, theClearMessage)
        -- Kill caffeinate
        do shell script "killall -9 caffeinate > /dev/null 2>&1 &"
		return current application's NSTerminateNow
	end applicationShouldTerminate_
	
    -- Method for sending a notification based on supplied title and text
    on sendNotificationWithTitle_AndMessage_(aTitle, aMessage)
        set myNotification to current application's NSUserNotification's alloc()'s init()
        set myNotification's title to aTitle
        set myNotification's informativeText to aMessage
        current application's NSUserNotificationCenter's defaultUserNotificationCenter's deliverNotification_(myNotification)
    end sendNotification

end script