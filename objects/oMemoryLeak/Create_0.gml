surfaceLeak = surface_create(32, 32);
surfaceSafe = surface_create(42, 52);

listLeak = ds_list_create();
listSafe = ds_list_create();

mapLeak = ds_map_create();
mapSafe = ds_map_create();

gridLeak = ds_grid_create(1, 4);
gridSafe = ds_grid_create(2, 3);

priorityLeak = ds_priority_create();
prioritySafe = ds_priority_create();

mpGridLeak = mp_grid_create(1, 4, 4, 5, 32, 64);
mpGridSafe = mp_grid_create(2, 3, 5, 4, 64, 32);

pathLeak = path_add();
pathSafe = path_add();

jsonLeak = json_decode("[[], []]");
jsonSafe = json_decode("{\"a\":[[], []], \"b\": {}}");

room_goto_next();
