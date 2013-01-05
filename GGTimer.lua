-- Project: GGTimer
--
-- Date: January 4, 2013
--
-- File name: GGTimer.lua
--
-- Author: Graham Ranson of Glitch Games - www.glitchgames.co.uk
--
-- Comments: 
--
--		GGTimer wraps up Coronas timer functionality and adds in toggling just for fun.
--
-- Copyright (C) 2012 Graham Ranson, Glitch Games Ltd.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge, 
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or 
-- substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
----------------------------------------------------------------------------------------------------

local GGTimer = {}
local GGTimer_mt = { __index = GGTimer }

--- Initiates a new GGTimer object.
-- @param delay The delay in milliseconds (e.g. 1000 = 1 second)
-- @param listener An optional listener function to be invoked. Can also be a table with a 'timer' function.
-- @param iterations The number of times the listener should be invoked. Optional, default is 1. Pass 0 to loop forever.
-- @return The new object.
function GGTimer:new( delay, listener, iterations )
    
    local self = {}
    
    setmetatable( self, GGTimer_mt )
	
	self.initialTime = delay
	self.iterations = iterations
	self.completedIterations = nil
	
	self.listener = listener
	self.timer = nil

	self.active = false
	self.paused = false
	
	self.onTimer = function( event )
		self.completedIterations = event.count
		if self.listener then
			if type( self.listener ) == "function" then
				self.listener( event )
			elseif type( self.listener ) == "table" and self.listener[ "timer" ] then
				self.listener:timer( event )
			end
		end
		self.remainingTime = self.initialTime
	end

    return self
    
end

--- Starts the timer.
-- @param time An optional new delay to use.
function GGTimer:start( time )
	self:cancel()
	self.timer = timer.performWithDelay( time or self.initialTime, self.onTimer, self.iterations )
	self.remainingTime = self.initialTime
	self.active = true
	self.paused = false
end

--- Paused the timer.
function GGTimer:pause()
	if self.timer then
		self.onPauseTime = timer.pause( self.timer )
		self.active = false
		self.paused = true
		return self.remainingTime
	end
end

--- Resumes the timer.
-- @param time An optional new delay to use.
function GGTimer:resume( time )

	if time then
		self:start( time )
	else
		if self.timer then
			self.onResumeTime = timer.resume( self.timer )
			self.active = true
			self.paused = false
			return self.remainingTime
		end
	end
	
end

--- Pauses or resumes the timer based on its current state.
-- @param time An optional new delay to use.
function GGTimer:toggle( time )
	if self.paused then
		self:resume( time )
	else
		self:pause()
	end
end

--- Cancels the timer.
function GGTimer:cancel()
	if self.timer then
		self.active = false
		timer.cancel( self.timer ) 
		self.timer = nil
		self.paused = nil
	end
end

--- Destroys this GGTimer object.
function GGTimer:destroy()
	self.listener = nil
	self.onPauseTime = nil
	self.onResumeTime = nil
	self.initialTime = nil
	self.iterations = nil
	self.timer = nil
	self.onTimer = nil
	self.active = nil
	self.paused = nil
end

return GGTimer