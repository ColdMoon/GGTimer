GGTimer
============

GGTimer wraps up Coronas timer functionality and adds in toggling just for fun.
	
Basic Usage
-------------------------

##### Require The Code
```lua
local GGTimer = require( "GGTimer" )
```

##### Create a timer with a function listener
```lua

local onTimer = function( event )
	print( "A", event.count )
end

local timer = GGTimer:new( 1000, onTimer, 0 )
```

##### Create a timer with a table listener
```lua

local object = {}

function object:timer( event )
	print( "B", event.count )
end

local timer = GGTimer:new( 1000, object, 0 )
```

##### Start your timer
```lua
timer:start()
```

##### Pause your timer
```lua
timer:pause()
```

##### Resume your timer
```lua
timer:resume()
```

##### Resume your timer with a new delay
```lua
timer:resume( 5000 )
```

##### Cancel your timer
```lua
timer:cancel()
```

##### Toggle your timer on every tap
```lua
local onTap = function()
	timer:toggle()
end

Runtime:addEventListener( "tap", onTap )
```

##### Destroy your timer
```lua
timer:destroy()
timer = nil
```