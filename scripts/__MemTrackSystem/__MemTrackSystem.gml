#macro __MEM_TRACK_VERSION  "0.0.2"
#macro __MEM_TRACK_DATE     "2022-10-15"

__MemTrackInitialize();

function __MemTrackInitialize()
{
    static _initialized = false;
    if (_initialized) return;
    _initialized = true;
    
    __MemTrackTrace("Welcome to MemTrack by @jujuadams! This is version ", __MEM_TRACK_VERSION, ", ", __MEM_TRACK_DATE);
    
    if (MEMTRACK_ENABLED)
    {
        //Create these resources directly to avoid cyclical behaviour
        global.__memTrackSurfaces = __ds_map_create__();
        global.__memTrackLists    = __ds_map_create__();
        global.__memTrackMaps     = __ds_map_create__();
        global.__memTrackGrids    = __ds_map_create__();
        global.__memTrackPQueues  = __ds_map_create__();
        global.__memTrackMPGrids  = __ds_map_create__();
        
        global.__memTrackData = [
            { __name: "Surfaces",        __map: global.__memTrackSurfaces, __exists: surface_exists         },
            { __name: "Lists",           __map: global.__memTrackLists,    __exists: __MemTrackListExists   },
            { __name: "Maps",            __map: global.__memTrackMaps,     __exists: __MemTrackMapExists    },
            { __name: "Grids",           __map: global.__memTrackGrids,    __exists: __MemTrackGridExists   },
            { __name: "Priority Queues", __map: global.__memTrackPQueues,  __exists: __MemTrackPQueueExists },
            { __name: "MP Grids",        __map: global.__memTrackMPGrids,  __exists: undefined, /*GM has no functionality for this*/ },
        ];
    }
}

/// @param value...
function __MemTrackTrace() 
{
	var _string = "MemTrack: ";

	var _i = 0;
	repeat(argument_count)
	{
	    _string += string(argument[_i]);
	    ++_i;
	}

	show_debug_message(_string);

	return _string;
}
