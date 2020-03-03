public struct Timecraft.RetroGame.GamepadDPad {
	int32 axis_values[2];
}

public struct Timecraft.RetroGame.GamepadInput {
	uint16 type;
	uint16 code;
}

public struct Timecraft.RetroGame.GamepadInputSource {
	GamepadInput input;
	string source;
}

public struct Timecraft.RetroGame.HighlightId {
    string button_id;
    bool highlight;
}
/*
uint16, uint1pu6, string
;
*/
