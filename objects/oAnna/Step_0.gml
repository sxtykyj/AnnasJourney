if(!global.dialog || (global.dialog && global.checkRoom == "rLevel1_2")) {
	var left_n1_right_p1; // -1 for left, 1 for right
	var facing = STAND;
	if(!global.mouseControl) {
		/// @description Anna movement
		var key_left = keyboard_check(ord("A")) or keyboard_check(vk_left);
		var key_right = keyboard_check(ord("D")) or keyboard_check(vk_right);
		var key_jump = keyboard_check_pressed(ord("W")) or keyboard_check(vk_up);
		var open_door = keyboard_check_pressed(ord("F"));

		if(place_meeting(x, y, oDoor) && global.hasKey == 1 && open_door){
			global.hasOpen = 1;
			audio_play_sound(sndOpenDoor, 1, false);
		}

		left_n1_right_p1 = key_right - key_left;
	} else if(global.mouseControl){
		if(x - 24 - mouse_x > 0) {
			left_n1_right_p1 = -1; // -1 for left, 1 for right
		} else if(x + 24 - mouse_x < 0) {
			left_n1_right_p1 = 1;
		} else {
			left_n1_right_p1 = 0;
		}
		if(y - 40 - mouse_y > 0) {
			key_jump = 1;
		} else {
			key_jump = 0;
		}
		if(place_meeting(x, y, oDoor) && global.hasKey == 1 && mouse_check_button_pressed(mb_right)){
			global.hasOpen = 1;
		}
	}

	if(left_n1_right_p1 == -1){
		facing = LEFT;
		direct = LEFT;
	} else if(left_n1_right_p1 == 1){
		facing = RIGHT;
		direct = RIGHT;
	}
	else{
		facing = STAND;
		direct = RIGHT;
	}

	var xs = left_n1_right_p1 * WALKSP;
	// walk sound play
	if(xs != 0 && ys == 0 && alarm[2] == 0) {
		audio_play_sound(sndWalk, 1, false);
		alarm[2] = 25;
	}
	if( !place_free(x + xs, y) ){
		while( place_free(x + left_n1_right_p1, y)){
			x = x + left_n1_right_p1;
		}
		xs = 0;
	}

	if(x + xs < 0 || x + xs > room_width) {
		xs = 0;
	}
	if(y + ys < 0) {
		ys = 0;
	}
	
	x = x + xs;

	var canJump = 0;
	if( !place_free(x, y + 1) ){
		canJump = 1;
	}

	if( canJump && key_jump ){
		ys = -JUMPSP;
		audio_play_sound(sndJump, 1, false);
	}

	ys = ys + gr;
	if( !place_free(x, y + ys) ){
		while( place_free(x, y + sign(ys))){
			y = y + sign(ys);
		}
		ys = 0;
	} 
	y = y + ys;

	var inAir;
	if(ys != 0){
		inAir = INAIR;
	} else{
		inAir = INAIR_NOT;
	}
	/// Now we have facing and inAir to determine the correct sprite

	if(facing == LEFT && inAir == INAIR){
		sprite_index = sAnna_JumpLeft;
	}
	if(facing == RIGHT && inAir == INAIR_NOT){
		sprite_index = sAnna_WalkRight;
	}
	if(facing == LEFT && inAir == INAIR_NOT){
		sprite_index = sAnna_WalkLeft;
	}
	if(facing == RIGHT && inAir == INAIR){
		sprite_index = sAnna_JumpRight;
	}
	if(facing == STAND && inAir == INAIR_NOT){
		sprite_index = sAnna;
	}
	/// boundary detection
	if(y > room_height)
		room_goto(rGameOver);

	/// enemy slow attack timer setting
	if(!place_meeting(x, y, oEnemy)) {
		alarm[1] = 0;
	}
	if(alarm[2] > 0) {
		alarm[2] -= 1;
	}

	/// shield effect
	if(instance_exists(global.bossId)) {
		if(global.shield_num > 0 && !global.protect && !global.attack) {
			instance_create_depth(oAnna.x, oAnna.y, -1, oShield);
			global.protect = true;
		}
	}
	if(global.shield_num < 0) {
		global.shield_num = 0;
	}
} 
	



