#macro TRACKING_ENABLED  (false && (DEBUG || PUBLISHER_DEMO))
#macro TRACKING_VERBOSE  (false && TRACKING_ENABLED)
#macro TRACKING_DATA     [current_time, self[$ "id"], ((room == 0) && (global.__previous_room < 0))? "<boot>" : room_get_name(room), ((room == 0) && (global.__previous_room < 0))? undefined : room, debug_get_callstack()]

TrackingInitialize();

function TrackingInitialize()
{
    if (variable_global_exists("__trackingInitialized")) return;
    global.__trackingInitialized = true;
    global.__previous_room = -1;
    
    if (TRACKING_ENABLED)
    {
        global.__trackingSurfaces = __ds_map_create__();
        global.__trackingLists    = __ds_map_create__();
        global.__trackingMaps     = __ds_map_create__();
        global.__trackingGrids    = __ds_map_create__();
        global.__trackingData = [
            {__name: "Surfaces", __map: global.__trackingSurfaces},
            {__name: "Lists",    __map: global.__trackingLists   },
            {__name: "Maps",     __map: global.__trackingMaps    },
            {__name: "Grids",    __map: global.__trackingGrids   },
        ];
    }
}



/// @param value...
function __TrackingTrace() 
{
	var _string = "";

	var _i = 0;
	repeat(argument_count)
	{
	    _string += string(argument[_i]);
	    ++_i;
	}

	show_debug_message(_string);

	return _string;
}

function TrackingReport()
{
    if (!TRACKING_ENABLED) return;
    
    __TrackingTrace("-----------------------------------------------------------------------------------------------------------");
    __TrackingTrace("-----------------------------------------------------------------------------------------------------------");
    __TrackingTrace("-----------------------------------------------------------------------------------------------------------");
    
    var _i = 0;
    repeat(array_length(global.__trackingData))
    {
        var _dataStruct = global.__trackingData[_i];
        var _dataMap = _dataStruct.__map;
        
        __TrackingTrace("");
        __TrackingTrace(_dataStruct.__name, " has ", ds_map_size(_dataMap), " entries...");
        
        var _hidden = 0;
        var _keys = ds_map_keys_to_array(_dataMap);
        if (is_array(_keys))
        {
            array_sort(_keys, true);
            
            var _j = 0;
            repeat(array_length(_keys))
            {
                var _key = _keys[_j];
                var _data = _dataMap[? _key];
                
                if ((_data[3] != rm_load) && (_data[3] != undefined))
                {
                    __TrackingTrace(_key, " = ", _dataMap[? _key]);
                }
                else
                {
                    ++_hidden;
                }
                
                ++_j;
            }
        }
        
        __TrackingTrace("...of which ", _hidden, " were hidden (created on boot or in rm_load)");
        __TrackingTrace("");
        
        ++_i;
    }
    
    __TrackingTrace("-----------------------------------------------------------------------------------------------------------");
    __TrackingTrace("-----------------------------------------------------------------------------------------------------------");
    __TrackingTrace("-----------------------------------------------------------------------------------------------------------");
}



#region Surfaces

#macro surface_create      SurfaceCreateTracked
#macro surface_free        SurfaceFreeTracked
#macro surface_exists      SurfaceExists
#macro __surface_create__  surface_create
#macro __surface_free__    surface_free
#macro __surface_exists__  surface_exists

function SurfaceCreateTracked(_width, _height)
{
    var _surface = __surface_create__(_width, _height);
    
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        global.__trackingSurfaces[? _surface] = TRACKING_DATA;
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Created surface ", _surface, " as ", _width, "x", _height, "          ", debug_get_callstack());
    }
    
    return _surface;
}

function SurfaceFreeTracked(_surface)
{
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        ds_map_delete(global.__trackingSurfaces, _surface);
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Freed surface ", _surface, " (", surface_get_width(_surface), "x", surface_get_height(_surface), ")          ", debug_get_callstack());
    }
    
    return __surface_free__(_surface);
}

function SurfaceExists(_surface)
{
    var _exists = __surface_exists__(_surface);
    
    if (TRACKING_ENABLED && !_exists)
    {
        TrackingInitialize();
        ds_map_delete(global.__trackingSurfaces, _surface);
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Surface ", _surface, " no longer exists          ", debug_get_callstack());
    }
    
    return _exists;
}

#endregion



#region Lists

#macro ds_list_create            DsListCreateTracked
#macro ds_list_destroy           DsListDestroyTracked
#macro ds_map_add_list           DsMapAddList
#macro ds_list_mark_as_list      DsListMarkAsList
#macro __ds_list_create__        ds_list_create
#macro __ds_list_destroy__       ds_list_destroy
#macro __ds_map_add_list__       ds_map_add_list
#macro __ds_list_mark_as_list__  ds_list_mark_as_list

function DsListCreateTracked()
{
    var _list = __ds_list_create__();
    
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        global.__trackingLists[? _list] = TRACKING_DATA;
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Created list ", _list, "          ", debug_get_callstack());
    }
    
    return _list;
}

function DsListDestroyTracked(_list)
{
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        ds_map_delete(global.__trackingLists, _list);
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Destroyed list ", _list, "          ", debug_get_callstack());
    }
    
    return __ds_list_destroy__(_list);
}

function DsMapAddList(_id, _key, _value)
{
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        ds_map_delete(global.__trackingLists, _value);
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: List ", _value, " added to map ", _id, " as \"", _key, "\", untracking list          ", debug_get_callstack());
    }
    
    return __ds_map_add_list__(_id, _key, _value);
}

function DsListMarkAsList(_id, _pos)
{
    if (TRACKING_ENABLED)
    {
        var _list = _id[| _pos];
        if (_list != undefined)
        {
            TrackingInitialize();
            ds_map_delete(global.__trackingLists, _list);
            if (TRACKING_VERBOSE) __TrackingTrace("Tracking: List ", _list, " marked for binding to list ", _id, " (pos=", _pos, "), untracking list          ", debug_get_callstack());
        }
    }
    
    return __ds_list_mark_as_list__(_id, _pos);
}

function DsListUntrack(_list)
{
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        ds_map_delete(global.__trackingLists, _list);
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Untracking list ", _list, "          ", debug_get_callstack());
    }
}

#endregion



#region Maps

#macro ds_map_create            DsMapCreateTracked
#macro ds_map_destroy           DsMapDestroyTracked
#macro ds_map_add_map           DsMapAddMap
#macro ds_list_mark_as_map      DsListMarkAsMap
#macro __ds_map_create__        ds_map_create
#macro __ds_map_destroy__       ds_map_destroy
#macro __ds_map_add_map__       ds_map_add_map
#macro __ds_list_mark_as_map__  ds_list_mark_as_map

function DsMapCreateTracked()
{
    var _map = __ds_map_create__();
    
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        global.__trackingMaps[? _map] = TRACKING_DATA;
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Created map ", _map, "          ", debug_get_callstack());
    }
    
    return _map;
}

function DsMapDestroyTracked(_map)
{
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        ds_map_delete(global.__trackingMaps, _map);
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Destroyed map ", _map, "          ", debug_get_callstack());
    }
    
    return __ds_map_destroy__(_map);
}

function DsMapAddMap(_id, _key, _value)
{
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        ds_map_delete(global.__trackingMaps, _value);
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Map ", _value, " added to map ", _id, " as \"", _key, "\", untracking map          ", debug_get_callstack());
    }
    
    return __ds_map_add_map__(_id, _key, _value)
}

function DsListMarkAsMap(_id, _pos)
{
    if (TRACKING_ENABLED)
    {
        var _map = _id[| _pos];
        if (_map != undefined)
        {
            TrackingInitialize();
            ds_map_delete(global.__trackingMaps, _map);
            if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Map ", _map, " marked for binding to list ", _id, " (pos=", _pos, "), untracking map          ", debug_get_callstack());
        }
    }
    
    return __ds_list_mark_as_map__(_id, _pos);
}

#endregion



#region Grids

#macro ds_grid_create       DsGridCreateTracked
#macro ds_grid_destroy      DsGridDestroyTracked
#macro __ds_grid_create__   ds_grid_create
#macro __ds_grid_destroy__  ds_grid_destroy

function DsGridCreateTracked(_width, _height)
{
    var _grid = __ds_grid_create__(_width, _height);
    
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        global.__trackingGrids[? _grid] = TRACKING_DATA;
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Created grid ", _grid, " as ", _width, "x", _height, "          ", debug_get_callstack());
    }
    
    return _grid;
}

function DsGridDestroyTracked(_grid)
{
    if (TRACKING_ENABLED)
    {
        TrackingInitialize();
        ds_map_delete(global.__trackingGrids, _grid);
        if (TRACKING_VERBOSE) __TrackingTrace("Tracking: Destroyed grid ", _grid, " (", ds_grid_width(_grid), "x", ds_grid_height(_grid), ")          ", debug_get_callstack());
    }
    
    return __ds_grid_destroy__(_grid);
}

#endregion
