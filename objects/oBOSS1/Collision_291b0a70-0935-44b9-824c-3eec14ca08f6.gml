/// @description collision with bullet
/// if health is zore, destroying the enemy and adding 100 score for player.

hp_boss1 = hp_boss1 - 1;

if (hp_boss1 <= 0){
	
   with(oController) {
	
       if(!variable_instance_exists(id, "__dnd_score")) __dnd_score = 0;
	   __dnd_score += real(200);
   }


   instance_destroy();
}